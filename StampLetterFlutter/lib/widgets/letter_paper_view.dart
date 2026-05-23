import 'dart:io';
import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../widgets/stamp_view.dart';

class LetterPaperView extends StatelessWidget {
  final Letter letter;

  const LetterPaperView({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 210 / 148,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: _backgroundColor(letter.paperStyle),
        ),
        child: Stack(
          children: [
            _backgroundDecoration(letter.paperStyle),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Text('To. ${letter.receiverName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Text(
                          letter.content,
                          style: letter.font.textStyle.copyWith(color: letter.textColor, height: 1.6, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formattedDate(letter.createdAt), style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          Text('From. ${letter.senderName}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: letter.stampPosition == StampPosition.topLeft || letter.stampPosition == StampPosition.topRight ? 0 : null,
                    bottom: letter.stampPosition == StampPosition.bottomLeft || letter.stampPosition == StampPosition.bottomRight ? 0 : null,
                    left: letter.stampPosition == StampPosition.topLeft || letter.stampPosition == StampPosition.bottomLeft ? 0 : null,
                    right: letter.stampPosition == StampPosition.topRight || letter.stampPosition == StampPosition.bottomRight ? 0 : null,
                    child: SizedBox(
                      width: 90,
                      height: 110,
                      child: StampView(stamp: letter.stamp, size: 90),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _alignmentForPosition(StampPosition position) {
    switch (position) {
      case StampPosition.topLeft:
        return Alignment.topLeft;
      case StampPosition.topRight:
        return Alignment.topRight;
      case StampPosition.bottomLeft:
        return Alignment.bottomLeft;
      case StampPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  String _formattedDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  Color _backgroundColor(LetterPaperStyle style) {
    switch (style) {
      case LetterPaperStyle.kraft:
        return const Color(0xFFD4A96A);
      case LetterPaperStyle.watercolor:
        return const Color(0xFFE8F0FF);
      case LetterPaperStyle.check:
        return Colors.white;
      case LetterPaperStyle.floral:
        return const Color(0xFFFFF5E4);
      case LetterPaperStyle.white:
        return Colors.white;
    }
  }

  Widget _backgroundDecoration(LetterPaperStyle style) {
    switch (style) {
      case LetterPaperStyle.kraft:
        return const Positioned.fill(child: Opacity(opacity: 0.1, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFB38E5A)))));
      case LetterPaperStyle.watercolor:
        return Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEAF2FF), Color(0xFFFFF3E5)],
              ),
            ),
          ),
        );
      case LetterPaperStyle.check:
        return CustomPaint(painter: _GridPainter());
      case LetterPaperStyle.floral:
        return Stack(
          children: const [
            Positioned(left: 10, top: 10, child: Icon(Icons.local_florist, color: Color(0xFFE6C3A6), size: 40)),
            Positioned(right: 12, bottom: 12, child: Icon(Icons.local_florist, color: Color(0xFFE6C3A6), size: 36)),
          ],
        );
      case LetterPaperStyle.white:
        return const SizedBox.shrink();
    }
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.2)..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += 16) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += 16) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
