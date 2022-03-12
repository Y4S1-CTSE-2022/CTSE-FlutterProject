import 'dart:async';

import 'package:epic_games/screens/Categories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'AdminHome.dart';
import 'GameList.dart';
import 'Login.dart';
import '../util/constants.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  startTime() async {
    var _duration = new Duration(seconds:10);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    if (user == null) {
      //navigate to login screen
      Navigator.of(context).pop();
      Navigator
          .of(context)
          .push(
          MaterialPageRoute(
              builder: (BuildContext context) => Login()
          )
      );
    } else {
      if(user.email == "admin@gmail.com"){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => AdminHome()),
                (route) => false);
      }else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Categories()),
                (route) => false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
        onWillPop: () async {
          return Navigator.canPop(context);
        },
        child: Scaffold(
            backgroundColor: primaryColor,
            body: Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: size.width,
                    child: Image.asset('assets/splash.gif'),
                  ),
                ],
              ),
            )
        )
    );
  }
}
