import 'package:flutter/material.dart';

import 'package:strath_clean/features/pages/findroom.dart';
import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/gradient_outline_input_border.dart';
import 'package:strath_clean/widgets/navbar.dart';

class CleanRoom extends StatefulWidget {
  const CleanRoom({super.key, required this.room});

  final RoomInfo room;

  @override
  State<CleanRoom> createState() => _CleanRoomState();
}

class _CleanRoomState extends State<CleanRoom> {
  static const _items = [
    'Floor cleaned',
    'Desks and surfaces wiped',
    'Chairs checked and wiped',
    'Bins emptied and relined',
    'Room left tidy and secure',
  ];

  // true = ticked. Anything not in the map yet counts as unticked.
  final Map<String, bool> _done = {};

  bool get _allDone => _items.every((item) => _done[item] == true);

  void _submit() {
    // TODO: save the completed clean to your backend here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.room.room} marked as clean')),
    );
    Navigator.pop(context); // back to Find room
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      bottomNavigationBar: const AppNavBar(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                room.room,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                '${room.building}, floor ${room.floor}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(15),
                decoration: const ShapeDecoration(
                  shape: GradientOutlineInputBorder(
                    gradient: brandGradient,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assigned to you', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                    const SizedBox(height: 10),
                    Text(
                      'Sample Name ⋅ Today, 09:15-09:35',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      'Last cleaned: Fri 9 Oct, 09:26 ⋅ Sample Name',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const ShapeDecoration(
                  shape: GradientOutlineInputBorder(
                    gradient: brandGradient,
                    width: 1.5,
                  ),
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
              const SizedBox(height: 24),
              // Grey and disabled until every item is ticked, then gradient.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: _allDone ? brandGradient : null,
                  color: _allDone ? null : Colors.grey.shade400,
                  borderRadius: cornerRadius,
                ),
                child: FilledButton(
                  onPressed: _allDone ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white70,
                    shape: const RoundedRectangleBorder(
                      borderRadius: cornerRadius,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String item) {
    return CheckboxListTile(
      title: Text(item, style: const TextStyle(fontSize: 16)),
      value: _done[item] ?? false,
      onChanged: (checked) => setState(() => _done[item] = checked ?? false),
      activeColor: brandTeal,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}