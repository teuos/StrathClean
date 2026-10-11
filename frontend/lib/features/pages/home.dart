import 'package:flutter/material.dart';

import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/auditInfo.dart';
import 'package:strath_clean/widgets/gradient_outline_input_border.dart';
import 'package:strath_clean/widgets/infoCard.dart';
import 'package:strath_clean/widgets/navbar.dart';

final List<AuditInfo> homeCards = [
  AuditInfo(roomId: 'LT1105', time: '09:35 - 09:55', completed: false),
  AuditInfo(roomId: 'TG312', time: '10:20 - 10:45', completed: true),
  AuditInfo(roomId: 'MC301', time: '15:30 - 16:00', completed: false),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final toDo = homeCards.where((c) => !c.completed).toList();
    final done = homeCards.where((c) => c.completed).toList();

    return Scaffold(
      bottomNavigationBar: const AppNavBar(currentIndex: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Today's cleaning assignments",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Summary tiles
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'To do',
                    count: toDo.length,
                    icon: Icons.cleaning_services_outlined,
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: 'Completed',
                    count: done.length,
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            _SectionHeader(title: 'Assignments', count: toDo.length),
            const SizedBox(height: 12),
            if (toDo.isEmpty)
              const _EmptyMessage('All done, nothing left to clean')
            else
              for (final card in toDo)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InfoCard(roomId: card.roomId, time: card.time),
                ),
            const SizedBox(height: 16),

            _SectionHeader(title: 'Completed', count: done.length),
            const SizedBox(height: 12),
            if (done.isEmpty)
              const _EmptyMessage('No rooms completed yet')
            else
              for (final card in done)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InfoCard(roomId: card.roomId, time: card.time),
                ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.count,
    required this.icon,
    this.highlighted = false,
  });

  final String label;
  final int count;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: highlighted
          ? ShapeDecoration(
              color: brandPink.withValues(alpha: 0.12),
              shape: const GradientOutlineInputBorder(
                gradient: brandGradient,
                width: 1.5,
              ),
            )
          : ShapeDecoration(
              color: brandTeal.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: cornerRadius,
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: highlighted ? brandBlue : brandTeal),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            gradient: brandGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }
}