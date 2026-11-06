class ChapterModel {
  final String id;
  final String chapterNumber;
  final String title;
  final String translatedLanguage;

  ChapterModel({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.translatedLanguage,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};
    return ChapterModel(
      id: json['id'] ?? '',
      chapterNumber: attributes['chapter'] ?? '?',
      title: attributes['title'] ?? '',
      translatedLanguage: attributes['translatedLanguage'] ?? 'en',
    );
  }
}