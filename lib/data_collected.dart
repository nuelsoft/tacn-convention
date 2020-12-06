import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacn_convention/global.dart';

class Collected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Collected Data")),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("collectors")
                .document(Global.username)
                .snapshots(),
            builder: (ctx, snp) {
              while (snp.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snp.hasData) {
                return Center(child: Text("Nothing yet"));
              }
              try {
                return ListView.builder(
                    itemCount: snp.data["collected"].length,
                    itemBuilder: (ctx, i) => ListTile(
                          title: Text(
                              "${snp.data['collected'][i]['title']} ${snp.data['collected'][i]['name']}"),
                          subtitle: Text(snp.data['collected'][i]['area']),
                          trailing: Text(
                              (snp.data['collected'][i]['year'] == null)
                                  ? "2019"
                                  : snp.data['collected'][i]['year']),
                        ));
              } catch (e) {
                return Center(child: Text("..."));
              }
            }));
  }
}
