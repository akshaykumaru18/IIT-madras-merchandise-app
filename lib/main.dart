import "package:flutter/material.dart";
import 'package:iit_madras_merchandise/Screens/AuthPage.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(IITMadras());
}

class IITMadras extends StatelessWidget {
  const IITMadras({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'BeVietnamPro',
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff79201B))
      ),
      home: AuthPage(),
    );

  }
}

