import 'package:flutter/material.dart';

import 'package:strath_clean/widgets/navbar.dart';

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      body: const Center(child: Text('Issues!')),
      bottomNavigationBar: const AppNavBar(currentIndex: 2)
    );
  }

  
}