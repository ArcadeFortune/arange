import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:ar_flutter_plugin_flutterflow/widgets/ar_view.dart';
import 'package:arange/components/MikanButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ARView(onARViewCreated: _onARViewCreated),
      // if (isInitialized) MikanButton(objectManager)
      Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          spawnMikan();
        },
        child: const Icon(Icons.add),
      ),
    )
    ]));
  }

  void spawnMikan() async {
    print('MikanButton pressed'); 
    await objectManager.addNode(ARNode(
      type: NodeType.webGLB,
      uri: 'https://cdn.discordapp.com/attachments/1254416954379472946/1257954435376611411/just_a_girl.glb?ex=668648dd&is=6684f75d&hm=68f12325dedc5f0b41577fb5eb16e0a84d87b43c6bec0967a99f70485143bf9f&',
      scale: Vector3(0.2, 0.2, 0.2),
      //position is will be the distance between spawn and current location
      position: Vector3(0,0,0),
      rotation: Vector4(1.0, 0.0, 0.0, 0.0))
    );
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
    }
  }
  

//   Future<void> _loadMikan() async {
//     // Get the path to the documents directory
//     final directory = await getApplicationDocumentsDirectory();
//     final path = directory.path;

//     // Load the image from assets
//     final byteData = await rootBundle.load('assets/MikanFinishedWah.glb');

//     // Create a file in the documents directory
//     final file = File('$path/Mikan.glb');

//     // Write the image data to the file
//     await file.writeAsBytes(byteData.buffer.asUint8List());

//     print('Mikan saved to ${file.path}');
//   }




