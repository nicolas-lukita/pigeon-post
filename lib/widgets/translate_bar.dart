import 'package:flutter/material.dart';

class TranslateBar extends StatefulWidget {
  const TranslateBar({Key? key}) : super(key: key);

  @override
  State<TranslateBar> createState() => _TranslateBarState();
}

class _TranslateBarState extends State<TranslateBar> {
  @override
  Widget build(BuildContext context) {
    String _language1 = 'Language 1';
    String _language2 = 'Language 2';
    return Container(
      color: const Color(0xFFfaf8f5),
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
                  onTap: () {},
                  child: Center(
                      child: Text(
                    _language1,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )))),
          IconButton(
            icon: Icon(Icons.swap_horiz, color: Theme.of(context).primaryColor),
            onPressed: () {
              setState(() {});
            },
          ),
          Expanded(
              child: InkWell(
                  onTap: () {},
                  child: Center(
                      child: Text(
                    _language2,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ))))
        ],
      ),
    );
  }
}
