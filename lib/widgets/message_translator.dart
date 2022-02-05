import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../models/language.dart';

class MessageTranslator extends StatefulWidget {
  const MessageTranslator({Key? key}) : super(key: key);

  @override
  _MessageTranslatorState createState() => _MessageTranslatorState();
}

class _MessageTranslatorState extends State<MessageTranslator> {
  String _translatedMessage = '';
  GoogleTranslator _translator = new GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
