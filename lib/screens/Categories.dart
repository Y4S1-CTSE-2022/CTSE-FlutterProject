import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'GameList.dart';
import 'Login.dart';
import '../util/constants.dart';

class Categories extends StatefulWidget {

  @override
  _CategoriesState createState() => new _CategoriesState();
}


class _CategoriesState extends State<Categories> {
  DateTime firstPress;
  int _current = 0;
  List categories = [
    {"name":"Action Games","image":"assets/Action-Games.jpg"},
    {"name":"Multiplayer Games","image":"assets/Multiplayer-Games.jpg"},
    {"name":"Puzzle Games","image":"assets/Puzzle-Games.jpg"},
    {"name":"Racing Games","image":"assets/Racing-Games.jpg"},
    {"name":"Runner Games","image":"assets/Runner-Games.jpg"},
  ];
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
      onWillPop: onWillPop,
      child: Scaffold(
          backgroundColor: primaryColor,
          resizeToAvoidBottomInset:false,
          extendBodyBehindAppBar: true,
          appBar:  AppBar(
              elevation: 0,
              toolbarHeight: size.height*0.08,
              backgroundColor: primaryColor,
              title: Text("Categories",
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
          body:SafeArea(
              child:  Container(
                height: size.height*0.92,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('Find Your Favourite' , style: TextStyle(color: Colors.white70, fontSize: 20))),
                    Center(child: Text('Game Categories Down Here !' , style: TextStyle(color: Colors.white60, fontSize: 20))),
                    Center(child: Text('' , style: TextStyle( fontSize: 20))),
                    Center(child: Text('' , style: TextStyle( fontSize: 20))),
                    Center(child: Text('' , style: TextStyle( fontSize: 20))),
                    Container(
                      child: CarouselSlider(
                        options: CarouselOptions(
                            height: size.height*0.5,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            reverse: false,
                            enableInfiniteScroll: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration: Duration(milliseconds: 2000),
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }
                        ),
                        items: categories.map((item) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator
                                      .of(context)
                                      .push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => GameList(category: item['name'])
                                      )
                                  );
                                },
                                child: Container(
                                  height: size.height*0.6,
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child:  Column(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          child:Image.asset(item['image'], fit: BoxFit.cover),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: size.width*0.8,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                            ),
                                            child:Text('${item['name']}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: size.height*0.03,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Container(height: size.height*0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: categories.map((category) {
                        int index = categories.indexOf(category);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color.fromRGBO(255, 255, 255, 0.9)
                                  : Color.fromRGBO(255, 255, 255, 0.4)
                          ),
                        );
                      },
                      ).toList(), // this was the part the I had to add
                    ),
                  ],
                ),
              )
          )
      ),
    );

  }
}