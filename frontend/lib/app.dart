import 'package:flutter/material.dart';

import 'package:strath_clean/features/auth/login_page.dart';
import 'package:strath_clean/theme/app_colors.dart';

class StrathCleanApp extends StatelessWidget {
  const StrathCleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrathClean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: brandTeal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
      },
    );
  }
}