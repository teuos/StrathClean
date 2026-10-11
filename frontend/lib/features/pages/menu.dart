import 'package:flutter/material.dart';

import 'package:strath_clean/features/pages/view_issues.dart';
import 'package:strath_clean/services/session.dart';
import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/gradient_outline_input_border.dart';
import 'package:strath_clean/widgets/navbar.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  Future<void> _logOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text("You'll need to sign in again to use the app."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    Session.clear();

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      bottomNavigationBar: const AppNavBar(currentIndex: 3),
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
                decoration: const ShapeDecoration(
                  shape: GradientOutlineInputBorder(
                    gradient: brandGradient,
                    width: 1.5,
                  ),
                ),
                child: TextButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ViewIssuesPage()),
                  ),
                  icon: const Icon(Icons.list_alt),
                  label: const Text(
                    'Current issues',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: brandBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: cornerRadius,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: brandGradient,
                  borderRadius: cornerRadius,
                ),
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: navigate to the account settings page.
                  },
                  icon: const Icon(Icons.manage_accounts_outlined),
                  label: const Text(
                    'Account settings',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: cornerRadius,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _logOut(context),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Log out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: cornerRadius,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}