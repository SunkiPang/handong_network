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

import 'package:Shrine/src/components/rounded_button.dart';
import 'package:Shrine/src/screens/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'colors.dart';
import 'colors.dart';

class SignupScreen extends StatefulWidget {
  final String title = 'Sign In & Out';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  String _email;
  String _password;
  String _passwordCheck;
  String _name;
  String _departmentValue = '국제어문학부';
  String _classValue = '95';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 36.0,
                    ),
                    Text('이메일'),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "id@handong.edu",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('비밀번호'),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "",
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('비밀번호 확인'),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "",
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        _passwordCheck = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('이름'),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "김한동",
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        _name = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('학번'),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: DropdownButton<String>(
                        elevation: 0,
                        value: _classValue,
                        onChanged: (String newValue) {
                          setState(() {
                            _classValue = newValue;
                          });
                        },
                        items: List<String>.generate(
                                26,
                                (int i) => (i + 95) < 100
                                    ? (i + 95).toString()
                                    : (i + 95 - 100).toString().padLeft(2, '0'))
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('학부'),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: DropdownButton<String>(
                        elevation: 0,
                        value: _departmentValue,
                        onChanged: (String newValue) {
                          setState(() {
                            _departmentValue = newValue;
                          });
                        },
                        items: <String>[
                          '글로벌리더십학부',
                          '국제어문학부',
                          '경영경제학부',
                          '법학부',
                          '커뮤니케이션학부',
                          '공간환경시스템공학부',
                          '기계제어공학부',
                          '콘텐츠융합디자인학부',
                          '생명과학부',
                          '전산전자공학부',
                          '상담심리사회복지학부',
                          'ICT창업학부'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RoundedButton(
                      title: '회원가입',
                      color: kPrimaryColor,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                          if (newUser != null) {
                            await _auth.currentUser
                                .updateProfile(displayName: _name);
                            await _firestore
                                .collection('users')
                                .doc(newUser.user.uid)
                                .set({
                              'uid': newUser.user.uid,
                              'email': _email,
                              'password': _password,
                              'name': _name,
                              'department': _departmentValue,
                              'classOf': _classValue,
                            });
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
        ),
      ),
    );
  }
}
