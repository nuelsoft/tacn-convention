import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tacn_convention/areas.dart';
import 'package:tacn_convention/custom_selector.dart' as DatumSelector;
import 'package:tacn_convention/global.dart';
import 'package:tacn_convention/state.dart';
import 'package:tacn_convention/titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatumForm extends StatefulWidget {
  @override
  _DatumFormState createState() => _DatumFormState();
}

class _DatumFormState extends State<DatumForm> {
  bool mTicket = false;
  int ageSelected = 1;
  List<String> genderSelectItems = ["Male", "Female"];
  List<String> ageSelectItems = ["Child", "Youth", "Adult"];

  static TextEditingController nameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController assemblyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();

  void clear() {
    Global.areaController.text = "Aba";
    nameController.clear();
    Global.titleController.text = "Pastor";
    assemblyController.clear();
    mTicket = false;
    phoneController.clear();
    ageSelected = 1;
    Global.selectedGender = 0;
    Global.selectedArea = 0;
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return ListView(
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "Please fill out the form \nAll fields are compulsory unless otherwise indicated"),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: (str) =>
                      (str.length == 0) ? "please fill this out" : null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 15, bottom: 15, right: 10, left: 10),
                      labelText: "Name",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: Global.titleController,
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Titles()));
                  },
                  readOnly: true,
                  validator: (str) =>
                      (str.length == 0) ? "please choose a title" : null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 15, bottom: 15, right: 10, left: 10),
                      labelText: "Title",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: DatumSelector.Selector(
                  items: genderSelectItems,
                  selectedIndex: Global.selectedGender,
                  title: "Gender",
                  onSelect: (i) {
                    setState(() {
                      Global.selectedGender = i;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  validator: (str) =>
                      (str.length == 0) ? "please fill this out" : null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 15, bottom: 15, right: 10, left: 10),
                      labelText: "Phone Number",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: DatumSelector.Selector(
                  items: ageSelectItems,
                  selectedIndex: ageSelected,
                  title: "Age Bracket",
                  onSelect: (i) {
                    setState(() {
                      ageSelected = i;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (_) => Areas()));
                  },
                  readOnly: true,
                  textCapitalization: TextCapitalization.words,
                  controller: Global.areaController,
                  validator: (str) =>
                      (str.length == 0) ? "please fill this out" : null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 15, bottom: 15, right: 10, left: 10),
                      labelText: "Area",
                      // suffix: GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context, CupertinoPageRoute(builder: (_) => Areas()));
                      //   },
                      //   child: Text("Select"),
                      // ),
                      border: OutlineInputBorder()),
                ),
              ),
              SwitchListTile(
                value: mTicket,
                title: Text("Meal Ticket"),
                onChanged: (b) {
                  setState(() {
                    mTicket = b;
                  });
                },
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 8, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          clear();
                        });
                      },
                      child: Text("Clear"),
                    ),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Firestore fstore = Firestore.instance;

                          fstore
                              .collection("collectors")
                              .document(Global.username)
                              .setData({
                            "collected": FieldValue.arrayUnion([
                              {
                                "title": Global.titleController.text,
                                "name": nameController.text,
                                "gender":
                                    genderSelectItems[Global.selectedGender],
                                "phone": phoneController.text,
                                "age_bracket": ageSelectItems[ageSelected],
                                "area": Global.areaController.text,
                                "meal_ticket": mTicket,
                                "collector": Global.username,
                                "year": DateTime.now().year.toString()
                              }
                            ])
                          }, merge: true);

                          fstore
                              .collection("all")
                              .document(DateTime.now().year.toString())
                              .setData({
                            "collected": FieldValue.arrayUnion([
                              {
                                "title": Global.titleController.text,
                                "name": nameController.text,
                                "gender":
                                    genderSelectItems[Global.selectedGender],
                                "phone": phoneController.text,
                                "age_bracket": ageSelectItems[ageSelected],
                                "area": Global.areaController.text,
                                "meal_ticket": mTicket,
                                "collector": Global.username,
                                "year": DateTime.now().year.toString()
                              }
                            ])
                          }, merge: true);
                          state.incrementLocalCount();

                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {}
                          } on SocketException catch (_) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Saved data locally"),
                            ));
                          }
                          clear();
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                  "You have some missing or incorrect fields. Check them out and try again."),
                            ),
                          ));
                        }
                      },
                      child: Text("Submit"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
