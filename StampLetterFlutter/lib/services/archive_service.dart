import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:stampletter_flutter/models/stamp.dart';
import '../models/letter.dart';

class ArchiveService {
  static const _archiveFile = 'stamp_letter_archive.json';

  Future<Directory> _directory() async {
    return await getApplicationDocumentsDirectory();
  }

  Future<File> _archiveFileHandle() async {
    final dir = await _directory();
    return File('${dir.path}/$_archiveFile');
  }

  Future<List<Letter>> loadLetters() async {
    try {
      final file = await _archiveFileHandle();
      if (!await file.exists()) return [];
      final raw = await file.readAsString();
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => Letter.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<String> _copyStampImageIfNeeded(Stamp stamp) async {
    final dir = await _directory();
    final sourceFile = File(stamp.imagePath);
    if (!await sourceFile.exists()) {
      return stamp.imagePath;
    }

    final copiedPath = '${dir.path}/stamp_${stamp.id}.png';
    final targetFile = File(copiedPath);
    if (!await targetFile.exists()) {
      await sourceFile.copy(copiedPath);
    }
    return copiedPath;
  }

  Future<void> saveLetter(Letter letter) async {
    final file = await _archiveFileHandle();
    final letters = await loadLetters();
    final imagePath = await _copyStampImageIfNeeded(letter.stamp);
    final updatedStamp = Stamp(
      id: letter.stamp.id,
      imagePath: imagePath,
      isBlackAndWhite: letter.stamp.isBlackAndWhite,
      price: letter.stamp.price,
      frameStyle: letter.stamp.frameStyle,
    );
    final updatedLetter = Letter(
      id: letter.id,
      stamp: updatedStamp,
      paperStyle: letter.paperStyle,
      stampPosition: letter.stampPosition,
      content: letter.content,
      font: letter.font,
      textColor: letter.textColor,
      senderName: letter.senderName,
      receiverName: letter.receiverName,
      createdAt: letter.createdAt,
    );

    final existingIndex = letters.indexWhere((item) => item.id == updatedLetter.id);
    if (existingIndex >= 0) {
      letters[existingIndex] = updatedLetter;
    } else {
      letters.add(updatedLetter);
    }

    await file.writeAsString(jsonEncode(letters.map((l) => l.toJson()).toList()));
  }

  Future<void> deleteLetter(String id) async {
    final file = await _archiveFileHandle();
    final letters = await loadLetters();
    letters.removeWhere((letter) => letter.id == id);
    await file.writeAsString(jsonEncode(letters.map((l) => l.toJson()).toList()));
  }
}
