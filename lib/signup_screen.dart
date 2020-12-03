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

import 'package:Shrine/src/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'colors.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class SignupScreen extends StatefulWidget {
  final String title = 'Sign In & Out';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();
  final _nameController = TextEditingController();
  String _departmentValue = '국제어문학부';
  String _classValue = '95';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Text('이메일'),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "myname@handong.edu",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
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
                    controller: _passwordController,
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
                    controller: _passwordCheckController,
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
                    controller: _nameController,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text(
                        "회원가입",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: kPrimaryColor,
                      onPressed: () {
                        // _firestore.collection('users').add(

                        // ),
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
