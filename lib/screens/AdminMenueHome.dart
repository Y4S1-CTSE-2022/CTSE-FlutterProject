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
import 'ViewGames.dart';
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
                toolbarHeight: 100,
                backgroundColor: primaryColor,
                title: Text("Admin Menu",
                    style: TextStyle(
                        color: accentColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 25)),
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
            body: Container(
              margin: const EdgeInsets.all(10),
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: accentColor,
                            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => AddGameList()),
                                    (route) => false);
                          },
                          child: Text("Add Game",
                            style: TextStyle(
                              color: textColorDark,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: accentColor,
                            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => ViewGames()),
                                    (route) => false);
                          },
                          child: Text("Games List",
                            style: TextStyle(
                              color: textColorDark,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: accentColor,
                            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => AddCategoryList()),
                                    (route) => false);
                          },
                          child: Text("Add Category",
                            style: TextStyle(
                              color: textColorDark,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: accentColor,
                            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => CategoryList()),
                                    (route) => false);
                          },
                          child: Text("Category List",
                            style: TextStyle(
                              color: textColorDark,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: accentColor,
                            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => UserListView()),
                                    (route) => false);
                          },
                          child: Text("User List",
                            style: TextStyle(
                              color: textColorDark,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),),
                        ),
                      ),
                    ),
                  ],
              ),
            )
          // Center(child: Column(children: <Widget>[
            //
            //
            //   Container(
            //     margin: EdgeInsets.all(5),
            //   ),
            //
            //   Container(
            //     margin: EdgeInsets.all(5),
            //
            //
            //     child: FlatButton(
            //       minWidth: 300,
            //       height: 50,
            //       child: Text('USER LIST', style: TextStyle(fontSize: 17.0),),
            //       color: Colors.blueAccent,
            //       textColor: Colors.white,
            //       onPressed: () {
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(builder: (c) =>UserListView()),
            //                 (route) => false);
            //
            //       },
            //     ),
            //   ),
            //
            //
            //   Container(
            //
            //     margin: EdgeInsets.all(5),
            //
            //
            //     child: FlatButton(
            //       minWidth: 300,
            //       height: 50,
            //       child: Text('ADD GAMES', style: TextStyle(fontSize: 17.0),),
            //       color: Colors.blueAccent,
            //       textColor: Colors.white,
            //       onPressed: () {
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(builder: (c) =>AddGameList()),
            //                 (route) => false);
            //
            //       },
            //     ),
            //   ),
            //
            //   Container(
            //     margin: EdgeInsets.all(5),
            //     child: FlatButton(
            //       minWidth: 300,
            //       height: 50,
            //       child: Text('VIEW GAMES', style: TextStyle(fontSize: 17.0),),
            //       color: Colors.blueAccent,
            //       textColor: Colors.white,
            //       onPressed: () {
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(builder: (c) => ViewGames()),
            //                 (route) => false);
            //       },
            //     ),
            //   ),
            //
            //   Container(
            //     margin: EdgeInsets.all(5),
            //     child: FlatButton(
            //       minWidth: 300,
            //       height: 50,
            //       child: Text('ADD CATEGORIES', style: TextStyle(fontSize: 17.0),),
            //       color: Colors.blueAccent,
            //       textColor: Colors.white,
            //       onPressed: () {
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(builder: (c) =>AddCategoryList()),
            //                 (route) => false);
            //       },
            //     ),
            //   ),
            //
            //   Container(
            //     margin: EdgeInsets.all(5),
            //     child: FlatButton(
            //       minWidth: 300,
            //       height: 50,
            //       child: Text('VIEW CATEGORIES', style: TextStyle(fontSize: 17.0),),
            //       color: Colors.blueAccent,
            //       textColor: Colors.white,
            //       onPressed: () {
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(builder: (c) => CategoryList()),
            //                 (route) => false);
            //       },
            //     ),
            //   ),
            //
            //
            //
            //
            // ]
            // )
            // )
        ),
        onWillPop: onWillPop
    );
  }
}