import 'package:flutter/material.dart';

class YeniSayfa extends StatelessWidget {
  const YeniSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sayfam")),
      body: Center(
        child: Text("Giriş Onaylandı"),
      ),
    );
  }
}
