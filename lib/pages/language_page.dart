import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../models/language.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import '../widgets/language_tile.dart';
import '../providers/language_provider.dart';
import '../providers/language_provider.dart';

class LanguagePage extends StatefulWidget {
  final String title;
  final bool isAutomaticEnabled;
  final int whichLanguage;
  const LanguagePage(
      {Key? key,
      required this.title,
      required this.isAutomaticEnabled,
      required this.whichLanguage})
      : super(key: key);
  static const routeName = '/language-page';

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final TextEditingController _searchController = TextEditingController();

  _sendBackLanguage1(Language language) {
    context.read<LanguageProvider>().setLanguage1(language);
    Navigator.pop(context);
  }

  _sendBackLanguage2(Language language) {
    context.read<LanguageProvider>().setLanguage2(language);
    Navigator.pop(context);
  }

  //display list of all languages
  Widget _displayAllList(int _whichLanguage) {
    return Expanded(
      child: CustomScrollView(
        slivers: <Widget>[
          // SliverStickyHeader(
          //   header: Container(
          //     height: 60,
          //     color: Theme.of(context).primaryColor,
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     alignment: Alignment.centerLeft,
          //     child: const Text(
          //       'Recent Languages',
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w500),
          //     ),
          //   ),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate((context, index) {}),
          //   ),
          // ),
          SliverStickyHeader(
            header: Container(
              height: 60,
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'All Languages',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                //disable Automatic for second language
                if (!widget.isAutomaticEnabled && index == 0) {
                  return LanguageTile(
                    language:
                        context.read<LanguageProvider>().languageList[index],
                    onSelected: (_) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Second language cannot be \'Automatic\'')));
                    },
                  );
                } else {
                  return LanguageTile(
                    language:
                        context.read<LanguageProvider>().languageList[index],
                    onSelected: _whichLanguage == 1
                        ? _sendBackLanguage1
                        : _sendBackLanguage2,
                  );
                }
              },
                  childCount:
                      context.read<LanguageProvider>().languageList.length),
            ),
          )
        ],
      ),
    );
  }

  //display list for searched languages
  Widget _displaySearchedList(int _whichLanguage) {
    //list of language where the name is the same as the searched name
    List<Language> searchedList = context
        .read<LanguageProvider>()
        .languageList
        .where((element) => element.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return Expanded(
        child: ListView.builder(
            itemCount: searchedList.length,
            itemBuilder: (ctx, index) {
              return LanguageTile(
                language: searchedList[index],
                onSelected: _whichLanguage == 1
                    ? _sendBackLanguage1
                    : _sendBackLanguage2,
              );
            }));
  }

  Widget _displayList(int _whichLanguage) {
    if (_searchController.text == "") {
      return _displayAllList(_whichLanguage);
    } else {
      return _displaySearchedList(_whichLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search..',
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.grey,
                ),
                suffixIcon: (_searchController.text.length > 0)
                    ? IconButton(
                        icon: Icon(Icons.close),
                        color: Colors.grey,
                        //clear button ('x' button)
                        onPressed: () {
                          setState(() {
                            _searchController.text = ""; // Reset the text
                          });
                        })
                    : null,
              ),
              onChanged: (txt) {
                setState(() {});
              },
            ),
          ),
          _displayList(widget.whichLanguage)
        ],
      ),
    );
  }
}
