import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:ar_flutter_plugin_flutterflow/widgets/ar_view.dart';
import 'package:arange/components/text_prompt.dart';
import 'package:arange/provider/arange_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';

class ARangePage extends StatefulWidget {
  const ARangePage({super.key});

  @override
  State<StatefulWidget> createState() => _ARangePageState();
}

class _ARangePageState extends State<ARangePage> {
  //variables for the current managers
  late ARSessionManager sessionManager;
  late ARObjectManager objectManager;
  late ARAnchorManager anchorManager;
  late ARLocationManager locationManager;

  //to show the textfield
  final TextEditingController _textController = TextEditingController();
  bool _showTextPrompt = false;
  void _toggleTextPrompt() {
    setState(() {
      _showTextPrompt = !_showTextPrompt;
    });
  }
  void _handleButtonClick(text) async {
    print('button clicked with $_showTextPrompt and text $text');
    //if the user entered text to PLACE MIKAN
    if (_showTextPrompt && text.isNotEmpty) {
      _toggleTextPrompt();
      await Provider.of<ArangeProvider>(context, listen: false).create3dText(text);
      await spawnMikan();
      print('Entered text: ${text}');
      _textController.text = '';
    } else {
      _toggleTextPrompt();
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
          bottom: _showTextPrompt ? 110 : 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              _handleButtonClick(_textController.text);
            },
            child: const Icon(Icons.add),
          ),
        ),
        if (_showTextPrompt)
          TextPrompt(textController: _textController, handleButtonClick: _handleButtonClick,)
      ],
    ));
  }

  Future<void> spawnMikan() async {
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
        type: NodeType.fileSystemAppFolderGLB,
        uri: 'mikan.glb',
        scale: Vector3(1, 1, 1),
        position: mikanPosition,
        transformation: cameraPose //transform to look at the camera
        ));

    mikanPosition.y -= 0.46;

    await objectManager.addNode(ARNode(
        type: NodeType.fileSystemAppFolderGLTF2,
        uri: 'text_cube.gltf',
        scale: Vector3(0.5, 0.5, 0.5),
        position: mikanPosition,
        transformation: cameraPose //transform to look at the camera
        ));
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
  }
}
