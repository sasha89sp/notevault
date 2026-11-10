class Attachment {
  final String id; final String noteId; final String fileName; final String mimeType;
  final int sizeBytes; final String localPath; final String remotePath;
  final bool encrypted; final DateTime createdAt;
  const Attachment({required this.id, required this.noteId, required this.fileName,
    required this.mimeType, required this.sizeBytes, required this.localPath,
    required this.remotePath, this.encrypted = false, required this.createdAt});
  Map<String, dynamic> toJson() => {'id': id, 'noteId': noteId, 'fileName': fileName,
    'mimeType': mimeType, 'sizeBytes': sizeBytes, 'localPath': localPath,
    'remotePath': remotePath, 'encrypted': encrypted, 'createdAt': createdAt.toIso8601String()};
  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json['id'], noteId: json['noteId'], fileName: json['fileName'],
    mimeType: json['mimeType'], sizeBytes: json['sizeBytes'], localPath: json['localPath'],
    remotePath: json['remotePath'], encrypted: json['encrypted'] ?? false,
    createdAt: DateTime.parse(json['createdAt']));
}
