import 'package:flutter/material.dart';
import 'package:strath_clean/theme/app_colors.dart';

import 'package:strath_clean/features/auth/login_page.dart';
import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/features/pages/home.dart';
import 'package:strath_clean/features/pages/findroom.dart';
import 'package:strath_clean/features/pages/issues.dart';
import 'package:strath_clean/features/pages/menu.dart';
import 'package:strath_clean/features/pages/roomaudit.dart';

class StrathCleanApp extends StatelessWidget {
  const StrathCleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrathClean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
      final pages = <String, Widget>{
        '/': const LoginPage(),
        '/home': const HomePage(),
        '/findroom': const FindRoomPage(),
        '/issues': const IssuesPage(),
        '/menu': const MenuPage(),
      };
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => pages[settings.name] ?? const LoginPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    },
    );
  }
}