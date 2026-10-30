import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:involt/core/data/database.dart';
import 'package:involt/core/presentation/theme/app_colors.dart';
import 'package:involt/core/presentation/widgets/curved_navigation_bar.dart';
import 'package:involt/core/presentation/screens/sectors_list_screen.dart';
import 'package:involt/core/presentation/screens/search_screen.dart';
import 'package:involt/core/presentation/screens/sync_screen.dart';
import 'package:involt/core/presentation/screens/profile_screen.dart';
import 'package:involt/core/presentation/providers/app_state_provider.dart';
import 'package:involt/core/presentation/providers/photo_sync_provider.dart';
import 'package:involt/core/presentation/providers/storage_provider.dart';
import 'package:involt/core/presentation/widgets/status_bar.dart';
import 'package:involt/core/data/services/sync_service.dart';
import 'package:involt/core/config/app_config.dart';
import 'package:involt/core/presentation/screens/splash_screen.dart';
import 'package:involt/core/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider(db)),
        ChangeNotifierProvider(create: (_) => PhotoSyncProvider(db)),
        ChangeNotifierProvider(create: (_) => StorageProvider()),
      ],
      child: MyApp(db: db),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro Electrico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.volt,
        scaffoldBackgroundColor: AppColors.onyx,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: SplashScreen(db: db),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final AppDatabase db;
  const MainNavigationScreen({super.key, required this.db});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  String? _pendingSectorId;
  Timer? _backgroundTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _backgroundWork());
    _backgroundTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _backgroundWork(),
    );
  }

  @override
  void dispose() {
    _backgroundTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _backgroundWork();
  }

  /// Checks the free space and keeps uploading pending photos while the app is open.
  void _backgroundWork() {
    if (!mounted) return;
    context.read<StorageProvider>().refresh();
    final photos = context.read<PhotoSyncProvider>();
    photos.refresh();
    photos.upload(context.read<AppStateProvider>().authToken);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the global state
    final appState = context.watch<AppStateProvider>();

    if (appState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!appState.isAuthenticated) {
      return const LoginScreen();
    }

    final screens = [
      SectorsListScreen(
        db: widget.db,
        onOpenSync: () {
          setState(() {
            _currentIndex = 2;
            _pendingSectorId = null;
          });
        },
      ),
      SearchScreen(
        db: widget.db,
        initialSectorId: _pendingSectorId,
        onSectorHandled: () => _pendingSectorId = null,
      ),
      SyncScreen(db: widget.db),
      ProfileScreen(
        db: widget.db,
        syncService: SyncService(
          db: widget.db,
          baseUrl: AppConfig.baseUrl,
          authToken: appState.authToken,
        ),
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: Column(
          children: [
            const StatusBar(),
            Expanded(
              child: IndexedStack(index: _currentIndex, children: screens),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index != 1) _pendingSectorId = null;
          });
        },
      ),
    );
  }
}
