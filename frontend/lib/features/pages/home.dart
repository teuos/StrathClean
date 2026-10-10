import 'package:flutter/material.dart';

import 'package:strath_clean/widgets/infoCard.dart';
import 'package:strath_clean/widgets/navbar.dart';
import 'package:strath_clean/widgets/auditInfo.dart';

const List<AuditInfo> homeCards = [
  AuditInfo(
    title: 'room1',
    text: 'time',
    completed: false,
  ),
  AuditInfo(
    title: 'rom2',
    text: 'time2',
    completed: true,
  ),
  AuditInfo(
    title: 'romm3',
    text: '.-',
    completed: false,
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Overview',
            style: TextStyle(fontSize: 22)
          ),
          const Text(
            'Assignments'
          ),
          const SizedBox(height: 16),
          for (final card in homeCards)
            if (!card.completed)
              InfoCard(title: card.title, text: card.text),
          const Text (
            'Completed'
          ),
          for (final card in homeCards)
            if (card.completed)
              InfoCard(title: card.title, text: card.text),
        ],
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 0),
    );
  }
}