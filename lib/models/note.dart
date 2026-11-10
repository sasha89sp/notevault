import 'package:equatable/equatable.dart';

enum NoteScope { shared, personal }
enum NoteStatus { active, trashed }

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final NoteScope scope;
  final String? notebookId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reminderAt;
  final String? reminderRecurrence;
  final List<String> tags;
  final List<String> attachments;
  final int commentCount;
  final int unreadCommentCount;
  final NoteStatus status;
  final String? etag;
  final int version;
  final bool isEncrypted;

  const Note({
    required this.id, required this.title, required this.content,
    required this.authorId, required this.authorName, required this.scope,
    this.notebookId, required this.createdAt, required this.updatedAt,
    this.reminderAt, this.reminderRecurrence, this.tags = const [],
    this.attachments = const [], this.commentCount = 0,
    this.unreadCommentCount = 0, this.status = NoteStatus.active,
    this.etag, this.version = 1, this.isEncrypted = false,
  });

  Note copyWith({
    String? title, String? content, DateTime? updatedAt,
    DateTime? reminderAt, String? reminderRecurrence, List<String>? tags,
    List<String>? attachments, int? commentCount, int? unreadCommentCount,
    NoteStatus? status, String? etag, int? version,
  }) => Note(
    id: id, title: title ?? this.title, content: content ?? this.content,
    authorId: authorId, authorName: authorName, scope: scope,
    notebookId: notebookId, createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    reminderAt: reminderAt ?? this.reminderAt,
    reminderRecurrence: reminderRecurrence ?? this.reminderRecurrence,
    tags: tags ?? this.tags, attachments: attachments ?? this.attachments,
    commentCount: commentCount ?? this.commentCount,
    unreadCommentCount: unreadCommentCount ?? this.unreadCommentCount,
    status: status ?? this.status, etag: etag ?? this.etag,
    version: version ?? this.version, isEncrypted: isEncrypted,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'content': content, 'authorId': authorId,
    'authorName': authorName, 'scope': scope.name, 'notebookId': notebookId,
    'createdAt': createdAt.toIso8601String(), 'updatedAt': updatedAt.toIso8601String(),
    'reminderAt': reminderAt?.toIso8601String(), 'reminderRecurrence': reminderRecurrence,
    'tags': tags, 'attachments': attachments, 'commentCount': commentCount,
    'unreadCommentCount': unreadCommentCount, 'status': status.name,
    'etag': etag, 'version': version, 'isEncrypted': isEncrypted,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'], title: json['title'], content: json['content'],
    authorId: json['authorId'], authorName: json['authorName'],
    scope: NoteScope.values.byName(json['scope']),
    notebookId: json['notebookId'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    reminderAt: json['reminderAt'] != null ? DateTime.parse(json['reminderAt']) : null,
    reminderRecurrence: json['reminderRecurrence'],
    tags: List<String>.from(json['tags'] ?? []),
    attachments: List<String>.from(json['attachments'] ?? []),
    commentCount: json['commentCount'] ?? 0,
    unreadCommentCount: json['unreadCommentCount'] ?? 0,
    status: NoteStatus.values.byName(json['status'] ?? 'active'),
    etag: json['etag'], version: json['version'] ?? 1,
    isEncrypted: json['isEncrypted'] ?? false,
  );

  @override List<Object?> get props => [id, version, updatedAt];
}
