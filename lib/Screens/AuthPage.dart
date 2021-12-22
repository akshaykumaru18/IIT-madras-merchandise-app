import "package:flutter/material.dart";
import 'package:iit_madras_merchandise/Screens/CreateProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = new GoogleSignIn();
  GoogleSignInAccount signedAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff79201B),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: 200, child: Image.asset("assets/Icons/logo.png")),
            Positioned(
              top: 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text("IIT Madras",
                    style: TextStyle(
                        color: Color(0xffD7A74F),
                        fontSize: 30,
                        fontFamily: 'BeVietnamPro')),
              ),
            ),
            Text("Merchandise Store",
                style: TextStyle(
                    color: Color(0xffD7A74F),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather')),
            Positioned(
              bottom: 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 80),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffD7A74F)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                        side: MaterialStateProperty.all(
                            BorderSide(width: 2, color: Colors.white))),
                    onPressed: () async {
                      await googleSignIn.signOut();
                      try {
                        signedAccount = await googleSignIn.signIn();
                        if (signedAccount != null) {
                          print('Authentication Success');
                          print('Signed In from ${signedAccount.email}');
                           GoogleSignInAuthentication gauth = await signedAccount.authentication;
                          final AuthCredential credential = GoogleAuthProvider.credential(
                            accessToken: gauth.accessToken,
                            idToken: gauth.idToken,
                          );
                          UserCredential login = await auth.signInWithCredential(credential);
                          if(login.user != null){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> CreateProfilePage()));
                          }else{
                            await googleSignIn.signOut();
                            await auth.signOut();
                          }
                          //FirebaseUser user = auth.signInWithCredential(new Credential());
                        } else {
                          print('Authentication Failed');
                        }
                      } catch (error) {
                        print(error);
                      }

                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> CreateProfilePage()));
                    },
                    child: Text('Sign In With Google',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
              ),
            ),
            Positioned(
                bottom: 10,
                child: Text("Copyrights Reserved 2021 Flutterathon",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )))
          ],
        ),
      ),
    );
  }
}
