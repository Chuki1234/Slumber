class AlarmSound {
  final int id;
  final String name;
  final String filePath;
  final String publicUrl;
  final double volume;

  AlarmSound({
    required this.id,
    required this.name,
    required this.filePath,
    required this.publicUrl,
    required this.volume,
  });

  factory AlarmSound.fromJson(Map<String, dynamic> json) {
    return AlarmSound(
      id: json['id'],
      name: json['name'],
      filePath: json['file_path'],
      publicUrl: json['public_url'],
      volume: (json['volume'] ?? 1.0).toDouble(),
    );
  }

}