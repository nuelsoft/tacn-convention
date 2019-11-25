import 'package:datum/admin.dart';
import 'package:datum/form.dart';
import 'package:datum/global.dart';
import 'package:datum/state.dart';
import 'package:datum/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
 await Global().setPref();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datum',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Montserrat"),
      home: ChangeNotifierProvider(
          builder: (context) => AppState(), child: MyHomePage(title: 'Datum')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final bool adminMode = true;

  @override
  _MyHomePageState createState() {
    // Global().setPref();
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                          builder: (_) => AppState(), child: Stat())));
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 15),
              child: Container(
                  height: 60,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Center(
                      child: Text(
                    (state.getLocalCount() - state.getSyncedCount()).toString(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))),
            ),
          ),
          (widget.adminMode)
              ? IconButton(
                  icon: Icon(Icons.dashboard),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminPage()));
                  })
              : Container(
                  height: 0,
                  width: 0,
                )
        ]),
        body: DatumForm());
  }
}
