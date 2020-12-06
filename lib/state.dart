import 'package:tacn_convention/global.dart';
import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  AppState();

  static bool authenticated = false;

  void setAuthState(bool b){
    authenticated = b;
    notifyListeners();
  }

  bool getAuthState(){
    return authenticated;
  }

  void incrementLocalCount() async {
    await Global.prefs.setInt('local', getLocalCount() + 1).whenComplete(() {
     
        print("incremented");
        notifyListeners();
        print("notified");
      
    });
  }


  int getLocalCount() {
    print("fetched");
    return (Global().getLocal() == null) ? 0 : Global().getLocal();
  }
}
