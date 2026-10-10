// lib/widgets/app_nav_bar.dart
import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key, required this.currentIndex});

  final int currentIndex;
  static const _routes = ['/home', '/findroom', '/issues', '/menu'];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
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