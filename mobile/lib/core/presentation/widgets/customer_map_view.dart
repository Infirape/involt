import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_colors.dart';
import '../../data/database.dart';

class CustomerMapView extends StatefulWidget {
  final AppDatabase db;
  final List<Customer> customers; // Filtered/Active results
  final List<Customer> allCustomers; // Full registry for background dots
  final List<Reading> readings;
  final bool isFiltering;
  final String? selectedCustomerId; // Current selection
  final Function(Customer) onCustomerTap;
  final MapController? mapController;

  final LatLng? userLocation;

  const CustomerMapView({
    super.key,
    required this.db,
    required this.customers,
    required this.allCustomers,
    this.readings = const [],
    this.isFiltering = false,
    this.selectedCustomerId,
    required this.onCustomerTap,
    this.mapController,
    this.userLocation,
  });

  @override
  State<CustomerMapView> createState() => _CustomerMapViewState();
}

class _CustomerMapViewState extends State<CustomerMapView> {
  late MapController _mapController;
  late Future<Map<String, String>> _configFuture;

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? MapController();
    _configFuture = _loadConfig();
  }

  Future<Map<String, String>> _loadConfig() async {
    final database = widget.db;
    final settings = await database.select(database.settings).get();
    final config = {
      'map_url_template': 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      'map_user_agent': 'InVoltApp/1.0 (com.infira.involt; android)',
    };
    
    for (final s in settings) {
      if (config.containsKey(s.key)) {
        config[s.key] = s.value;
      }
    }
    return config;
  }

  @override
  Widget build(BuildContext context) {
    // Initial center: User location > First customer > default
    LatLng initialCenter = const LatLng(-12.0464, -77.0428); // Lima, Perú
    if (widget.userLocation != null) {
      initialCenter = widget.userLocation!;
    } else if (widget.customers.isNotEmpty) {
      final firstWithCoords = widget.customers.firstWhere(
        (c) => c.latitude != 0 && c.longitude != 0,
        orElse: () => widget.customers.first,
      );
      if (firstWithCoords.latitude != 0) {
        initialCenter = LatLng(firstWithCoords.latitude, firstWithCoords.longitude);
      }
    }

    return FutureBuilder<Map<String, String>>(
      future: _configFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint("Error loading map config: ${snapshot.error}");
        }

        final config = snapshot.data ?? {
          'map_url_template': 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          'map_user_agent': 'InVoltApp/1.0 (com.infira.involt; android)',
        };

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 16,
            maxZoom: 22,
            onTap: (tapPosition, point) {
              // Proximity selection for CircleLayer
              Customer? nearest;
              double minDistance = 0.001; // Roughly 100m radius

              for (final c in widget.allCustomers) {
                if (c.latitude == 0) continue;
                final dist = sqrt(pow(c.latitude - point.latitude, 2) + pow(c.longitude - point.longitude, 2));
                if (dist < minDistance) {
                  minDistance = dist;
                  nearest = c;
                }
              }

              if (nearest != null) {
                widget.onCustomerTap(nearest);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: config['map_url_template']!,
              userAgentPackageName: config['map_user_agent']!,
              maxNativeZoom: 18, // ArcGIS often supports up to 18
              maxZoom: 22,
              tileProvider: NetworkTileProvider(), // Explicitly set provider
            ),
            // User Location Marker
            if (widget.userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.userLocation!,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cyan, width: 2),
                        boxShadow: [
                          BoxShadow(color: AppColors.cyan.withOpacity(0.5), blurRadius: 15, spreadRadius: 5),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.my_location, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            // 1. PERFORMANCE: Background dots for filtered sectors only
            CircleLayer(
              circles: () {
                final registeredIds = widget.readings.map((r) => r.customerId).toSet();
                // ONLY show dots if we have customers passed (which means sectors are selected)
                return widget.allCustomers.where((c) => c.latitude != 0).map((c) {
                  final bool hasReading = registeredIds.contains(c.id);
                  
                  return CircleMarker(
                    point: LatLng(c.latitude, c.longitude),
                    radius: 6,
                    color: (hasReading ? AppColors.cyan : AppColors.volt).withOpacity(0.5),
                    useRadiusInMeter: false,
                  );
                }).toList();
              }(),
            ),
            // 2. INTERACTIVE: Focused markers
            MarkerLayer(
              markers: widget.allCustomers.where((c) {
                if (c.latitude == 0) return false;
                final isSelected = c.id == widget.selectedCustomerId;
                final isFiltered = widget.isFiltering && widget.customers.any((fc) => fc.id == c.id);
                return isSelected || isFiltered;
              }).map((c) {
                final reading = widget.readings.cast<Reading?>().firstWhere((r) => r?.customerId == c.id, orElse: () => null);
                final bool hasReading = reading != null;
                final markerColor = hasReading ? AppColors.volt : AppColors.cyan;
                final isSelected = c.id == widget.selectedCustomerId;

                return Marker(
                  point: LatLng(c.latitude, c.longitude),
                  width: 80,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => widget.onCustomerTap(c),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                            boxShadow: [
                              BoxShadow(color: markerColor.withOpacity(isSelected ? 0.8 : 0.5), blurRadius: 10, spreadRadius: 2),
                            ],
                          ),
                          child: const Icon(Icons.bolt, color: Colors.black, size: 14),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: markerColor.withOpacity(0.5), width: 1),
                          ),
                          child: Text(
                            hasReading ? '${reading!.currentValue.toStringAsFixed(1)}' : c.code,
                            style: TextStyle(
                              color: hasReading ? AppColors.volt : Colors.white, 
                              fontSize: 9, 
                              fontWeight: FontWeight.bold
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }
    );
  }
}
