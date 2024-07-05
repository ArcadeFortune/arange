import 'package:flutter/material.dart';

class TextPrompt extends StatelessWidget {  
  final void Function(String) handleButtonClick;
  final TextEditingController textController;

  static void noOp(String _) { }
  const TextPrompt({required this.textController, this.handleButtonClick=noOp, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          child: TextField(
            autofocus: true,
            controller: textController,
            onSubmitted: handleButtonClick,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Add remark',
            ),
          ),
        ),
      ),
    );
  }
}
