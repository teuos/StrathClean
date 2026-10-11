
class Issue {
  const Issue({
    required this.id,
    required this.roomCode,
    required this.building,
    required this.floor,
    required this.description,
    required this.image,
    this.opened,
    this.category,
    this.priority,
  });

  final int? id;
  final String roomCode;
  final String building;
  final String floor;
  final String description;
  final String image;

  final DateTime? opened;

  final String? category;
  final String? priority;

  static final _tagPattern = RegExp(r'^\[(.+?) · (.+?)\]\s*', dotAll: true);

  static String encodeDescription({
    required String category,
    required String priority,
    required String description,
  }) =>
      '[$category · $priority] $description';

  factory Issue.fromJson(Map<String, dynamic> json) {
    final fields = {
      for (final e in json.entries)
        e.key.toLowerCase().replaceAll('_', ''): e.value,
    };

    String text(List<String> keys) {
      for (final k in keys) {
        final v = fields[k];
        if (v != null) return v.toString();
      }
      return '';
    }

    final rawDescription = text(['descript', 'description', 'desc']);
    final tag = _tagPattern.firstMatch(rawDescription);

    return Issue(
      id: int.tryParse(text(['issueid', 'id'])),
      roomCode: text(['roomid', 'roomcode', 'room']),
      building: text(['building']),
      floor: text(['floor']),
      image: text(['image']),
      opened: DateTime.tryParse(text(['opened'])),
      category: tag?.group(1),
      priority: tag?.group(2),
      description: tag == null
          ? rawDescription
          : rawDescription.substring(tag.end),
    );
  }
}