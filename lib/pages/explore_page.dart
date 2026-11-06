import 'package:flutter/material.dart';
import '../models/manga_model.dart';
import '../services/manga_service.dart';
import 'manga_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<MangaModel> _mangaList = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreData = true; // Status penanda apakah masih ada data manga
  int _offset = 0;
  final int _limit = 8;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadManga(isRefresh: true);
  }

  Future<void> _loadManga({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        _offset = 0;
        _hasMoreData = true; // Reset status saat refresh / pencarian baru
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final fetchedList = await MangaService.fetchMangaList(
        limit: _limit,
        offset: _offset,
        title: _searchQuery.isEmpty ? null : _searchQuery,
      );

      setState(() {
        if (isRefresh) {
          _mangaList = fetchedList;
        } else {
          _mangaList.addAll(fetchedList);
        }

        // Jika jumlah data yang didapat kurang dari limit, artinya manga sudah habis
        if (fetchedList.length < _limit) {
          _hasMoreData = false;
        }

        _offset += _limit;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
    _loadManga(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Kotak Pencarian
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari judul manga...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchSubmitted('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: _onSearchSubmitted,
            ),
          ),

          // Daftar Manga
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _mangaList.isEmpty
                    ? const Center(child: Text('Tidak ada manga ditemukan.'))
                    : ListView.builder(
                        // Jika _hasMoreData bernilai true, tambahkan 1 index untuk tombol di bawah
                        itemCount: _mangaList.length + (_hasMoreData ? 1 : 0),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (context, index) {
                          // Tampilkan tombol "Muat Lainnya" hanya jika index menyentuh bagian akhir dan data masih ada
                          if (index == _mangaList.length && _hasMoreData) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Center(
                                child: _isLoadingMore
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton.icon(
                                        onPressed: () => _loadManga(isRefresh: false),
                                        icon: const Icon(Icons.add),
                                        label: const Text('Muat Lainnya'), // Nama tombol diubah
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                        ),
                                      ),
                              ),
                            );
                          }

                          final manga = _mangaList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MangaDetailPage(manga: manga),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: manga.coverUrl.isNotEmpty
                                          ? Image.network(
                                              manga.coverUrl,
                                              width: 60,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container(
                                                width: 60,
                                                height: 90,
                                                color: Colors.grey,
                                                child: const Icon(Icons.broken_image, size: 30),
                                              ),
                                            )
                                          : Container(
                                              width: 60,
                                              height: 90,
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.image, size: 30),
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            manga.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            manga.description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}