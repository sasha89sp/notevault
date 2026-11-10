import 'package:equatable/equatable.dart';
class User extends Equatable {
  final String id; final String name; final String passwordHash;
  final String salt; final DateTime createdAt; final bool isAdmin;
  const User({required this.id, required this.name, required this.passwordHash,
    required this.salt, required this.createdAt, this.isAdmin = false});
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'passwordHash': passwordHash,
    'salt': salt, 'createdAt': createdAt.toIso8601String(), 'isAdmin': isAdmin};
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'], name: json['name'], passwordHash: json['passwordHash'],
    salt: json['salt'], createdAt: DateTime.parse(json['createdAt']),
    isAdmin: json['isAdmin'] ?? false);
  @override List<Object?> get props => [id];
}
