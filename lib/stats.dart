import 'package:datum/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Stat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Datum Stats'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
              title: Text('Locally Collected'),
              trailing: Text(state.getLocalCount().toString())),
          ListTile(
              title: Text('Synced Online'),
              trailing: Text(state.getSyncedCount().toString())),
          ListTile(
              title: Text('To be Synced'),
              trailing: Text(
                  (state.getLocalCount() - state.getSyncedCount()).toString()))
        ],
      ),
    );
  }
}
