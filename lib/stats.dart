import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tacn_convention/global.dart';
import 'package:tacn_convention/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_collected.dart';

//TODO: Let the User see their saved Data.

class Stat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
              title: Text('Locally Collected'),
              trailing: Text(state.getLocalCount().toString())),
          ListTile(
            title: Text('All Synced Data'),
            trailing: StreamBuilder(
                stream: Firestore.instance
                    .collection("collectors")
                    .document(Global.username)
                    .snapshots(),
                builder: (ctx, snp) {
                  try {
                    while (snp.connectionState == ConnectionState.waiting) {
                      return Text("?");
                    }
                    if (snp.data == null) {
                      return Text("0");
                    } else if (snp.data['collected'] == null) {
                      return Text("?");
                    } else {
                      return Text(snp.data['collected'].length);
                    }
                  } catch (e) {
                    return Text("?");
                  }
                }),
          ),

          Divider(),
          ListTile(
            title: Text(
              "View saved data",
            ),
            leading: Icon(Icons.insert_drive_file,
                color: Theme.of(context).primaryColor),
            onTap: () => Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Collected())),
          ),
          Divider()
        ],
      ),
    );
  }
}
