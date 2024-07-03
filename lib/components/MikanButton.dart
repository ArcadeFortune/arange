import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class MikanButton extends StatelessWidget {
  final ARObjectManager objectManager;

  const MikanButton(this.objectManager, {super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          _buttonPressed(objectManager);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _buttonPressed(ARObjectManager manager) async {
    print('MikanButton pressed');
    
    await manager.addNode(ARNode(
      type: NodeType.webGLB,
      // uri: 'assets/Mikan.gltf',
      uri: 'https://cdn.discordapp.com/attachments/1254416954379472946/1257954435376611411/just_a_girl.glb?ex=668648dd&is=6684f75d&hm=68f12325dedc5f0b41577fb5eb16e0a84d87b43c6bec0967a99f70485143bf9f&',
      scale: Vector3(0.2, 0.2, 0.2),
      position: Vector3(0.0, 0.0, 0.0),
      rotation: Vector4(1.0, 0.0, 0.0, 0.0)));
  }
}