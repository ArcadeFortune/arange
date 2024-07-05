import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class ArangeService {
  ArangeService();

  Future<void> create3dText(String text) async {
    // Create a new image with desired dimensions
    final Image image = Image(width: 600, height: 200);

    // Set a background color
    fill(image, color: ColorRgba8(0, 0, 0, 0));

    // Load a font
    final BitmapFont font = arial48;

    // Draw the text on the image
    drawString(image, text,
        font: font, x: 20, y: 20, color: ColorRgb8(255, 255, 255));

    // Convert the image to PNG format
    final Uint8List pngBytes = Uint8List.fromList(encodePng(image));

    // Get the application documents directory
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/texture.png';

    // Write the PNG file to the documents directory
    final File file = File(path);
    await file.writeAsBytes(pngBytes);

    print('Image saved to $path');
  }

  Future<void> load() async {
    await _saveAssets('text_cube.bin');
    await _saveAssets('text_cube.gltf');
    await _saveAssets('girl.glb');
    await create3dText('Watch: Date A Live');
  }

  
  //function to save a file from the rootbundle to the app directory
  Future<void> _saveAssets(String fileName) async {
    // Get the path to the documents directory
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    // Load the image from assets
    final byteData = await rootBundle.load('assets/$fileName');

    // Create a file in the documents directory
    final file = File('$path/$fileName');

    // Write the image data to the file
    await file.writeAsBytes(byteData.buffer.asUint8List());

    print('Asset saved to ${file.path}');
  }
}

