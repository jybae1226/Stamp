import 'dart:io';
import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../services/archive_service.dart';
import 'preview_save_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final ArchiveService _service = ArchiveService();
  late Future<List<Letter>> _lettersFuture;

  @override
  void initState() {
    super.initState();
    _lettersFuture = _service.loadLetters();
  }

  Future<void> _refresh() async {
    setState(() {
      _lettersFuture = _service.loadLetters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('보관함')),
      body: FutureBuilder<List<Letter>>(
        future: _lettersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final letters = snapshot.data ?? [];
          if (letters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.mail_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('아직 편지가 없어요 ✉️\n첫 편지를 써보세요!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black54)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: letters.length,
              itemBuilder: (context, index) {
                final letter = letters[index];
                return Dismissible(
                  key: ValueKey(letter.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await _service.deleteLetter(letter.id);
                    _refresh();
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PreviewSaveScreen(letter: letter)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: letter.stamp.imageProvider is FileImage
                                  ? Image.file(
                                      File(letter.stamp.imagePath),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(letter.receiverName.isNotEmpty ? letter.receiverName : '받는 사람', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            '${letter.createdAt.year}.${letter.createdAt.month.toString().padLeft(2, '0')}.${letter.createdAt.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
