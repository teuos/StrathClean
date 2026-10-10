// lib/widgets/app_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:strath_clean/theme/app_colors.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key, required this.currentIndex});

  final int currentIndex;
  static const _routes = ['/home', '/findroom', '/issues', '/menu'];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: brandPink.withValues(alpha: 0.3), // the pill behind the selected icon
      selectedIndex: currentIndex,
      onDestinationSelected: (i) {
        if (i != currentIndex) {
          Navigator.pushReplacementNamed(context, _routes[i]);
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Find room'),
        NavigationDestination(icon: Icon(Icons.report_gmailerrorred), label: 'Issues'),
        NavigationDestination(icon: Icon(Icons.list), label: 'Menu')
      ],
    );
  }
}