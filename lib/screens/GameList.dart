import 'dart:io';

import 'package:epic_games/models/Game.dart';
import 'package:epic_games/screens/GameDetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import '../util/constants.dart';

class GameList extends StatefulWidget {
  final String category;
  GameList({Key key, @required this.category}) : super(key: key);
  @override
  _GameListState createState() => new _GameListState();
}


class _GameListState extends State<GameList> {
  var _firebaseRef = FirebaseDatabase().reference().child('Games');
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
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
        ),
        body:SafeArea(
            child:  Container(
              height: size.height*0.92,
              child: StreamBuilder(
                stream: _firebaseRef.orderByChild("category").equalTo(widget.category).onValue,
                builder: (context, snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null && snap.data.snapshot.value != null) {
                    //assign fetched data to map
                    Map data = snap.data.snapshot.value;

                    List item = [];
                    //add data to the list
                    data.forEach((index, data) => item.add({"id": index, "name": data['name'],"category": data['category'],"video_url": data['video_url'],"year": data['year'],"description": data['description'],"image": data['image'],"rate": data['rate']}));
                    //create a list view
                    return ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                            child: Card(
                                color: Colors.white,
                                elevation: 10,
                                child:GestureDetector(
                                  onTap: (){
                                    Game game = new Game(item[index]['id'], item[index]['name'], item[index]['category'], item[index]['video_url'], item[index]['year'], item[index]['description'], item[index]['image'], double.parse(item[index]['rate'].toString()));
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return GameDetail(game:game);
                                        }));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: size.width*0.2,
                                          child: Container(
                                            width: size.width*0.3,
                                            height: size.width*0.3,
                                            child: Card(
                                                elevation: 20,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                                child: Container(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.network(item[index]['image'], fit: BoxFit.cover),
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: size.width*0.8-70,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: size.width*0.07,
                                                alignment: Alignment.centerLeft,
                                                child: Text(item[index]['name'],
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontSize: size.width*0.06,
                                                    )
                                                ),
                                              ),
                                              Container(
                                                height: size.width*0.15,
                                                alignment: Alignment.centerLeft,
                                                child: Text(item[index]['description'],
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: size.width*0.035,
                                                    )
                                                ),
                                              ),
                                              Container(
                                                height: size.width*0.05,
                                                alignment: Alignment.topRight,
                                                child: Text(item[index]['category'],
                                                    style: TextStyle(
                                                      color: accentColor,
                                                      fontSize: size.width*0.035,
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          );
                      },
                    );
                  }
                  else
                    return Container(
                      color: primaryColor,
                      child: Text("Empty List",textAlign:TextAlign.center,style: TextStyle(fontSize: 25,color: Colors.white)),


                    );
                },
              ),
            )
        )
    );
  }
}

