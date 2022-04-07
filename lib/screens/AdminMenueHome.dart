import 'package:epic_games/models/Game.dart';
import 'package:epic_games/screens/AddCategoryList.dart';
import 'package:epic_games/screens/CategoryList.dart';
import 'package:epic_games/screens/GameDetail.dart';
import 'package:epic_games/screens/UserListView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'AddGameList.dart';
import 'AdminHome.dart';
import 'Login.dart';
import 'UpdateGame.dart';
import '../util/constants.dart';

class AdminMenueHome extends StatefulWidget {

  @override
  _AdminMenueHomeState createState() => new _AdminMenueHomeState();
}


class _AdminMenueHomeState extends State<AdminMenueHome> {
  var _firebaseRef = FirebaseDatabase().reference().child('Games');
  DateTime firstPress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (firstPress == null ||
        now.difference(firstPress) > Duration(seconds: 2)) {
      firstPress = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  WillPopScope(
        child: Scaffold(
            backgroundColor: primaryColor,
            resizeToAvoidBottomInset:false,
            extendBodyBehindAppBar: true,
            appBar:  AppBar(
                elevation: 0,
                toolbarHeight: size.height*0.08,
                backgroundColor: primaryColor,
                title: Text("Admin Menu Home",
                    style: TextStyle(
                        color: accentColor,
                        fontSize: size.height*0.03)
                ),
                centerTitle: true,
                actions: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right:5.0),
                    child: IconButton(
                      icon:Icon(
                        Icons.logout,
                        size: size.width*0.06,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => Login()),
                                (route) => false);
                      },
                    ),
                  )
                ]
            ),
            body: Center(child: Column(children: <Widget>[


              Container(
                margin: EdgeInsets.all(80),
              ),

              Container(

                margin: EdgeInsets.all(5),


                child: FlatButton(
                  minWidth: 300,
                  height: 50,
                  child: Text('USER LIST', style: TextStyle(fontSize: 17.0),),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) =>UserListView()),
                            (route) => false);

                  },
                ),
              ),


              Container(

                margin: EdgeInsets.all(5),


                child: FlatButton(
                  minWidth: 300,
                  height: 50,
                  child: Text('ADD GAMES', style: TextStyle(fontSize: 17.0),),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) =>AddGameList()),
                            (route) => false);

                  },
                ),
              ),

              Container(
                margin: EdgeInsets.all(5),
                child: FlatButton(
                  minWidth: 300,
                  height: 50,
                  child: Text('VIEW GAMES', style: TextStyle(fontSize: 17.0),),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) =>AdminHome()),
                            (route) => false);
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.all(5),
                child: FlatButton(
                  minWidth: 300,
                  height: 50,
                  child: Text('ADD CATEGORIES', style: TextStyle(fontSize: 17.0),),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) =>AddCategoryList()),
                            (route) => false);
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.all(5),
                child: FlatButton(
                  minWidth: 300,
                  height: 50,
                  child: Text('VIEW CATEGORIES', style: TextStyle(fontSize: 17.0),),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) =>CategoryList()),
                            (route) => false);
                  },
                ),
              ),




            ]
            )
            )
        ),
        onWillPop: onWillPop
    );
  }
}