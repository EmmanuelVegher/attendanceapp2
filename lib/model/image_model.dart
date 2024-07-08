import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
//part 'image_model.g.dart';

@Collection()
class ImageEntity {
  Id id = Isar.autoIncrement;
  //Uint8List? imageBytes;
  // Id id = Isar.autoIncrement;

  //late Uint8List imageBytes;
}
