import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/mock_auth_service.dart';

final MockAuthService _authService = MockAuthService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _authService.checkCurrentUser();
  runApp(MyApp(authService: _authService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.authService});

  final MockAuthService authService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: authService,
      builder: (context, _) {
        final status = authService.status;
        final Widget home;

        if (status == AuthStatus.authenticated) {
          home = HomeScreen(
            userName: authService.currentUserName,
            onSignOut: authService.signOut,
          );
        } else if (status == AuthStatus.unauthenticated) {
          home = LoginScreen(onLogin: authService.signInWithGoogle);
        } else {
          home = const _CheckingAuthScreen();
        }

        return MaterialApp(
          title: 'App42',
          themeMode: ThemeMode.system,
          theme: _buildSoberTheme(Brightness.light),
          darkTheme: _buildSoberTheme(Brightness.dark),
          home: home,
        );
      },
    );
  }
}

ThemeData _buildSoberTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final baseScheme = ColorScheme.fromSeed(
    seedColor: Colors.blueGrey,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: baseScheme,
    scaffoldBackgroundColor:
        isDark ? const Color(0xFF0F1419) : const Color(0xFFE5E8EB),
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? const Color(0xFF151C22) : const Color(0xFFD2D7DB),
      foregroundColor: baseScheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF151C22) : const Color(0xFFD2D7DB),
      selectedItemColor: baseScheme.primary,
      unselectedItemColor: baseScheme.onSurfaceVariant,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: baseScheme.primary,
      foregroundColor: baseScheme.onPrimary,
    ),
    cardColor: isDark ? const Color(0xFF1B232A) : const Color(0xFFF6F7F8),
    textTheme: ThemeData(brightness: brightness).textTheme.apply(
          bodyColor: baseScheme.onSurface,
          displayColor: baseScheme.onSurface,
        ),
    iconTheme: IconThemeData(color: baseScheme.onSurfaceVariant),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF1A2128) : const Color(0xFFEFF1F3),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: baseScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: baseScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: baseScheme.primary),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class _CheckingAuthScreen extends StatelessWidget {
  const _CheckingAuthScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
