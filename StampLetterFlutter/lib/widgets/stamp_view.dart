import 'dart:io';
import 'package:flutter/material.dart';
import '../models/stamp.dart';

class StampView extends StatelessWidget {
  final Stamp stamp;
  final double size;

  const StampView({super.key, required this.stamp, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final borderColor = stamp.frameStyle == StampFrameStyle.modern
        ? Colors.grey.shade600
        : stamp.frameStyle == StampFrameStyle.vintage
            ? const Color(0xFF8B6C52)
            : const Color(0xFFB9372D);

    return Container(
      width: size,
      height: size * 1.2,
      decoration: BoxDecoration(
        color: stamp.frameStyle == StampFrameStyle.vintage ? const Color(0xFFFAF0E6) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: stamp.frameStyle == StampFrameStyle.modern ? 2 : 4),
      ),
      child: Column(
        children: [
          if (stamp.frameStyle == StampFrameStyle.classic)
            Container(
              height: 8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFB9372D), Color(0xFFFFFFFF)]),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ColorFiltered(
                  colorFilter: stamp.isBlackAndWhite
                      ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                      : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                  child: Image.file(
                    File(stamp.imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(
              '${stamp.price}원',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}
