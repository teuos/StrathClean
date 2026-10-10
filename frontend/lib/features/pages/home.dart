import 'package:flutter/material.dart';

import 'package:strath_clean/widgets/navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Home!')),
      bottomNavigationBar: const AppNavBar(currentIndex: 0)
    );
  }

  
}