import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static int local = 0;
  static int synced = 0;

  static SharedPreferences prefs;
  setPref() async {
    prefs = await SharedPreferences.getInstance();
    local = (getLocal() == null) ? 0 : getLocal();
    synced = (getSynced() == null) ? 0 : getSynced();
  }

  int getLocal() {
    return prefs.getInt('local');
  }

  int getSynced() {
    return prefs.getInt('synced');
  }

  static TextEditingController areaController =
      TextEditingController(text: areas[0]);
  static int selectedArea = 0;
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
