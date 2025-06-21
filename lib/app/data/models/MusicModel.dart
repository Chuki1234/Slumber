class MusicItem {
  final int id;
  final String type;
  final String title;
  final String imageUrl;
  final int? duration;
  final String? description;
  final String audioUrl;

  MusicItem({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    this.duration,
    this.description,
    required this.audioUrl,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['id'],
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      duration: json['duration'],
      description: json['description'],
      audioUrl: json['audio_url'] ?? '',
    );
  }
}