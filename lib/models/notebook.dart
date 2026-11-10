import 'package:equatable/equatable.dart';
class Notebook extends Equatable {
  final String id; final String name; final String ownerId;
  final bool isEncrypted; final DateTime createdAt; final DateTime updatedAt;
  final int noteCount; final String color;
  const Notebook({required this.id, required this.name, required this.ownerId,
    required this.isEncrypted, required this.createdAt, required this.updatedAt,
    this.noteCount = 0, this.color = '#6750A4'});
  Notebook copyWith({String? name, int? noteCount, String? color, DateTime? updatedAt}) =>
      Notebook(id: id, name: name ?? this.name, ownerId: ownerId,
        isEncrypted: isEncrypted, createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt, noteCount: noteCount ?? this.noteCount,
        color: color ?? this.color);
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'ownerId': ownerId,
    'isEncrypted': isEncrypted, 'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(), 'noteCount': noteCount, 'color': color};
  factory Notebook.fromJson(Map<String, dynamic> json) => Notebook(
    id: json['id'], name: json['name'], ownerId: json['ownerId'],
    isEncrypted: json['isEncrypted'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    noteCount: json['noteCount'] ?? 0, color: json['color'] ?? '#6750A4');
  @override List<Object?> get props => [id, isEncrypted];
}
