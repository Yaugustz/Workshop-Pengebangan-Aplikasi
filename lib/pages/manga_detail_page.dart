import 'package:flutter/material.dart';
import '../models/manga_model.dart';
import '../models/chapter_model.dart';
import '../services/manga_service.dart';
import 'manga_reader_page.dart'; // 1. Tambahkan impor ini di bagian atas

class MangaDetailPage extends StatefulWidget {
  final MangaModel manga;

  const MangaDetailPage({super.key, required this.manga});

  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  late Future<List<ChapterModel>> _chapterFuture;

  @override
  void initState() {
    super.initState();
    _chapterFuture = MangaService.fetchChapters(widget.manga.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manga.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header (Poster dan Informasi Singkat)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.manga.coverUrl.isNotEmpty
                      ? Image.network(
                          widget.manga.coverUrl,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 100,
                          height: 150,
                          color: Colors.grey,
                          child: const Icon(Icons.image, size: 40),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.manga.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text('Bahasa: ${widget.manga.originalLanguage.toUpperCase()}'),
                        backgroundColor: Colors.deepPurple.shade50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Sinopsis',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.manga.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Daftar Chapter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Daftar Chapter menggunakan FutureBuilder
            FutureBuilder<List<ChapterModel>>(
              future: _chapterFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Gagal memuat chapter: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Tidak ada chapter tersedia.');
                }

                final chapters = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return Card(
                      child: ListTile(
                        title: Text('Chapter ${chapter.chapterNumber}'),
                        subtitle: chapter.title.isNotEmpty
                            ? Text(chapter.title, maxLines: 1, overflow: TextOverflow.ellipsis)
                            : null,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // 2. Ubah aksi onTap agar berpindah ke MangaReaderPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MangaReaderPage(chapter: chapter),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}