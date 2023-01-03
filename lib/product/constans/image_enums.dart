import 'package:flutter/material.dart';

enum ImageEnums {
  splash
}


extension ImageExtension on ImageEnums {
  String get _toPath => 'assets/images/$name.png';
  Image get toImage => Image.asset(_toPath);
  Image get cardToImage => Image.asset(
        _toPath,
        width: 40,
        height: 40,
      );
}
