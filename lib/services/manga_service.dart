import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/manga_model.dart';
import '../models/chapter_model.dart'; // <-- Tambahkan baris impor ini

class MangaService {
  static const String baseUrl = 'https://api.mangadex.org';

  // Fungsi untuk mengambil daftar manga dengan dukungan pagination (limit & offset) serta pencarian (title)
  static Future<List<MangaModel>> fetchMangaList({int limit = 15, int offset = 0, String? title}) async {
    try {
      String url = '$baseUrl/manga?limit=$limit&offset=$offset&includes[]=cover_art';
      if (title != null && title.isNotEmpty) {
        url += '&title=${Uri.encodeComponent(title)}';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List list = data['data'];
        return list.map((jsonItem) => MangaModel.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Gagal memuat data manga');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengambil daftar chapter berdasarkan ID Manga
  static Future<List<ChapterModel>> fetchChapters(String mangaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/manga/$mangaId/feed?translatedLanguage[]=en&order[chapter]=asc&limit=50'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List list = data['data'];
        return list.map((jsonItem) => ChapterModel.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Gagal memuat daftar chapter');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengambil daftar URL gambar halaman dari sebuah chapter
  static Future<List<String>> fetchChapterPages(String chapterId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/at-home/server/$chapterId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final baseUrlServer = data['baseUrl'];
        final chapterData = data['chapter'];
        final hash = chapterData['hash'];
        List<dynamic> pageFiles = chapterData['data']; // Menggunakan kualitas penuh

        // Merakit URL lengkap untuk setiap halaman gambar
        List<String> pageUrls = pageFiles.map((file) {
          return '$baseUrlServer/data/$hash/$file';
        }).toList();

        return pageUrls;
      } else {
        throw Exception('Gagal memuat halaman chapter');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}