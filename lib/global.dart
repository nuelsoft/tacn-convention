import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static int local = 0;

  static String username;
  static String pwd;

//  static bool authenticated = false;

  static SharedPreferences prefs;
  setPref() async {
    prefs = await SharedPreferences.getInstance();
    local = (getLocal() == null) ? 0 : getLocal();
  }

  int getLocal() {
    return prefs.getInt('local');
  }

  Stream<String> getUser() async* {
    while (true) {
      username = prefs.getString("username");
      pwd = prefs.getString("pwd");
      await Future.delayed(Duration(seconds: 1));

      yield username;
    }
  }


  Future setUser(String username, String pwd) async {
    await prefs.setString("username", username);
    await prefs.setString("pwd", pwd);
  }


  static TextEditingController areaController =
      TextEditingController(text: areas[0]);
  static TextEditingController titleController =
      TextEditingController(text: titles[0]);

  static int selectedArea = 0;
  static int selectedTitle = 0;
  static int selectedGender = 0;
  static List<String> titles = [
    "Pastor",
    "Apostle",
    "Elder",
    "Deacon",
    "Deaconess",
    "Mister",
    "Mistress"
  ];
  static List<String> areas = [
    "Aba",
    "Abakiliki",
    "Abakpa-Nike",
    "Abiriba",
    "Amasiri",
    "Amumara",
    "Arochukwu",
    "Attah",
    "Bende",
    "Chokoneze",
    "Edda",
    "Ehere",
    "Ehe Amufu",
    "Enugu",
    "Eziukwu Aba",
    "Ibere",
    "Ikwuano",
    "Isikwuato",
    "Lorji",
    "Ngor-Okpala",
    "New Owerri",
    "Obowo",
    "Ogbor Hill",
    "Ogwashi-Uku",
    "Ohafia",
    "Okigwe",
    "Okpoko",
    "Oloko",
    "Olokoro",
    "Onicha",
    "Onitsha",
    "Orlu",
    "Ossissa",
    "Oru",
    "Owerri",
    "Oyigbo",
    "Ubakala",
    "Umuahia",
    "Umuegbu",
    "Umuosi",
    "Umuzombgbo"
  ];
}
