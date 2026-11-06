class MangaModel {
  final String id;
  final String title;
  final String description;
  final String originalLanguage;
  final String? coverFileName;

  MangaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.originalLanguage,
    this.coverFileName,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};
    final titleMap = attributes['title'] ?? {};
    final descMap = attributes['description'] ?? {};

    String extractedTitle = 'Tanpa Judul';
    if (titleMap is Map && titleMap.isNotEmpty) {
      if (titleMap.containsKey('en')) {
        extractedTitle = titleMap['en'];
      } else {
        extractedTitle = titleMap.values.first.toString();
      }
    }

    String extractedDesc = 'Tidak ada deskripsi.';
    if (descMap is Map && descMap.isNotEmpty) {
      if (descMap.containsKey('en')) {
        extractedDesc = descMap['en'];
      } else {
        extractedDesc = descMap.values.first.toString();
      }
    }

    // Mencari relasi cover_art di dalam JSON MangaDex
    String? fileName;
    final relationships = json['relationships'] as List?;
    if (relationships != null) {
      final coverRel = relationships.firstWhere(
        (rel) => rel['type'] == 'cover_art',
        orElse: () => null,
      );
      if (coverRel != null && coverRel['attributes'] != null) {
        fileName = coverRel['attributes']['fileName'];
      }
    }

    return MangaModel(
      id: json['id'] ?? '',
      title: extractedTitle,
      description: extractedDesc,
      originalLanguage: attributes['originalLanguage'] ?? '',
      coverFileName: fileName,
    );
  }

  // Getter untuk merakit URL lengkap gambar sampul dari MangaDex
  String get coverUrl {
    if (coverFileName != null && coverFileName!.isNotEmpty) {
      return 'https://uploads.mangadex.org/covers/$id/$coverFileName.256.jpg';
    }
    return ''; // Placeholder jika tidak ada cover
  }
}