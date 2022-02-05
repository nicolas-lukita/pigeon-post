import 'package:flutter/material.dart';
import '../models/language.dart';

class LanguageTile extends StatefulWidget {
  final Language language;
  final Function(Language) onSelected;
  const LanguageTile(
      {Key? key, required this.language, required this.onSelected})
      : super(key: key);

  @override
  _LanguageTileState createState() => _LanguageTileState();
}

class _LanguageTileState extends State<LanguageTile> {
  Widget? _displayTrailingIcon() {
    if (widget.language.isDownloadable) {
      if (widget.language.isDownloaded) {
        return const Icon(Icons.check_circle);
      } else {
        return const Icon(Icons.file_download);
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.language.name),
      trailing: _displayTrailingIcon(),
      onTap: () {
        widget.onSelected(widget.language);
      },
    );
  }
}
