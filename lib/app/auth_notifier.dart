import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';

enum UserRole {
  patient,
  doctor,
  admin;

  static UserRole fromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'doctor':
        return UserRole.doctor;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.patient;
    }
  }
}

enum AccountStatus {
  active,
  disabled,
  pendingVerification;

  static AccountStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'disabled':
        return AccountStatus.disabled;
      case 'pending_verification':
        return AccountStatus.pendingVerification;
      default:
        return AccountStatus.active;
    }
  }
}

class AuthNotifier extends ChangeNotifier {
  static final AuthNotifier instance = AuthNotifier._internal();
  factory AuthNotifier() => instance;
  AuthNotifier._internal();

  UserRole? _role;
  AccountStatus? _accountStatus;
  bool _isInitialized = false;
  StreamSubscription<AuthState>? _authSubscription;

  UserRole? get role => _role;
  AccountStatus? get accountStatus => _accountStatus;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => SupabaseConfig.client.auth.currentUser != null;
  bool get isAccountDisabled => _accountStatus == AccountStatus.disabled;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _authSubscription?.cancel();
    _authSubscription = SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        _loadUserProfile(data.session!.user.id);
      } else {
        _role = null;
        _accountStatus = null;
        notifyListeners();
      }
    });

    final currentUser = SupabaseConfig.client.auth.currentUser;
    if (currentUser != null) {
      await _loadUserProfile(currentUser.id);
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final res = await SupabaseConfig.client
          .from('profiles')
          .select('role, account_status')
          .eq('id', userId)
          .maybeSingle();

      if (res != null) {
        _role = UserRole.fromString(res['role'] as String?);
        _accountStatus = AccountStatus.fromString(res['account_status'] as String?);
      } else {
        // Fallback default role
        _role = UserRole.patient;
        _accountStatus = AccountStatus.active;
      }
    } catch (_) {
      // In offline / mock mode
      _role ??= UserRole.patient;
      _accountStatus ??= AccountStatus.active;
    }
    notifyListeners();
  }

  /// Sets state directly (useful for tests and mock prototypes)
  void setMockState({UserRole? role, AccountStatus? status}) {
    _role = role;
    _accountStatus = status;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
    } catch (_) {}
    _role = null;
    _accountStatus = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

