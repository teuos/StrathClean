// lib/features/audit/audit_page.dart
import 'package:flutter/material.dart';

import 'package:strath_clean/features/pages/findroom.dart'; // RoomInfo
import 'package:strath_clean/theme/app_colors.dart';

enum AuditResult { pass, fail }

class AuditPage extends StatefulWidget {
  const AuditPage({super.key, required this.room});

  final RoomInfo room;

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  static const _items = [
    'Floor and edges',
    'Bins emptied',
    'Desks wiped down',
    'Windows and sills clean',
    'Whiteboard cleaned',
  ];

  // null = not answered yet
  final Map<String, AuditResult?> _results = {};

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Heading + subheading
              Text(
                room.room,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                '${room.building}, floor ${room.floor}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // The box
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: cornerRadius,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < _items.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      _buildRow(_items[i]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String item) {
    final result = _results[item];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
          _resultButton(
            icon: Icons.check,
            color: Colors.green,
            selected: result == AuditResult.pass,
            onTap: () => setState(() => _results[item] = AuditResult.pass),
          ),
          const SizedBox(width: 8),
          _resultButton(
            icon: Icons.close,
            color: Colors.red,
            selected: result == AuditResult.fail,
            onTap: () => setState(() => _results[item] = AuditResult.fail),
          ),
        ],
      ),
    );
  }

  Widget _resultButton({
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: selected ? color : Colors.transparent,
        foregroundColor: selected ? Colors.white : color,
        side: BorderSide(color: color),
      ),
    );
  }
}