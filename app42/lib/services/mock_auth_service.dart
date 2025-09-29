import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the current authentication status of the app.
enum AuthStatus {
  /// The app is checking the current user and the state is not yet known.
  unknown,

  /// No user is currently authenticated.
  unauthenticated,

  /// A user session is active.
  authenticated,
}

/// A very small in-memory implementation that mimics the shape of an
/// authentication service enough for UI flows.
///
/// In real life this would talk to Firebase/Auth0/etc. and persist tokens.
class MockAuthService extends ChangeNotifier {
  static const _prefsKeyIsLoggedIn = 'auth.isLoggedIn';
  static const _prefsKeyUserName = 'auth.userName';

  AuthStatus _status = AuthStatus.unknown;
  String? _currentUserName;

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  AuthStatus get status => _status;
  String? get currentUserName => _currentUserName;

  /// Simulates checking for a previously logged in user when the app launches.
  Future<void> checkCurrentUser() async {
    final prefs = await _preferences;
    final wasLoggedIn = prefs.getBool(_prefsKeyIsLoggedIn) ?? false;
    final storedName = prefs.getString(_prefsKeyUserName);

    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (wasLoggedIn && storedName != null && storedName.trim().isNotEmpty) {
      _updateUserState(AuthStatus.authenticated, storedName);
    } else {
      _updateUserState(AuthStatus.unauthenticated, null);
      await _persistSession(AuthStatus.unauthenticated, null);
    }
  }

  /// Simulates signing in with Google.
  Future<void> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    const userName = 'Taylor Mock';
    _updateUserState(AuthStatus.authenticated, userName);
    await _persistSession(AuthStatus.authenticated, userName);
  }

  /// Allows the UI to sign out again.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _updateUserState(AuthStatus.unauthenticated, null);
    await _persistSession(AuthStatus.unauthenticated, null);
  }

  void _updateUserState(AuthStatus status, String? userName) {
    if (_status == status && _currentUserName == userName) {
      return;
    }
    _status = status;
    _currentUserName = userName;
    notifyListeners();
  }

  Future<void> _persistSession(AuthStatus status, String? userName) async {
    final prefs = await _preferences;
    if (status == AuthStatus.authenticated && userName != null) {
      await prefs.setBool(_prefsKeyIsLoggedIn, true);
      await prefs.setString(_prefsKeyUserName, userName);
    } else {
      await prefs.remove(_prefsKeyIsLoggedIn);
      await prefs.remove(_prefsKeyUserName);
    }
  }
}
