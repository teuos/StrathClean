class AuditInfo {
  AuditInfo({
    required this.roomId,
    required this.time,
    this.roomType = 'Lecture Hall',
    this.completed = false
    }
  );

  final String roomId;
  final String time;
  final String roomType;
  bool completed;
}