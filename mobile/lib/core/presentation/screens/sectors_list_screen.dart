import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/database.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../providers/app_state_provider.dart';
import 'customers_by_sector_screen.dart';

class SectorsListScreen extends StatefulWidget {
  final AppDatabase db;
  final VoidCallback onOpenSync;

  const SectorsListScreen({
    super.key,
    required this.db,
    required this.onOpenSync,
  });

  @override
  State<SectorsListScreen> createState() => _SectorsListScreenState();
}

class _SectorsListScreenState extends State<SectorsListScreen> {
  void _showPeriodPicker(BuildContext context, String currentPeriod) {
    final appState = context.read<AppStateProvider>();
    final availablePeriods = appState.availablePeriods;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.onyx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar Periodo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              if (availablePeriods.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'No hay periodos habilitados para seleccionar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              else
                ...availablePeriods.map((p) {
                  final isSelected = p == currentPeriod;
                  return ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      color: isSelected ? AppColors.cyan : Colors.white24,
                    ),
                    title: Text(
                      p,
                      style: TextStyle(
                        color: isSelected ? AppColors.cyan : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.cyan)
                        : null,
                    onTap: () {
                      appState.setPeriod(p);
                      Navigator.pop(context);
                    },
                  );
                }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the global state
    final appState = context.watch<AppStateProvider>();
    final selectedPeriod = appState.selectedPeriod;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Hidroeléctrica Qarwaqiru Michay',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showPeriodPicker(context, selectedPeriod);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Periodo: $selectedPeriod',
                    style: const TextStyle(
                      color: AppColors.cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.cyan,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.white24, size: 20),
            onPressed: () =>
                widget.db.select(widget.db.sectors).get(), // Dummy refresh
          ),
        ],
      ),
      body: StreamBuilder<List<Sector>>(
        stream: widget.db.select(widget.db.sectors).watch(),
        builder: (context, sectorsSnapshot) {
          if (!sectorsSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.volt),
            );
          }

          return StreamBuilder<List<Customer>>(
            stream: widget.db.select(widget.db.customers).watch(),
            builder: (context, customersSnapshot) {
              // Filter readings by selected period from Provider
              return StreamBuilder<List<Reading>>(
                stream: (widget.db.select(
                  widget.db.readings,
                )..where((t) => t.period.equals(selectedPeriod))).watch(),
                builder: (context, readingsSnapshot) {
                  final sectors = sectorsSnapshot.data!;
                  final allCustomers = customersSnapshot.data ?? [];
                  final periodReadings = readingsSnapshot.data ?? [];
                  final registeredCustomerIds = periodReadings
                      .map((r) => r.customerId)
                      .toSet();

                  if (sectors.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_off_outlined,
                            size: 80,
                            color: Colors.white10,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No hay datos locales',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Sincroniza para descargar la lista\nde sectores y clientes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: widget.onOpenSync,
                            icon: const Icon(Icons.sync),
                            label: const Text('IR A SINCRONIZACIÓN'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.volt,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120, top: 10),
                    itemCount: sectors.length,
                    itemBuilder: (context, index) {
                      final sector = sectors[index];
                      final sectorCustomers = allCustomers
                          .where((c) => c.sectorId == sector.id)
                          .toList();
                      final total = sectorCustomers.length;
                      final measured = sectorCustomers
                          .where((c) => registeredCustomerIds.contains(c.id))
                          .length;
                      final percentage = total == 0
                          ? 0
                          : (measured / total * 100).toInt();

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: percentage == 100
                                    ? AppColors.cyan.withOpacity(0.1)
                                    : AppColors.volt.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: percentage == 100
                                      ? AppColors.cyan
                                      : AppColors.volt.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$measured/$total',
                                style: TextStyle(
                                  color: percentage == 100
                                      ? AppColors.cyan
                                      : AppColors.volt,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              sector.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double progress = total == 0
                                        ? 0
                                        : measured / total;
                                    return Stack(
                                      children: [
                                        Container(
                                          height: 6,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 6,
                                          width:
                                              constraints.maxWidth * progress,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.cyan,
                                                AppColors.volt,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.white24,
                              size: 20,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomersBySectorScreen(
                                    sector: sector,
                                    db: widget.db,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
