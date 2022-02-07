// ignore: import_of_legacy_library_into_null_safe
import 'package:translator/translator.dart';

class TranslatorApi {
  static Future<String> translateMessage(
      String message, String language1Code, String language2Code) async {
    final translatedMessage = await GoogleTranslator()
        .translate(message, from: language1Code, to: language2Code);
    return translatedMessage.text;
  }
}
