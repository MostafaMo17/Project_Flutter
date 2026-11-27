// ===========================================================================
// مفقوداتي - Campus Lost & Found
// lib/main.dart
// Description: App entry point. Configures Material 3 theme with the deep
//   indigo/teal university palette and wraps the entire app in Directionality
//   RTL so all screens flow naturally from right to left.
// ===========================================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'data/mock_items.dart';
import 'models/lost_item_model.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

export 'app_colors.dart';

void main() {
  runApp(const MafqudatiApp());
}

class MafqudatiApp extends StatefulWidget {
  const MafqudatiApp({super.key});

  @override
  State<MafqudatiApp> createState() => _MafqudatiAppState();
}

class _MafqudatiAppState extends State<MafqudatiApp> {
  late final AppState _appState;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _appState = MockItems.createInitialState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _appState.restoreItems(),
      _appState.restoreUserSession(),
    ]);
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مفقوداتي',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return _appState.currentUserName.isNotEmpty
              ? HomeScreen(state: _appState)
              : LoginScreen(state: _appState);
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.indigo,
      brightness: Brightness.light,
      primary: AppColors.indigo,
      onPrimary: Colors.white,
      secondary: AppColors.teal,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.text,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: null, // Uses device default (Arabic-compatible)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
