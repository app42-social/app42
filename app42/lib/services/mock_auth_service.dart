import 'package:flutter/foundation.dart';

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
  AuthStatus _status = AuthStatus.unknown;
  String? _currentUserName;

  AuthStatus get status => _status;
  String? get currentUserName => _currentUserName;

  /// Simulates checking for a previously logged in user when the app launches.
  Future<void> checkCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _updateUserState(AuthStatus.unauthenticated, null);
  }

  /// Simulates signing in with Google.
  Future<void> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _updateUserState(AuthStatus.authenticated, 'Taylor Mock');
  }

  /// Allows the UI to sign out again.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _updateUserState(AuthStatus.unauthenticated, null);
  }

  void _updateUserState(AuthStatus status, String? userName) {
    if (_status == status && _currentUserName == userName) {
      return;
    }
    _status = status;
    _currentUserName = userName;
    notifyListeners();
  }
}
