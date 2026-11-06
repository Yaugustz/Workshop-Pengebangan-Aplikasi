import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Impor package cache
import '../models/chapter_model.dart';
import '../services/manga_service.dart';

class MangaReaderPage extends StatefulWidget {
  final ChapterModel chapter;

  const MangaReaderPage({super.key, required this.chapter});

  @override
  State<MangaReaderPage> createState() => _MangaReaderPageState();
}

class _MangaReaderPageState extends State<MangaReaderPage> {
  late Future<List<String>> _pagesFuture;

  @override
  void initState() {
    super.initState();
    _pagesFuture = MangaService.fetchChapterPages(widget.chapter.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter ${widget.chapter.chapterNumber}'),
      ),
      body: FutureBuilder<List<String>>(
        future: _pagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Gagal memuat gambar: ${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada halaman gambar ditemukan.'));
          }

          final pageUrls = snapshot.data!;
          return ListView.builder(
            // cacheExtent membuat ListView merender gambar di luar layar lebih awal
            cacheExtent: 1000.0, 
            itemCount: pageUrls.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: pageUrls[index],
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  height: 400,
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 300,
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}