import 'package:flutter/material.dart';
import 'stamp.dart';

enum LetterPaperStyle { kraft, watercolor, check, floral, white }

enum StampPosition { topRight, topLeft, bottomRight, bottomLeft }

enum LetterFont { handwriting, serif, sans }

extension LetterPaperStyleX on LetterPaperStyle {
  String get label {
    switch (this) {
      case LetterPaperStyle.kraft:
        return '크라프트';
      case LetterPaperStyle.watercolor:
        return '수채화';
      case LetterPaperStyle.check:
        return '체크';
      case LetterPaperStyle.floral:
        return '플로럴';
      case LetterPaperStyle.white:
        return '화이트';
    }
  }
}

extension StampPositionX on StampPosition {
  String get label {
    switch (this) {
      case StampPosition.topRight:
        return '상단 오른쪽';
      case StampPosition.topLeft:
        return '상단 왼쪽';
      case StampPosition.bottomRight:
        return '하단 오른쪽';
      case StampPosition.bottomLeft:
        return '하단 왼쪽';
    }
  }
}

extension LetterFontX on LetterFont {
  String get label {
    switch (this) {
      case LetterFont.handwriting:
        return '손글씨';
      case LetterFont.serif:
        return '명조';
      case LetterFont.sans:
        return '고딕';
    }
  }

  TextStyle get textStyle {
    switch (this) {
      case LetterFont.handwriting:
        return const TextStyle(fontFamily: 'DancingScript', fontSize: 16);
      case LetterFont.serif:
        return const TextStyle(fontFamily: 'Merriweather', fontSize: 16);
      case LetterFont.sans:
        return const TextStyle(fontFamily: 'NotoSans', fontSize: 16);
    }
  }
}

class Letter {
  final String id;
  final Stamp stamp;
  final LetterPaperStyle paperStyle;
  final StampPosition stampPosition;
  final String content;
  final LetterFont font;
  final Color textColor;
  final String senderName;
  final String receiverName;
  final DateTime createdAt;

  Letter({
    required this.id,
    required this.stamp,
    required this.paperStyle,
    required this.stampPosition,
    required this.content,
    required this.font,
    required this.textColor,
    required this.senderName,
    required this.receiverName,
    required this.createdAt,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['id'] as String,
      stamp: Stamp.fromJson(json['stamp'] as Map<String, dynamic>),
      paperStyle: LetterPaperStyle.values.firstWhere(
        (style) => style.name == json['paperStyle'] as String,
        orElse: () => LetterPaperStyle.white,
      ),
      stampPosition: StampPosition.values.firstWhere(
        (position) => position.name == json['stampPosition'] as String,
        orElse: () => StampPosition.topRight,
      ),
      content: json['content'] as String,
      font: LetterFont.values.firstWhere(
        (font) => font.name == json['font'] as String,
        orElse: () => LetterFont.handwriting,
      ),
      textColor: Color(int.parse(json['textColor'] as String)),
      senderName: json['senderName'] as String,
      receiverName: json['receiverName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stamp': stamp.toJson(),
      'paperStyle': paperStyle.name,
      'stampPosition': stampPosition.name,
      'content': content,
      'font': font.name,
      'textColor': textColor.value.toString(),
      'senderName': senderName,
      'receiverName': receiverName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
