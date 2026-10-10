import 'package:flutter/material.dart';

import 'package:strath_clean/widgets/navbar.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      body: const Center(child: Text('Menu!')),
      bottomNavigationBar: const AppNavBar(currentIndex: 3)
    );
  }

  
}