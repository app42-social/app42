import 'package:app42/services/mock_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await SharedPreferences.setMockInitialValues({});
  });

  test('restores persisted authenticated session', () async {
    final auth = MockAuthService();

    await auth.checkCurrentUser();
    expect(auth.status, AuthStatus.unauthenticated);

    await auth.signInWithGoogle();
    expect(auth.status, AuthStatus.authenticated);
    expect(auth.currentUserName, 'Taylor Mock');

    final restoredAuth = MockAuthService();
    await restoredAuth.checkCurrentUser();

    expect(restoredAuth.status, AuthStatus.authenticated);
    expect(restoredAuth.currentUserName, 'Taylor Mock');
  });

  test('sign out clears persisted session', () async {
    final auth = MockAuthService();

    await auth.checkCurrentUser();
    await auth.signInWithGoogle();
    expect(auth.status, AuthStatus.authenticated);

    await auth.signOut();
    expect(auth.status, AuthStatus.unauthenticated);

    final freshAuth = MockAuthService();
    await freshAuth.checkCurrentUser();

    expect(freshAuth.status, AuthStatus.unauthenticated);
    expect(freshAuth.currentUserName, isNull);
  });
}
