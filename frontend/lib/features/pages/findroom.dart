import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/navbar.dart';
import 'package:strath_clean/widgets/gradient_outline_input_border.dart';
import 'package:strath_clean/features/pages/roomaudit.dart';
import 'package:strath_clean/features/pages/cleanroom.dart';

/// The details encoded in a room's QR code.
///
/// Supported QR contents:
///   JSON:  {"building":"Livingstone Tower","floor":"5","room":"LT5.12"}
///   Plain: Livingstone Tower|5|LT5.12        (building|floor|room)
class RoomInfo {
  const RoomInfo({
    required this.building,
    required this.floor,
    required this.room,
  });

  final String building;
  final String floor;
  final String room;

  static RoomInfo? tryParse(String raw) {
    final text = raw.trim();

    // JSON format
    try {
      final data = jsonDecode(text);
      if (data is Map<String, dynamic>) {
        final building = data['building']?.toString().trim() ?? '';
        final floor = data['floor']?.toString().trim() ?? '';
        final room = data['room']?.toString().trim() ?? '';
        if (building.isNotEmpty && floor.isNotEmpty && room.isNotEmpty) {
          return RoomInfo(building: building, floor: floor, room: room);
        }
      }
    } on FormatException {
      // Not JSON, try the plain format below.
    }

    // building|floor|room format
    final parts = text.split('|').map((p) => p.trim()).toList();
    if (parts.length == 3 && parts.every((p) => p.isNotEmpty)) {
      return RoomInfo(building: parts[0], floor: parts[1], room: parts[2]);
    }

    return null;
  }
}

class FindRoomPage extends StatefulWidget {
  const FindRoomPage({super.key});

  @override
  State<FindRoomPage> createState() => _FindRoomPageState();
}

class _FindRoomPageState extends State<FindRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _roomController = TextEditingController();

  final _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  bool _scanned = false;

  static const _fieldDecoration = InputDecoration(
    enabledBorder: GradientOutlineInputBorder(
      gradient: brandGradient,
      width: 1.5,
    ),
    focusedBorder: GradientOutlineInputBorder(
      gradient: brandGradient,
      width: 2.5,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: cornerRadius,
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: cornerRadius,
      borderSide: BorderSide(color: Colors.red, width: 2.5),
    ),
  );

  @override
  void dispose() {
    _scanner.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    final info = RoomInfo.tryParse(raw);
    if (info == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("That QR code isn't a room code")),
        );
      return;
    }

    setState(() {
      _scanned = true;
      _buildingController.text = info.building;
      _floorController.text = info.floor;
      _roomController.text = info.room;
    });
    _scanner.stop();
  }

  void _scanAgain() {
    setState(() => _scanned = false);
    _buildingController.text = "";
    _floorController.text = "";
    _roomController.text = "";
    _scanner.start();
  }

  bool get _isComplete =>
    _buildingController.text.trim().isNotEmpty &&
    _floorController.text.trim().isNotEmpty &&
    _roomController.text.trim().isNotEmpty;

  String? _required(String? value, String name) {
    if (value == null || value.trim().isEmpty) return 'Please enter the $name';
    return null;
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    if (!_formKey.currentState!.validate()) return;

    final room = RoomInfo(
      building: _buildingController.text.trim(),
      floor: _floorController.text.trim(),
      room: _roomController.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CleanRoom(room: room)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Room ${_roomController.text.trim()}, floor '
          '${_floorController.text.trim()}, '
          '${_buildingController.text.trim()}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      bottomNavigationBar: const AppNavBar(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, bottom: 0, top: 0, right: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Find Room',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Scan the QR code on the room door',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Camera preview. It stays in the tree so it can be paused and
                // restarted; an overlay covers it once a code is scanned.
                ClipRRect(
                  borderRadius: cornerRadius,
                  child: SizedBox(
                    height: 260,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        MobileScanner(
                          controller: _scanner,
                          onDetect: _onDetect,
                        ),
                        if (!_scanned)
                          // Simple aiming frame in the middle of the preview.
                          Center(
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                borderRadius: cornerRadius,
                              ),
                            ),
                          ),
                        if (_scanned)
                          Container(
                            color: colors.surfaceContainerHighest,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 56,
                                  color: brandTeal,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Room scanned',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: _scanAgain,
                                  icon: const Icon(Icons.qr_code_scanner),
                                  label: const Text('Scan again'),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Or enter the details yourself',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _buildingController,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'building'),
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'Building',
                    prefixIcon: const Icon(Icons.apartment),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _floorController,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'floor'),
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'Floor',
                    prefixIcon: const Icon(Icons.stairs),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _roomController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _confirm(),
                  validator: (v) => _required(v, 'room'),
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'Room',
                    prefixIcon: const Icon(Icons.meeting_room),
                  ),
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _buildingController,
                    _floorController,
                    _roomController,
                  ]),
                  builder: (context, _) {
                    final ready = _isComplete;
                    final room = _roomController.text.trim();

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        // Gradient when ready, plain grey when not.
                        gradient: ready ? brandGradient : null,
                        color: ready ? null : Colors.grey.shade400,
                        borderRadius: cornerRadius,
                      ),
                      child: FilledButton(
                        onPressed: ready ? _confirm : null, // null = disabled
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white70,
                          shape: const RoundedRectangleBorder(borderRadius: cornerRadius),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          room.isEmpty ? 'Confirm room' : 'Confirm $room',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}