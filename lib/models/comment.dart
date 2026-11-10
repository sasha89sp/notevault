class Comment {
  final String id; final String noteId; final String authorId;
  final String authorName; final String text; final DateTime createdAt; final bool read;
  const Comment({required this.id, required this.noteId, required this.authorId,
    required this.authorName, required this.text, required this.createdAt, this.read = false});
  Comment copyWith({bool? read}) => Comment(id: id, noteId: noteId, authorId: authorId,
    authorName: authorName, text: text, createdAt: createdAt, read: read ?? this.read);
  Map<String, dynamic> toJson() => {'id': id, 'noteId': noteId, 'authorId': authorId,
    'authorName': authorName, 'text': text, 'createdAt': createdAt.toIso8601String(), 'read': read};
  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'], noteId: json['noteId'], authorId: json['authorId'],
    authorName: json['authorName'], text: json['text'],
    createdAt: DateTime.parse(json['createdAt']), read: json['read'] ?? false);
}
