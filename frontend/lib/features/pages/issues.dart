import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:strath_clean/models/issue.dart';
import 'package:strath_clean/services/api_service.dart';
import 'package:strath_clean/services/session.dart';
import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/gradient_outline_input_border.dart';
import 'package:strath_clean/widgets/navbar.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  static const _categories = <(String, IconData)>[
    ('PAT testing', Icons.electrical_services),
    ('Door lock', Icons.key),
    ('Furniture', Icons.chair_outlined),
    ('Infrastructure', Icons.apartment),
  ];

  static const _priorities = [
    'Routine · No immediate danger',
    'Urgent · Needs attention soon',
    'Emergency · Immediate danger',
  ];

  // Same field style as the login and Find room pages.
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

  final _formKey = GlobalKey<FormState>();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _roomController = TextEditingController();
  final _descController = TextEditingController();
  String? _category;
  String _priority = _priorities.first;
  String? _photo; // file name once attached
  bool _sending = false;

  @override
  void dispose() {
    _buildingController.dispose();
    _floorController.dispose();
    _roomController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get _isComplete =>
      _category != null &&
      _buildingController.text.trim().isNotEmpty &&
      _floorController.text.trim().isNotEmpty &&
      _roomController.text.trim().isNotEmpty &&
      _descController.text.trim().isNotEmpty;

  String? _required(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  void _resetForm() {
    _formKey.currentState!.reset();
    _buildingController.clear();
    _floorController.clear();
    _roomController.clear();
    _descController.clear();
    setState(() {
      _category = null;
      _priority = _priorities.first;
      _photo = null;
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = Session.userId;
    if (userId == null) {
      _showMessage('Please log in again before reporting an issue');
      return;
    }

    setState(() => _sending = true);

    try {
      await ApiService.createIssue(
        userId: userId,
        roomCode: _roomController.text.trim(),
        building: _buildingController.text.trim(),
        floor: int.parse(_floorController.text.trim()),
        // TODO: replace with a real uploaded image once photo upload exists.
        image: _photo ?? '',
        description: Issue.encodeDescription(
          category: _category!,
          // Keep just "Urgent" from "Urgent · Needs attention soon".
          priority: _priority.split(' · ').first,
          description: _descController.text.trim(),
        ),
      );

      if (!mounted) return;
      _showMessage('$_category issue reported');
      _resetForm();
    } catch (e) {
      debugPrint('createIssue error: $e');
      if (mounted) _showMessage("Couldn't send the issue. Please try again.");
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _label(String text, {String? trailing}) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text.rich(
          TextSpan(
            text: text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            children: [
              if (trailing != null)
                TextSpan(
                  text: ' · $trailing',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _categoryCard(String label, IconData icon) {
    final selected = _category == label;

    return InkWell(
      borderRadius: cornerRadius,
      onTap: () => setState(() => _category = label),
      child: Ink(
        // Gradient outline when selected, light grey outline when not.
        decoration: selected
            ? ShapeDecoration(
                color: brandPink.withValues(alpha: 0.12),
                shape: const GradientOutlineInputBorder(
                  gradient: brandGradient,
                  width: 2,
                ),
              )
            : ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: cornerRadius,
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? brandBlue : Colors.grey.shade700,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, size: 18, color: brandBlue),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppNavBar(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Report an issue',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Let the right team know what needs fixing',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                _label('What needs attention?'),
                FormField<String>(
                  validator: (_) =>
                      _category == null ? 'Please choose a category' : null,
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3.2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final c in _categories)
                            _categoryCard(c.$1, c.$2),
                        ],
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _label('Building'),
                TextFormField(
                  controller: _buildingController,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'e.g. Livingstone Tower',
                    prefixIcon: const Icon(Icons.apartment),
                  ),
                  validator: (v) => _required(v, 'Please enter the building'),
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label('Floor'),
                          TextFormField(
                            controller: _floorController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.next,
                            decoration: _fieldDecoration.copyWith(
                              hintText: 'e.g. 11',
                              prefixIcon: const Icon(Icons.stairs),
                            ),
                            validator: (v) => int.tryParse(v?.trim() ?? '') ==
                                    null
                                ? 'Enter a number'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label('Room number'),
                          TextFormField(
                            controller: _roomController,
                            textInputAction: TextInputAction.next,
                            decoration: _fieldDecoration.copyWith(
                              hintText: 'e.g. LT1105',
                              prefixIcon: const Icon(Icons.meeting_room),
                            ),
                            validator: (v) =>
                                _required(v, 'Enter a room number'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _label('Describe the issue'),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'What is wrong with it?',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a description of the issue'
                      : null,
                ),
                const SizedBox(height: 20),

                _label('Priority'),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: _fieldDecoration.copyWith(
                    prefixIcon: const Icon(Icons.flag_outlined),
                  ),
                  borderRadius: cornerRadius,
                  items: [
                    for (final p in _priorities)
                      DropdownMenuItem(value: p, child: Text(p)),
                  ],
                  onChanged: (v) => setState(() => _priority = v!),
                ),
                const SizedBox(height: 20),

                _label('Photos', trailing: 'Optional'),
                if (_photo != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: ShapeDecoration(
                      color: brandTeal.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: cornerRadius,
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.image_outlined, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _photo!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _photo = null),
                                child: const Text(
                                  '1 photo attached · Remove',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle, color: brandTeal),
                      ],
                    ),
                  ),
                // Outlined button with the gradient border.
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    shape: GradientOutlineInputBorder(
                      gradient: brandGradient,
                      width: 1.5,
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // Plug in image_picker here.
                      setState(() => _photo = 'chair-leg.jpg');
                    },
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(
                      _photo == null ? 'Add a photo' : 'Add another photo',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: brandBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: cornerRadius,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: brandTeal.withValues(alpha: 0.1),
                    borderRadius: cornerRadius,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.alt_route, color: brandTeal),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _category == 'Furniture'
                                  ? 'Sent to Estates · Furniture repairs'
                                  : 'Sent to the right team',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'The right team is chosen from the issue '
                              'category.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Grey until a category is picked and both text boxes are
                // filled, then the gradient — same as Find room.
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _buildingController,
                    _floorController,
                    _roomController,
                    _descController,
                  ]),
                  builder: (context, _) {
                    final ready = _isComplete;
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: ready ? brandGradient : null,
                        color: ready ? null : Colors.grey.shade400,
                        borderRadius: cornerRadius,
                      ),
                      child: FilledButton(
                        onPressed: ready && !_sending ? _submit : null,
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
                        child: _sending
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Submit issue',
                                style: TextStyle(fontWeight: FontWeight.bold),
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