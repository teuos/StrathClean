import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.roomId, required this.time});

  final String roomId;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(roomId, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(time, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}