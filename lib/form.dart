import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datum/areas.dart';
import 'package:datum/custom_selector.dart' as DatumSelector;
import 'package:datum/global.dart';
import 'package:datum/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatumForm extends StatefulWidget {
  @override
  _DatumFormState createState() => _DatumFormState();
}

class _DatumFormState extends State<DatumForm> {
  bool mTicket = false;
  int genderSelected = 0;
  int ageSelected = 0;
  List<String> genderSelectItems = ["Male", "Female"];
  List<String> ageSelectItems = ["Child", "Youth", "Adult"];

  static TextEditingController nameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController assemblyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clear() {
    Global.areaController.text = "Aba";
    nameController.clear();
    emailController.clear();
    assemblyController.clear();
    mTicket = false;
    phoneController.clear();
    ageSelected = 0;
    genderSelected = 0;
    Global.selectedArea = 0;
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
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
            children: <Widget>[
              Text(
                  "Please fill out the form \nAll fields are compulsory unless otherwise indicated"),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
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
                child: DatumSelector.Selector(
                  items: genderSelectItems,
                  selectedIndex: genderSelected,
                  title: "Gender",
                  onSelect: (i) {
                    setState(() {
                      genderSelected = i;
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
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (str) =>
                      (str.length != 0 && !EmailUtils.isEmail(str))
                          ? "please enter a correct email"
                          : null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 15, bottom: 15, right: 10, left: 10),
                      labelText: "Email (optional)",
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: assemblyController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 15, bottom: 15, right: 10, left: 10),
                      labelText: "Assembly (optional)",
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

                          fstore.collection("datum").document("data").setData({
                            "collected": FieldValue.arrayUnion([
                              {
                                "name": nameController.text,
                                "gender": genderSelectItems[genderSelected],
                                "phone": phoneController.text,
                                "email": emailController.text,
                                "age_bracket": ageSelectItems[ageSelected],
                                "area": Global.areaController.text,
                                "assembly": assemblyController.text,
                                "meal_ticket": mTicket
                              }
                            ])
                          }, merge: true).whenComplete(() {
                            state.incrementSyncedCount();
                          });
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
