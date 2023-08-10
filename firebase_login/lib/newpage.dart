import 'package:firebase_login/main.dart';
import 'package:firebase_login/providers/veriler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YeniSayfa extends StatelessWidget {
  const YeniSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sayfam")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Giriş Onaylandı\n"),
            Text("İsim : ${Provider.of<veriler>(context).ad} , Soyisim : ${Provider.of<veriler>(context).soyad} , email : ${Provider.of<veriler>(context).mail} "),
            ElevatedButton(
              onPressed: () async {
                final preferences = await SharedPreferences.getInstance();

                preferences.clear();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyhomePage(),
                    ));
              },
              child: Text("Hesaptan çıkış yap"),
            )
          ],
        ),
      ),
    );
  }
}
