import 'package:arange/service/arange_service.dart';
import 'package:flutter/material.dart';

class ArangeProvider extends ChangeNotifier {
  final ArangeService _arangeService;
  ArangeProvider(this._arangeService);

  Future<void> create3dText(String text) {
    return _arangeService.create3dText(text);
  }
}
