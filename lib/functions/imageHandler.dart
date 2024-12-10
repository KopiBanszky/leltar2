import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class ImageHandler {
  
  static Future<XFile?> getImage({bool binary = false, bool camera = false}) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: camera ? ImageSource.camera : ImageSource.gallery);
      return image;
  }

  static Future<List<XFile>?> getImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    return images;
  }

  static File saveImage(XFile image) {
    final File file = File(image.path);
    return file;
  }

  static Image displayImage(XFile image, {
    double width = 100,
    double height = 100
  }) {
    if(kIsWeb) {
      return Image.network(image.path, width: width, height: height);
    } else {
      return Image.file(File(image.path), width: width, height: height);
    }
  }

}