import 'package:flutter/material.dart';

import 'package:strath_clean/widgets/navbar.dart';
import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/gradient_outline_input_border.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  static const double _titleHeight = 42;

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Menu',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: brandGradient,
                borderRadius: cornerRadius,
              ),
              child: FilledButton(
                onPressed: () {
                  // Navigate to second route when tapped.
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: cornerRadius,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Account Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const AppNavBar(currentIndex: 3),
  );
}
}