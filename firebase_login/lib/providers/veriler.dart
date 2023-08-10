import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class veriler with ChangeNotifier {
  String? sifree;
  String? mail;
  String? ad;
  String? soyad;

  void storageKontrolu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    mail = preferences.getString("email") ?? "";
    sifree = preferences.getString("sifre") ?? "";
    ad = preferences.getString("isim") ?? "";
    soyad = preferences.getString("soyisim") ?? "";
    notifyListeners();
  }
}
