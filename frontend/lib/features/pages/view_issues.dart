import 'package:flutter/material.dart';

import 'package:strath_clean/features/pages/roomaudit.dart';
import 'package:strath_clean/features/pages/findroom.dart'; // RoomInfo
import 'package:strath_clean/models/issue.dart';
import 'package:strath_clean/services/api_service.dart';
import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/navbar.dart';

class ViewIssuesPage extends StatefulWidget {
  const ViewIssuesPage({super.key});

  @override
  State<ViewIssuesPage> createState() => _ViewIssuesPageState();
}

class _ViewIssuesPageState extends State<ViewIssuesPage> {
  late Future<List<Issue>> _issuesFuture;

  @override
  void initState() {
    super.initState();
    _issuesFuture = ApiService.getAllIssues();
  }

  Future<void> _refresh() async {
    final future = ApiService.getAllIssues();
    setState(() => _issuesFuture = future);
    await future.catchError((_) => <Issue>[]); // errors are shown by the builder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StrathClean')),
      bottomNavigationBar: const AppNavBar(currentIndex: 3),
      body: SafeArea(
        child: RefreshIndicator(
          color: brandBlue,
          onRefresh: _refresh,
          child: FutureBuilder<List<Issue>>(
            future: _issuesFuture,
            builder: (context, snapshot) {
              final header = <Widget>[
                const Text(
                  'Current issues',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Pull down to refresh',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
              ];

              final List<Widget> body;
              if (snapshot.connectionState == ConnectionState.waiting) {
                body = const [
                  SizedBox(height: 80),
                  Center(child: CircularProgressIndicator(color: brandBlue)),
                ];
              } else if (snapshot.hasError) {
                body = [
                  _Message(
                    icon: Icons.cloud_off,
                    text: "Couldn't load issues",
                    action: TextButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ),
                ];
              } else if (snapshot.data!.isEmpty) {
                body = const [
                  _Message(
                    icon: Icons.check_circle_outline,
                    text: 'No issues reported',
                  ),
                ];
              } else {
                body = [
                  for (final issue in snapshot.data!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _IssueCard(issue: issue),
                    ),
                ];
              }

              // A ListView (not a Column) so pull-to-refresh always works,
              // even when there are only a few cards.
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [...header, ...body],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue});

  final Issue issue;

  static const _categoryIcons = {
    'PAT testing': Icons.electrical_services,
    'Door lock': Icons.key,
    'Furniture': Icons.chair_outlined,
    'Infrastructure': Icons.apartment,
  };

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// e.g. "11 Oct, 09:32"
  static String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.day} ${_months[d.month - 1]}, ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final location = [
      if (issue.building.isNotEmpty) issue.building,
      if (issue.floor.isNotEmpty) 'floor ${issue.floor}',
    ].join(', ');

    return InkWell(
      borderRadius: cornerRadius,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AuditPage(
            room: RoomInfo(
              building: issue.building,
              floor: issue.floor,
              room: issue.roomCode,
            ),
            issue: issue
          ),
        ),
      ),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: cornerRadius,
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: brandTeal.withValues(alpha: 0.12),
                borderRadius: cornerRadius,
              ),
              child: Icon(
                _categoryIcons[issue.category] ?? Icons.report_gmailerrorred,
                color: brandTeal,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          issue.roomCode.isEmpty
                              ? 'Unknown room'
                              : issue.roomCode,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (issue.priority != null)
                        _PriorityChip(priority: issue.priority!),
                    ],
                  ),
                  if (location.isNotEmpty)
                    Text(location, style: const TextStyle(color: Colors.grey)),
                  if (issue.opened != null)
                    Text(
                      'Reported ${_formatDate(issue.opened!)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  if (issue.category != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      issue.category!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                  ],
                  if (issue.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(issue.description),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, top: 4),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      'Emergency' => Colors.red,
      'Urgent' => Colors.orange,
      _ => brandTeal,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          if (action != null) ...[const SizedBox(height: 8), action!],
        ],
      ),
    );
  }
}