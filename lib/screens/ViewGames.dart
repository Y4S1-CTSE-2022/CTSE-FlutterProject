import 'package:epic_games/models/Game.dart';
import 'package:epic_games/screens/AdminMenueHome.dart';
import 'package:epic_games/screens/GameDetail.dart';
import 'package:epic_games/screens/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Login.dart';
import 'UpdateGame.dart';
import '../util/constants.dart';

class ViewGames extends StatefulWidget {

  @override
  _ViewGamesState createState() => new _ViewGamesState();
}


class _ViewGamesState extends State<ViewGames> {
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
                toolbarHeight: size.height*0.08,
                backgroundColor: primaryColor,
                title: Text("Game List",
                    style: TextStyle(
                        color: accentColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 25)),
                centerTitle: true,
                //back button
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
                  onPressed: () =>    Navigator.of(context).pushAndRemoveUntil(
                     MaterialPageRoute(builder: (c) => AdminMenueHome()),
                         (route) => false)
                ),
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
            body:SafeArea(
                child:  Container(
                  height: size.height*0.92,
                  child: StreamBuilder(
                    stream: _firebaseRef.onValue,
                    builder: (context, snap) {
                      if (snap.hasData && !snap.hasError && snap.data != null && snap.data.snapshot.value as Map != null ) {
                        //assign fetched data to map
                        Map data = snap.data.snapshot.value;
                        List item = [];
                        print(snap.data.snapshot.value);
                        //add data to the list
                        data.forEach((index, data) => item.add({"id": index, "name": data['name'],"category": data['category'],"video_url": data['video_url'],"year": data['year'],"description": data['description'],"image": data['image'],"rating": data['rating']}));
                        //create a list view
                        return ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (context, index) {
                            if(item[index] != null){
                              return Container(
                                margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: primaryColorDark,
                                    elevation: 20,
                                    // child:GestureDetector(
                                    //   onTap: (){
                                    //     Game game = new Game(item[index]['id'], item[index]['name'], item[index]['category'], item[index]['video_url'], item[index]['year'], item[index]['description'], item[index]['image'], double.parse(item[index]['rate'].toString()));
                                    //     Navigator.push(context,
                                    //         MaterialPageRoute(builder: (BuildContext context) {
                                    //           return UpdateGame(game:game);
                                    //         }));
                                    //   },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Container(
                                                width: 150,
                                                height: 250,
                                                child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.black12,
                                                    color: accentColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Container(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: Image.network(item[index]['image'], fit: BoxFit.cover),
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 210,
                                              padding: EdgeInsets.only(left: 10),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: size.width*0.07,
                                                      alignment: Alignment.centerLeft,
                                                      child: Row(
                                                          children:[
                                                            Text(item[index]['name'],
                                                                style: TextStyle(
                                                                    color: textColorLight,
                                                                    fontFamily: 'Nunito',
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 28
                                                                ),
                                                            )
                                                          ]
                                                      )
                                                  ),

                                                  Container(
                                                      height: size.width*0.07,
                                                      margin: EdgeInsets.only(top: 5),
                                                      alignment: Alignment.centerLeft,
                                                      child: Row(
                                                          children:[
                                                            Text(item[index]['year'].toString(),
                                                              style: TextStyle(
                                                                  color: textColorLight,
                                                                  fontFamily: 'Nunito',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 16
                                                              ),
                                                            ),
                                                          ]
                                                      )
                                                  ),
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    margin: EdgeInsets.only(top: 5),
                                                    child: Chip(
                                                      label: Text(item[index]['category'],
                                                        style: TextStyle(
                                                            color: primaryColorDark,
                                                            fontFamily: 'Nunito',
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 12
                                                        ),
                                                      ),
                                                      backgroundColor: textFieldColor,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: size.width*0.15,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(item[index]['description'],
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          color: textFieldColor,
                                                          fontFamily: 'Nunito',
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 16
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    child: RatingBarIndicator(
                                                      rating: item[index]['rating'].toDouble(),
                                                      itemBuilder: (context, index) => Icon(
                                                        Icons.stars_rounded,
                                                        color: accentColor,
                                                      ),
                                                      itemCount: 5,
                                                      itemSize: 25,
                                                      direction: Axis.horizontal,
                                                      itemPadding: EdgeInsets.only(right: 5),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomRight,
                                                    margin: EdgeInsets.only(bottom: 5),
                                                    width: 100,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: accentColor,
                                                        ),
                                                        onPressed: () {
                                                          // Game game = new Game(item[index]['id'], item[index]['name'], item[index]['category'], item[index]['video_url'], item[index]['year'], item[index]['description'], item[index]['image'], double.parse(item[index]['rate'].toString()));
                                                          Navigator.of(context).pushAndRemoveUntil(
                                                              MaterialPageRoute(builder: (c) => UpdateGame()),
                                                                  (route) => false);
                                                          // Navigator.push(context,
                                                          //     MaterialPageRoute(builder: (BuildContext context) {
                                                          //       // return UpdateGame(game:game);
                                                          //       return AdminMenueHome();
                                                          //     }));
                                                        },
                                                        child: Text("Review",
                                                          style: TextStyle(
                                                            color: textColorDark,
                                                            fontFamily: 'Nunito',
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 18,
                                                          ),),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                // ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        );
                      }
                      else
                        return Container(
                          color: primaryColor,
                        );
                    },
                  ),
                )
            )
        ),
        onWillPop: onWillPop
    );
  }
}