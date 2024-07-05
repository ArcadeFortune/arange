import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:ar_flutter_plugin_flutterflow/widgets/ar_view.dart';
import 'package:arange/components/MikanButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart' as material;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';

class ARangePage extends StatefulWidget {
  const ARangePage({super.key});

  @override
  State<StatefulWidget> createState() => _ARangePageState();
}

class _ARangePageState extends State<ARangePage> {
  late ARSessionManager sessionManager;
  late ARObjectManager objectManager;
  late ARAnchorManager anchorManager;
  late ARLocationManager locationManager;

  bool _showTextField = false;
  final TextEditingController _textController = TextEditingController();

  void _toggleTextField() {
    setState(() {
      _showTextField = !_showTextField;
    });
  }

  void _logEnteredText() async {
    //if the user entered text
    if (_showTextField && _textController.text.isNotEmpty) {
      _toggleTextField();
      await generateImageWithText(_textController.text);
      await spawnMikan();
      print('Entered text: ${_textController.text}');
      _textController.text = '';
    } else {
      _toggleTextField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ARView(
          onARViewCreated: _onARViewCreated,
        ),
        Positioned(
          bottom: _showTextField ? 110 : 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              // spawnMikan();
              _logEnteredText();
            },
            child: const Icon(Icons.add),
          ),
        ),
        if (_showTextField)
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: material.Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: TextField(
                  autofocus: true,
                  controller: _textController,
                  onSubmitted: (String value) {
                    _logEnteredText();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add remark',
                  ),
                ),
              ),
            ),
          ),
      ],
    ));
  }

  Future<void> spawnMikan() async {
    final directory = await getApplicationDocumentsDirectory();

    print('MikanButton pressed');
    final cameraPose = await sessionManager.getCameraPose();
    final cameraPosition = cameraPose!.getTranslation();
    final cameraRotation = cameraPose.getRotation();
    final cameraForward = cameraRotation.forward;
    var mikanPosition = Vector3(
      (cameraPosition.x - cameraForward.x) * 4,
      (cameraPosition.y - cameraForward.y) * 4,
      (cameraPosition.z - cameraForward.z) * 4,
    );
    await objectManager.addNode(ARNode(
        // type: NodeType.fileSystemAppFolderGLTF2,
        // uri: 'd.gltf',
        // uri: '/data/user/0/com.example.arange/app_flutter/c.gltf',
        type: NodeType.fileSystemAppFolderGLB,
        uri: 'girl.glb',
        scale: Vector3(1, 1, 1),
        position: mikanPosition,
        transformation: cameraPose //transform to look at the camera
        ));

    mikanPosition.y -= 0.5; 
    // cameraPose.row0 = Vector4(0.0, 1.0, 0.0, 1.0);
    // cameraPose.row1 = Vector4(1.0, 0.0, 0.0, 0.0);
    // cameraPose.row2 = Vector4(0.0, 0.0, -1.0, 0.0);
    await objectManager.addNode(ARNode(
        type: NodeType.fileSystemAppFolderGLTF2,
        uri: 'text_cube.gltf',
        scale: Vector3(0.5, 0.5, 0.5),
        position: mikanPosition,
        transformation: cameraPose//transform to look at the camera
        ));
        print(cameraRotation);
        print(cameraRotation.forward);
    print('Mikan spawned');
  }

  void _onARViewCreated(
      ARSessionManager ARSessionManager,
      ARObjectManager ARObjectManager,
      ARAnchorManager ARAnchorManager,
      ARLocationManager ARLocationManager) async {
    //store the managers
    sessionManager = ARSessionManager;
    objectManager = ARObjectManager;
    anchorManager = ARAnchorManager;
    locationManager = ARLocationManager;

    //initialize the managers
    await ARSessionManager.onInitialize();
    await ARObjectManager.onInitialize();

    await _saveFile('text_cube.bin');
    await _saveFile('text_cube.gltf');
    await _saveFile('girl.glb');
    await generateImageWithText('Watch: Date A Live');

    // Get the application's documents directory
    final directory = await getApplicationDocumentsDirectory();

    // List the contents of the directory
    final List<FileSystemEntity> contents = directory.listSync();

    // Print the contents
    print('Contents of ${directory.path}:');
    for (var entity in contents) {
      print(entity.path);
    }
  }
}

//function to save a file from the rootbundle to the app directory
Future<void> _saveFile(String fileName) async {
  // Get the path to the documents directory
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;

  // Load the image from assets
  final byteData = await rootBundle.load('assets/$fileName');

  // Create a file in the documents directory
  final file = File('$path/$fileName');

  // Write the image data to the file
  await file.writeAsBytes(byteData.buffer.asUint8List());

  print('File saved to ${file.path}');
}

Future<void> generateImageWithText(String text) async {
  // Create a new image with desired dimensions
  final img.Image image = img.Image(width: 600, height: 200);
  // final img.Image image = img.Image(width: 400, height: 200);

  // Set a background color
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));

  // Load a font
  final img.BitmapFont font = img.arial48;

  // Draw the text on the image
  // img.drawString(image, text, font: font, x: 20, y: 80, color: img.ColorRgb8(255, 0, 0));
  img.drawString(image, text,
      font: font, x: 20, y: 20, color: img.ColorRgb8(255, 255, 255));

  // Convert the image to PNG format
  final Uint8List pngBytes = Uint8List.fromList(img.encodePng(image));

  // Get the application documents directory
  final Directory directory = await getApplicationDocumentsDirectory();
  final String path = '${directory.path}/texture.png';

  // Write the PNG file to the documents directory
  final File file = File(path);
  await file.writeAsBytes(pngBytes);

  print('Image saved to $path');
}
