import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: (auth.currentUser.isAnonymous)
          ? AnonymousUser(size: size, auth: auth)
          : GoogleUser(size: size, auth: auth),
      //GoogleUser(size: size, auth: auth),
      backgroundColor: Colors.grey,
    );
  }

  void _signOut() async {
    await _auth.signOut();
  }
}

class AnonymousUser extends StatelessWidget {
  const AnonymousUser({
    Key key,
    @required this.size,
    @required this.auth,
  }) : super(key: key);

  final Size size;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/logo.png",
              height: size.height * 0.4,
            ),
            Text(
              auth.currentUser.uid,
              style: TextStyle(color: Colors.white),
            ),
            Divider(
              thickness: 2,
              height: 40,
              color: Colors.white,
            ),
            Text(
              "Anonymous",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleUser extends StatelessWidget {
  const GoogleUser({
    Key key,
    @required this.size,
    @required this.auth,
  }) : super(key: key);

  final Size size;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            auth.currentUser.photoURL != null
                ? Image.network(
                    auth.currentUser.photoURL,
                    height: size.height * 0.4,
                  )
                : Image.asset(
                    "assets/logo.png",
                    height: size.height * 0.4,
                  ),
            Text(
              auth.currentUser.uid,
              style: TextStyle(color: Colors.white),
            ),
            Divider(
              thickness: 2,
              height: 40,
              color: Colors.white,
            ),
            Text(
              auth.currentUser.email,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
