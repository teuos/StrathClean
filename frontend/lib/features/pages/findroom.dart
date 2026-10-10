import 'package:flutter/material.dart';

import 'package:strath_clean/widgets/navbar.dart';

class FindRoomPage extends StatelessWidget {
  const FindRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      body: const Center(child: Text('FindRoom!')),
      bottomNavigationBar: const AppNavBar(currentIndex: 1)
    );
  }

  
}