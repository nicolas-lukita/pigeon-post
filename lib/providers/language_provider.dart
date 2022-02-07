import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pigeon_post/widgets/language_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models/language.dart';

class LanguageProvider with ChangeNotifier {
  final List<Language> _languageList = [
    Language(
        code: 'auto',
        name: 'Automatic',
        isRecent: false,
        isDownloaded: false,
        isDownloadable: false),
    Language(
        code: 'en',
        name: 'English',
        isRecent: false,
        isDownloaded: false,
        isDownloadable: false),
    Language(
        code: 'id',
        name: 'Indonesian',
        isRecent: false,
        isDownloaded: false,
        isDownloadable: false),
    Language(
        code: 'zh-cn',
        name: 'Chinese Simplified',
        isRecent: false,
        isDownloaded: false,
        isDownloadable: false),
    Language(
        code: 'zh-tw',
        name: 'Chinese Traditional',
        isRecent: false,
        isDownloaded: false,
        isDownloadable: false),
  ];

  Language language1 = Language(
      code: 'auto',
      name: 'Automatic',
      isRecent: false,
      isDownloaded: false,
      isDownloadable: false);

  Language language2 = Language(
      code: 'id',
      name: 'Indonesian',
      isRecent: false,
      isDownloaded: false,
      isDownloadable: false);

  List<Language> get languageList => _languageList;

  void languageSwap() {
    Language _temp = language1;
    language1 = language2;
    language2 = _temp;
    notifyListeners();
  }

  setLanguage1(Language language) {
    language1 = language;
    notifyListeners();
  }

  setLanguage2(Language language) {
    language2 = language;
    notifyListeners();
  }
}
