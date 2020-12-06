import 'package:flutter/material.dart';
import 'package:tacn_convention/global.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _pwdController = TextEditingController();

  bool _reveal = false;
  bool _isProcessing = false;

  setUser() async {
    if (_formKey.currentState.validate()) {
//      print("validated");
      await Global()
          .setUser(_nameController.text, _pwdController.text)
          .whenComplete(() {});
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Launch")),
      body: Stack(
        children: <Widget>[
          (_isProcessing)
              ? LinearProgressIndicator()
              : Container(
                  height: 0,
                  width: 0,
                ),
          ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 35, right: 8, left: 8, bottom: 25),
            children: <Widget>[
              Text("Firsts", style: TextStyle(fontSize: 25)),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (val) {
                              return (val.length < 1)
                                  ? "Please enter your name"
                                  : null;
                            },
                            decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            controller: _pwdController,
                            validator: (val) {
                              return (val.length < 1)
                                  ? "Please choose a password"
                                  : null;
                            },
                            obscureText: (_reveal) ? false : true,
                            decoration: InputDecoration(
                                labelText: "Password",
                                suffix: GestureDetector(
                                    child:
                                        Text((_reveal) ? "Conceal" : "Reveal"),
                                    onTap: () {
                                      setState(() {
                                        _reveal = !_reveal;
                                      });
                                    }),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                child: Text("Continue"),
                                onPressed: () {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  setUser();
                                },
                              )),
                        )
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
