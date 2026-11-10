class Tag {
  final String name; final int usageCount; final String color;
  const Tag({required this.name, this.usageCount = 0, this.color = '#6750A4'});
  Map<String, dynamic> toJson() => {'name': name, 'usageCount': usageCount, 'color': color};
  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    name: json['name'], usageCount: json['usageCount'] ?? 0, color: json['color'] ?? '#6750A4');
}
