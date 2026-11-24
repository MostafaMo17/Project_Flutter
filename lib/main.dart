// ===========================================================================
// مفقوداتي - Campus Lost & Found
// lib/main.dart
// Owner: Team Lead
// Description: App entry point. Configures Material 3 theme with the deep
//   indigo/teal university palette and wraps the entire app in Directionality
//   RTL so all screens flow naturally from right to left.
// ===========================================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/mock_items.dart';
import 'models/lost_item_model.dart';
import 'screens/login_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _appState = MockItems.createInitialState();
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: LoginScreen(state: _appState),
    );
  }

  ThemeData _buildTheme() {
    const primary = Color(0xFF1E3A8A);
    const teal = Color(0xFF0D9488);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: teal,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF0F172A),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
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
        backgroundColor: Color(0xFFF8FAFC),
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
