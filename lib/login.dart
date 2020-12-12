// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:Shrine/signup_screen.dart';
import 'package:Shrine/src/components/rounded_button.dart';
import 'package:Shrine/src/screens/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'colors.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  final String title = 'Sign In & Out';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.0, 120.0, 24.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TyperAnimatedTextKit(
                    speed: Duration(milliseconds: 120),
                    pause: Duration(milliseconds: 4000),
                    text: ['Handong People'],
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 48.0,
                      color: kPrimaryDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '이메일 아이디',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '비밀번호',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RoundedButton(
                    title: '로그인',
                    color: kPrimaryColor,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Image.asset(
        //       'assets/hgu_logo.png',
        //       width: size.width * 0.5,
        //     ),
        //     SizedBox(height: size.height * 0.1),
        //     _OtherProvidersSignInSection(),
        //     _AnonymouslySignInSection(),
        //     FlatButton(
        //       onPressed: () async {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => SignupScreen(),
        //           ),
        //         );
        //       },
        //       color: kPrimaryColor,
        //       child: Text(
        //         '회원가입',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  void _signOut() async {
    await _auth.signOut();
  }
}

// TODO: Add AccentColorOverride (103)

class _AnonymouslySignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnonymouslySignInSectionState();
}

class _AnonymouslySignInSectionState extends State<_AnonymouslySignInSection> {
  bool _success;
  String _userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          alignment: Alignment.center,
          child: SignInButtonBuilder(
            text: "Guest",
            icon: Icons.person_outline,
            backgroundColor: Colors.deepPurple,
            onPressed: () async {
              _signInAnonymously();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: _success == null ? false : true,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success
                      ? 'Successfully signed in, uid: ' + _userID
                      : 'Sign in failed'),
              style: TextStyle(color: Colors.red),
            ),
          ),
        )
      ],
    );
  }

  // Example code of how to sign in anonymously.
  void _signInAnonymously() async {
    try {
      final User user = (await _auth.signInAnonymously()).user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Signed in Anonymously as user ${user.uid}"),
        ),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in Anonymously"),
      ));
    }
  }
}

class _OtherProvidersSignInSection extends StatefulWidget {
  _OtherProvidersSignInSection();

  @override
  State<StatefulWidget> createState() => _OtherProvidersSignInSectionState();
}

class _OtherProvidersSignInSectionState
    extends State<_OtherProvidersSignInSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,
          child: SignInButton(
            Buttons.GoogleDark,
            text: "Google",
            onPressed: () async {
              _signInWithGoogle();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //Example code of how to sign in with Google.
  void _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Sign In ${user.uid} with Google"),
      ));
    } catch (e) {
      print(e);

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: ${e}"),
      ));
    }
  }
}
