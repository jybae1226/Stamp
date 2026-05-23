import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../models/letter.dart';
import '../services/archive_service.dart';
import '../widgets/letter_paper_view.dart';

class PreviewSaveScreen extends StatefulWidget {
  final Letter letter;

  const PreviewSaveScreen({super.key, required this.letter});

  @override
  State<PreviewSaveScreen> createState() => _PreviewSaveScreenState();
}

class _PreviewSaveScreenState extends State<PreviewSaveScreen> {
  final GlobalKey _previewKey = GlobalKey();
  String _message = '';

  Future<Uint8List?> _captureImage() async {
    final boundary = _previewKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> _savePhoto() async {
    final bytes = await _captureImage();
    if (bytes == null) return;

    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        setState(() => _message = '저장 권한이 필요합니다.');
        return;
      }
    } else {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        setState(() => _message = '사진 저장 권한이 필요합니다.');
        return;
      }
    }

    final result = await ImageGallerySaver.saveImage(bytes, quality: 90, name: 'stamp_letter_${DateTime.now().millisecondsSinceEpoch}');
    if (result['isSuccess'] == true) {
      setState(() => _message = '사진 앱에 저장되었어요 📮');
    } else {
      setState(() => _message = '저장에 실패했어요.' );
    }
  }

  Future<void> _sharePhoto() async {
    final bytes = await _captureImage();
    if (bytes == null) return;
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/stamp_letter_preview.png');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'StampLetter에서 만든 편지예요');
  }

  Future<void> _archiveLetter() async {
    final service = ArchiveService();
    await service.saveLetter(widget.letter);
    setState(() => _message = '보관함에 저장되었어요');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('미리보기 & 저장')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: _previewKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16)],
                  ),
                  child: LetterPaperView(letter: widget.letter),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_message.isNotEmpty) Text(_message, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _savePhoto,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56), backgroundColor: const Color(0xFFC0392B)),
              child: const Text('저장하기', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: _sharePhoto,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56), backgroundColor: const Color(0xFF7E191B)),
              child: const Text('공유하기', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _archiveLetter,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFC0392B),
                minimumSize: const Size.fromHeight(56),
                side: const BorderSide(color: Color(0xFFC0392B)),
              ),
              child: const Text('보관함에 저장', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
