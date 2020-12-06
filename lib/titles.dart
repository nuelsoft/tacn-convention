import 'package:tacn_convention/custom_selector.dart';
import 'package:tacn_convention/global.dart';
import 'package:flutter/material.dart';

class Titles extends StatefulWidget {
  @override
  _TitlesState createState() => _TitlesState();
}

class _TitlesState extends State<Titles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Title")),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Selector(
            items: Global.titles,
            onSelect: (i) {
              Global.titleController.text = Global.titles[i];
              setState(() {
                Global.selectedTitle = i;
                Global.selectedGender = (Global.titles[i] == "Deaconess" ||
                        Global.titles[i] == "Mistress")
                    ? 1
                    : 0;
              });
              Navigator.pop(context);
            },
            selectedIndex: Global.selectedTitle,
          )
        ],
      ),
    );
  }
}
