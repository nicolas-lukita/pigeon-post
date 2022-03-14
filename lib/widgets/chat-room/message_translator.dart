import 'package:flutter/material.dart';
import 'package:pigeon_post/api/translator_api.dart';
import 'package:translator/translator.dart';
import '../../models/language.dart';

class MessageTranslator extends StatefulWidget {
  final String text;
  final String language1Code;
  final String language2Code;
  final Widget Function(String translation) builder;
  const MessageTranslator(
      {Key? key,
      required this.text,
      required this.language1Code,
      required this.language2Code,
      required this.builder})
      : super(key: key);

  @override
  _MessageTranslatorState createState() => _MessageTranslatorState();
}

class _MessageTranslatorState extends State<MessageTranslator> {
  @override
  Widget build(BuildContext context) {
    String translation = '';
    return FutureBuilder(
        future: TranslatorApi.translateMessage(
            widget.text, widget.language1Code, widget.language2Code),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            widget.builder(translation);
          } else if (snapShot.hasError) {
            translation = 'an error occured!';
          } else {
            translation = snapShot.data;
          }
          return widget.builder(translation);
        });
  }
}
