import 'dart:convert';

import 'package:flutter/foundation.dart';

class FileEntity {
  final String? path;
  final String name;
  final Uint8List? bytes;
  const FileEntity({
    required this.name,
    this.path,
    this.bytes,
  });

  String readAsString() => utf8.decode(bytes ?? []);
}
