class Reminder {
  final String id; final String noteId; final DateTime fireAt;
  final String? recurrence; final bool enabled;
  const Reminder({required this.id, required this.noteId, required this.fireAt,
    this.recurrence, this.enabled = true});
  Map<String, dynamic> toJson() => {'id': id, 'noteId': noteId,
    'fireAt': fireAt.toIso8601String(), 'recurrence': recurrence, 'enabled': enabled};
  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'], noteId: json['noteId'], fireAt: DateTime.parse(json['fireAt']),
    recurrence: json['recurrence'], enabled: json['enabled'] ?? true);
}
