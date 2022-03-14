import 'package:flutter/material.dart';
import 'package:pigeon_post/pages/language_page.dart';
import 'package:pigeon_post/providers/language_provider.dart';
import 'package:provider/provider.dart';

class TranslateBar extends StatefulWidget {
  const TranslateBar({Key? key}) : super(key: key);

  @override
  State<TranslateBar> createState() => _TranslateBarState();
}

class _TranslateBarState extends State<TranslateBar> {
  void _chooseFirstLanguage(String title, bool isAutomaticEnabled) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LanguagePage(
                  title: title,
                  isAutomaticEnabled: isAutomaticEnabled,
                  whichLanguage: 1,
                )));
  }

  void _chooseSecondLanguage(String title, bool isAutomaticEnabled) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LanguagePage(
                  title: title,
                  isAutomaticEnabled: isAutomaticEnabled,
                  whichLanguage: 2,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFfaf8f5),
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
                  onTap: () {
                    _chooseFirstLanguage('Translate from', true);
                  },
                  child: Center(
                      child: Text(
                    context.watch<LanguageProvider>().language1.name,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize:17),
                  )))),
          IconButton(
            icon: Icon(Icons.swap_horiz, color: Theme.of(context).primaryColor),
            onPressed: () {
              context.read<LanguageProvider>().language1.code != 'auto'
                  ? context.read<LanguageProvider>().languageSwap()
                  : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Second language cannot be \'Automatic\'')));
            },
          ),
          Expanded(
              child: InkWell(
                  onTap: () {
                    _chooseSecondLanguage('Translate to', false);
                  },
                  child: Center(
                      child: Text(
                    context.watch<LanguageProvider>().language2.name,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize:17),
                  ))))
        ],
      ),
    );
  }
}
