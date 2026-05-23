import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

enum StampFrameStyle { classic, modern, vintage }

extension StampFrameStyleX on StampFrameStyle {
  String get label {
    switch (this) {
      case StampFrameStyle.classic:
        return '클래식';
      case StampFrameStyle.modern:
        return '모던';
      case StampFrameStyle.vintage:
        return '빈티지';
    }
  }

  String get assetName {
    switch (this) {
      case StampFrameStyle.classic:
        return 'classic';
      case StampFrameStyle.modern:
        return 'modern';
      case StampFrameStyle.vintage:
        return 'vintage';
    }
  }
}

class Stamp {
  final String id;
  final String imagePath;
  final bool isBlackAndWhite;
  final int price;
  final StampFrameStyle frameStyle;

  Stamp({
    required this.id,
    required this.imagePath,
    required this.isBlackAndWhite,
    required this.price,
    required this.frameStyle,
  });

  factory Stamp.fromJson(Map<String, dynamic> json) {
    return Stamp(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      isBlackAndWhite: json['isBlackAndWhite'] as bool,
      price: json['price'] as int,
      frameStyle: StampFrameStyle.values.firstWhere(
        (style) => style.name == json['frameStyle'] as String,
        orElse: () => StampFrameStyle.classic,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'isBlackAndWhite': isBlackAndWhite,
      'price': price,
      'frameStyle': frameStyle.name,
    };
  }

  ImageProvider get imageProvider {
    return FileImage(File(imagePath));
  }
}
