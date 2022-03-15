import 'package:flutter/material.dart';
import 'package:pigeon_post/widgets/chat-room/message_translator.dart';
import './message_bubble.dart';
import './message_translator.dart';
import 'package:provider/src/provider.dart';
import 'package:pigeon_post/providers/language_provider.dart';

class TranslatedMessageBubble extends StatefulWidget {
  final String username;
  final String message;
  final DateTime timeSent;
  final String translatedMessagePlaceholder;
  final bool isMe;
  const TranslatedMessageBubble(
      {Key? key,
      required this.username,
      required this.message,
      required this.timeSent,
      required this.translatedMessagePlaceholder,
      required this.isMe})
      : super(key: key);

  @override
  State<TranslatedMessageBubble> createState() =>
      _TranslatedMessageBubbleState();
}

class _TranslatedMessageBubbleState extends State<TranslatedMessageBubble> {
  bool _individualTranslate = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _individualTranslate = !_individualTranslate;
          });
        },
        child: _individualTranslate
            ? MessageTranslator(
                text: widget.message,
                language1Code: context.watch<LanguageProvider>().language1.code,
                language2Code: context.watch<LanguageProvider>().language2.code,
                builder: (translatedMessage) => MessageBubble(
                    username: widget.username,
                    message: widget.message,
                    timeSent: widget.timeSent,
                    translatedMessage: translatedMessage,
                    isMe: widget.isMe,
                    isTranslated: true,),
              )
            : MessageBubble(
                username: widget.username,
                message: widget.message,
                timeSent: widget.timeSent,
                translatedMessage: widget.translatedMessagePlaceholder,
                isMe: widget.isMe,
                isTranslated: false));
  }
}
