import 'package:flutter/material.dart';

import 'package:strath_clean/widgets/infoCard.dart';
import 'package:strath_clean/widgets/navbar.dart';
import 'package:strath_clean/widgets/auditInfo.dart';

final List<AuditInfo> homeCards = [
  AuditInfo(
    roomId: 'room11',
    time: 'time',
    completed: false,
  ),
  AuditInfo(
    roomId: 'rom2',
    time: 'time2',
    completed: true,
  ),
  AuditInfo(
    roomId: 'romm3',
    time: '.-',
    completed: false,
  )
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
              InfoCard(roomId: card.roomId, time: card.time),
          const Text (
            'Completed'
          ),
          for (final card in homeCards)
            if (card.completed)
              InfoCard(roomId: card.roomId, time: card.time),
        ],
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 0),
    );
  }
}