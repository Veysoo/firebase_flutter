import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/newpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('en'),
      supportedLocales: [Locale('en')],
      title: 'Material App',
      home: MyhomePage(),
    );
  }
}

class MyhomePage extends StatefulWidget {
  const MyhomePage({super.key});

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  late FirebaseAuth auth;
  String firstnamee = '', secondnamee = '', emaill = '', passwordd = '';
  late FirebaseFirestore firestore;
  var _myUser;
  CollectionReference users =
      FirebaseFirestore.instance.collection('Kullanıcılar');

  final _formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint("kullanıcı çıktı");
      } else {
        debugPrint("kullanıcı girdi");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.purple,
      ),
      body: homePage(),
    );
  }

  Widget homePage() {
    return Form(
      key: _formState,
      autovalidateMode: AutovalidateMode.always,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple, Colors.blue])),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "isminiz",
                        hintText: "isminizi giriniz",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        icon: Icon(Icons.people)),
                    onSaved: (deger) {
                      firstnamee = deger!;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "soyisim",
                          hintText: "soyisminizi giriniz",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          icon: Icon(Icons.email)),
                      onSaved: (deger) {
                        secondnamee = deger!;
                      }),
                ),
                Expanded(
                  child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Mail adresinizi giriniz",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          icon: Icon(Icons.email)),
                      onSaved: (deger) {
                        emaill = deger!;
                      }),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Şifre",
                        hintText: "Şifrenizi giriniz",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        icon: Icon(Icons.password),
                      ),
                      validator: (value) {
                        if (value!.length > 6) {
                          return "Şifre 6 haneli olmali";
                        } else if (value.length < 6) {
                          return "Şifre 6 haneli olmali";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (deger) {
                        passwordd = deger!;
                      }),
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            bool _validate =
                                _formState.currentState!.validate();
                            if (_validate) {
                              _formState.currentState!.save();
                            }
                            signIn(emaill, passwordd);

                            if (_myUser != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => YeniSayfa()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Böyle bir hesap yok")));
                            }
                          },
                          child: Text(
                            "Giriş yap",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.amberAccent),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              bool _validate =
                                  _formState.currentState!.validate();
                              if (_validate) {
                                _formState.currentState!.save();
                              }
                              logout();
                            },
                            child: Text(
                              "Hesaptan Çıkış yap",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              bool _validate =
                                  _formState.currentState!.validate();
                              if (_validate) {
                                _formState.currentState!.save();
                              }
                              users.add({
                                'email': emaill,
                                'isim': firstnamee,
                                'soyisim': secondnamee
                              });
                              createUser(emaill, passwordd);
                            },
                            child: Text(
                              "Kayıt Ol",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    var _userSign =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    _myUser = _userSign.user;
  }

  void createUser(email, password) async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      debugPrint(_userCredential.toString());

      _myUser = _userCredential.user;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void logout() async {
    await auth.signOut();
  }

  void deleteUser() async {
    await auth.currentUser!.delete();
  }

  void fireStoreVeriEkle(String isim, String soyisim, String email) async {
    Map<String, dynamic> _eklenenveri = <String, dynamic>{
      'email': email,
      'isim': isim,
      'soyisim': soyisim,
    };

    await firestore.collection("users").add(_eklenenveri);
  }
}
