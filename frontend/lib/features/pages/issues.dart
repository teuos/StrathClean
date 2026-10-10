import 'package:flutter/material.dart';
import 'package:strath_clean/widgets/navbar.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  static const _navy = Color(0xFF0E2A4D);
  static const _bg = Color(0xFFF4F6FA);
  static const _selectedFill = Color(0xFFE8F0F9);
  static const _radius = BorderRadius.all(Radius.circular(10));

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

  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _descController = TextEditingController();
  String? _category;
  String _priority = _priorities.first;
  String? _photo; // file name once attached

  @override
  void dispose() {
    _itemController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Handle the submitted form here.
    }
  }

  InputDecoration _decoration({String? hint, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: Color(0xFFDDE3EC)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: Color(0xFFDDE3EC)),
        ),
      );

  Widget _label(String text, {String? trailing}) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text.rich(
          TextSpan(
            text: text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: _navy,
            ),
            children: [
              if (trailing != null)
                TextSpan(
                  text: ' · $trailing',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _categoryCard(String label, IconData icon) {
    final selected = _category == label;
    return InkWell(
      borderRadius: _radius,
      onTap: () => setState(() => _category = label),
      child: Ink(
        decoration: BoxDecoration(
          color: selected ? _selectedFill : Colors.white,
          borderRadius: _radius,
          border: Border.all(
            color: selected ? _navy : const Color(0xFFDDE3EC),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: _navy),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _navy,
                ),
              ),
            ),
            if (selected) const Icon(Icons.check, size: 18, color: _navy),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text('Strath Clean'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Back'),
                  style: TextButton.styleFrom(
                    foregroundColor: _navy,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Report an issue',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 4),
                
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

                _label('Item or area'),
                TextFormField(
                  controller: _itemController,
                  decoration: _decoration(
                    hint: 'e.g. Chair by the window',
                    suffix: const Icon(Icons.edit_outlined, size: 18),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please enter the item or area'
                      : null,
                ),
                const SizedBox(height: 20),

                _label('Describe the issue'),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: _decoration(),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please enter a description of the issue'
                      : null,
                ),
                const SizedBox(height: 20),

                _label('Priority'),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: _decoration(),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3F8),
                      borderRadius: _radius,
                      border: Border.all(color: const Color(0xFFDDE3EC)),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _photo = null),
                                child: const Text(
                                  '1 photo attached · Remove',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Plug in image_picker here.
                    setState(() => _photo = 'chair-leg.jpg');
                  },
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(
                    _photo == null ? 'Add a photo' : 'Add another photo',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _navy,
                    side: const BorderSide(color: Color(0xFFDDE3EC)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(borderRadius: _radius),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F0F9),
                    borderRadius: _radius,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.alt_route, color: _navy),
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
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F5FA8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'The right team is chosen from the issue '
                              'category.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: const RoundedRectangleBorder(borderRadius: _radius),
                  ),
                  child: const Text(
                    'Submit issue',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 2),
    );
  }
}