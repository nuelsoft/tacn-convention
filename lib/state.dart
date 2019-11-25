import 'package:datum/global.dart';
import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  AppState();

  void incrementLocalCount() async {
    await Global.prefs.setInt('local', getLocalCount() + 1).whenComplete(() {
     
        print("incremented");
        notifyListeners();
        print("notified");
      
    });
  }

  void incrementSyncedCount() async {
    await Global.prefs.setInt('synced', getSyncedCount() + 1).whenComplete((){
          notifyListeners();
    });
  }

  int getLocalCount() {
    print("fetched");
    return (Global().getLocal() == null) ? 0 : Global().getLocal();
  }

  int getSyncedCount() {
    return (Global().getSynced() == null) ? 0 : Global().getSynced();
  }
}
