import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/io.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import '../../data/database.dart';
import '../../gen/proto/involt/v1/admin.pb.dart' as pb;
import '../../config/app_config.dart';
import '../../config/brand.dart';
import 'package:drift/drift.dart';

import 'package:bcrypt/bcrypt.dart';

class AppStateProvider extends ChangeNotifier {
  final AppDatabase db;
  String _selectedPeriod = '';
  String _authToken = '';
  String _userName = '';
  String _userRole = '';
  String _userEmail = '';
  Brand _brand = Brand.fallback;
  List<String> _availablePeriods = const [];
  bool _isLoading = true;

  AppStateProvider(this.db) {
    _init();
  }

  String get selectedPeriod => _selectedPeriod;
  String get authToken => _authToken;
  String get userName => _userName;
  String get userRole => _userRole;
  String get userEmail => _userEmail;

  /// Brand of the user's company, InVolt until a login tells us the company.
  Brand get brand => _brand;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _authToken.isNotEmpty;
  bool get isOffline => _authToken == 'OFFLINE_MODE';

  String get userRoleLabel {
    final role = _userRole.toUpperCase();
    if (role.contains('ADMIN')) return 'ADMINISTRADOR';
    if (role.contains('SUPERVISOR')) return 'SUPERVISOR';
    if (role.contains('READER')) return 'LECTOR';

    return _userRole.isNotEmpty ? _userRole : 'OPERADOR';
  }

  List<String> get availablePeriods => List.unmodifiable(_availablePeriods);

  Future<void> _init() async {
    await loadState();
  }

  Future<void> loadState() async {
    _isLoading = true;
    notifyListeners();

    final settings = await db.select(db.settings).get();
    final settingsMap = {for (var s in settings) s.key: s.value};

    _authToken = settingsMap['auth_token'] ?? '';
    _userName = settingsMap['user_name'] ?? '';
    _userRole = settingsMap['user_role'] ?? '';
    _userEmail = settingsMap['user_email'] ?? '';
    _brand = Brand.fromCompany(
      name: settingsMap['company_name'],
      entity: settingsMap['company_entity'],
    );

    final enabledPeriodsSetting = settingsMap['enabled_periods'];
    _availablePeriods = _parseEnabledPeriods(enabledPeriodsSetting);

    final currentPeriodSetting = settingsMap['current_period'];

    if (currentPeriodSetting != null) {
      _selectedPeriod = currentPeriodSetting;
    } else {
      // Default to current month if not set
      final now = DateTime.now();
      _selectedPeriod = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await setPeriod(_selectedPeriod);
    }

    if (_availablePeriods.isEmpty) {
      _availablePeriods = [_selectedPeriod];
    } else if (!_availablePeriods.contains(_selectedPeriod)) {
      _selectedPeriod = _availablePeriods.first;
      await setPeriod(_selectedPeriod);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Alias for compatibility with older screens
  Future<void> loadPeriod() => loadState();

  Future<bool> login(String email, String password) async {
    try {
      // 1. Try online login first
      return await _performLoginRpc(email, password);
    } catch (e) {
      print('❌ Login Online failed: $e. Attempting offline fallback...');
      final offlineSuccess = await _performOfflineLogin(email, password);
      if (!offlineSuccess) {
        // Rethrow the original error if offline login also fails
        rethrow;
      }
      return true;
    }
  }

  Future<bool> _performOfflineLogin(String email, String password) async {
    try {
      final operator = await (db.select(
        db.operators,
      )..where((t) => t.email.equals(email))).getSingleOrNull();

      if (operator != null) {
        // Use bcrypt to check password
        final isValid = BCrypt.checkpw(password, operator.passwordHash);
        if (isValid) {
          debugPrint('✅ Offline Login Success for $email');
          await _persistSession(
            token: 'OFFLINE_MODE',
            name: operator.email.split('@')[0].toUpperCase(),
            role: operator.role,
            email: operator.email,
          );
          return true;
        }
      }
      print('❌ Offline Login failed: User not found or invalid password');
      return false;
    } catch (e) {
      print('❌ Offline Login Error: $e');
      return false;
    }
  }

  Future<bool> _performLoginRpc(String email, String password) async {
    final transport = protocol.Transport(
      baseUrl: AppConfig.baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(io.HttpClient()),
    );

    try {
      final response = await transport.unary<pb.LoginRequest, pb.LoginResponse>(
        Spec(
          '/involt.v1.AdminService/Login',
          StreamType.unary,
          () => pb.LoginRequest(),
          () => pb.LoginResponse(),
        ),
        pb.LoginRequest(email: email, password: password),
      );

      if (response.message.token.isNotEmpty) {
        await _persistSession(
          token: response.message.token,
          // The User proto doesn't have a 'name' field yet, using email prefix as fallback
          name: response.message.user.email.split('@')[0].toUpperCase(),
          role: response.message.user.role.name,
          email: response.message.user.email,
        );
        await _persistBrand(response.message.user);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Login RPC error: $e');
      throw Exception('No se pudo conectar con el servidor. Verifica tu internet o la URL de la API.');
    }
  }

  Future<void> _persistSession({
    required String token,
    required String name,
    required String role,
    required String email,
  }) async {
    _authToken = token;
    _userName = name;
    _userRole = role;
    _userEmail = email;

    await db.batch((batch) {
      batch.insert(
        db.settings,
        SettingsCompanion.insert(key: 'auth_token', value: _authToken),
        mode: InsertMode.insertOrReplace,
      );
      batch.insert(
        db.settings,
        SettingsCompanion.insert(key: 'user_name', value: _userName),
        mode: InsertMode.insertOrReplace,
      );
      batch.insert(
        db.settings,
        SettingsCompanion.insert(key: 'user_role', value: _userRole),
        mode: InsertMode.insertOrReplace,
      );
      batch.insert(
        db.settings,
        SettingsCompanion.insert(key: 'user_email', value: _userEmail),
        mode: InsertMode.insertOrReplace,
      );
    });

    notifyListeners();
  }

  /// Saves the company brand from an online login. It survives logout so offline logins on
  /// this device keep showing it.
  Future<void> _persistBrand(pb.User user) async {
    _brand = user.hasCompany()
        ? Brand.fromCompany(name: user.company.name, entity: user.company.entity)
        : Brand.fallback;
    final values = {
      'company_name': user.hasCompany() ? user.company.name : '',
      'company_entity': user.hasCompany() ? user.company.entity : '',
    };
    await db.batch((batch) {
      for (final entry in values.entries) {
        batch.insert(
          db.settings,
          SettingsCompanion.insert(key: entry.key, value: entry.value),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    notifyListeners();
  }

  Future<void> logout() async {
    _authToken = '';
    _userName = '';
    _userRole = '';
    _userEmail = '';

    await (db.delete(db.settings)..where(
          (t) => t.key.isIn([
            'auth_token',
            'user_name',
            'user_role',
            'user_email',
          ]),
        ))
        .go();
    notifyListeners();
  }

  Future<void> setPeriod(String period) async {
    if (_availablePeriods.isNotEmpty && !_availablePeriods.contains(period)) {
      return;
    }

    _selectedPeriod = period;
    await db
        .into(db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(key: 'current_period', value: period),
        );
    notifyListeners();
  }

  List<String> _parseEnabledPeriods(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return const [];
    }

    final periods =
        raw
            .split(',')
            .map((period) => period.trim())
            .where((period) => RegExp(r'^\d{4}-\d{2}$').hasMatch(period))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    return periods;
  }
}
