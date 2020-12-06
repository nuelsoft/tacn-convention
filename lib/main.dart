import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tacn_convention/admin.dart';
import 'package:tacn_convention/auth.dart';
import 'package:tacn_convention/form.dart';
import 'package:tacn_convention/global.dart';
import 'package:tacn_convention/state.dart';
import 'package:tacn_convention/stats.dart';
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
        title: 'TACN Convention',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Montserrat"),
        home: StreamBuilder(
            stream: Global().getUser(),
            builder: (ctx, snp) {
              while (snp.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snp.data == null) {
                return Auth();
              }
              return ChangeNotifierProvider(
                  builder: (context) => AppState(),
                  child: MyHomePage(title: 'TACN Convention'));
            }));
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

    return (state.getAuthState())
        ? Scaffold(
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
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("collectors")
                                .document(Global.username)
                                .snapshots(),
                            builder: (ctx, snp) {
                              try {
                                while (snp.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("?", style: TextStyle(color: Theme.of(context).primaryColor),);
                                }
                                if (snp.data == null) {
                                  return Text("0", style: TextStyle(color: Theme.of(context).primaryColor));
                                } else if (snp.data['collected'] == null) {
                                  return Text("?", style: TextStyle(color: Theme.of(context).primaryColor));
                                } else {
                                  return Text(snp.data['collected'].length);
                                }
                              } catch (e) {
                                print(e);
                                return Text("?", style: TextStyle(color: Theme.of(context).primaryColor));
                              }
                            })),
                  ),
                ),
              ),
              (widget.adminMode)
                  ? IconButton(
                      icon: Icon(Icons.dashboard),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPage()));
                      })
                  : Container(
                      height: 0,
                      width: 0,
                    )
            ]),
            body: DatumForm())
        : VerifyUser();
  }
}

class VerifyUser extends StatefulWidget {
  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pwdController = TextEditingController();

  bool _reveal = false;
  bool _incorrectPwd = false;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
        body: Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(top: 90, right: 10, left: 10, bottom: 16),
        children: <Widget>[
          Text("Verify it's you", style: TextStyle(fontSize: 25)),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: TextFormField(
              controller: _pwdController,
              validator: (val) {
                return (val.length < 1) ? "Please choose a password" : null;
              },
              obscureText: (_reveal) ? false : true,
              decoration: InputDecoration(
                  labelText: "Password",
                  suffix: GestureDetector(
                      child: Text((_reveal) ? "Conceal" : "Reveal"),
                      onTap: () {
                        setState(() {
                          _reveal = !_reveal;
                        });
                      }),
                  border: OutlineInputBorder()),
            ),
          ),
          (_incorrectPwd)
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Sorry, your password is incorrect",
                      style: TextStyle(color: Colors.red)),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
          Align(
              alignment: Alignment.topLeft,
              child: RaisedButton(
                  child: Text("Verify"),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
//                      print("pressed");
                      if (Global.pwd == _pwdController.text) {
                        print("true");
                        setState(() {
                          _incorrectPwd = false;
                        });
                        state.setAuthState(true);
                      } else {
                        print("false");
                        setState(() {
                          _incorrectPwd = true;
                        });
//                        state.setAuthState(false);
                      }
                    }
                  }))
        ],
      ),
    ));
  }
}
