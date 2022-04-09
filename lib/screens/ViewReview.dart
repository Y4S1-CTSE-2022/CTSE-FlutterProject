import 'package:epic_games/models/Category.dart';
import 'package:epic_games/models/Game.dart';
import 'package:epic_games/models/Review.dart';
import 'package:epic_games/screens/AdminMenueHome.dart';
import 'package:epic_games/screens/UpdateReview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'UpdateCategory.dart';
import 'UpdateGame.dart';
import '../util/constants.dart';

class ViewReview extends StatefulWidget {

  @override
  _ViewReviewState createState() => new _ViewReviewState();
}


class _ViewReviewState extends State<ViewReview> {
  var _firebaseRef = FirebaseDatabase().reference().child("Review");

  double rate = 0;
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
                title: Text("Reviews",
                    style: TextStyle(
                        color: accentColor,
                        fontSize: size.height*0.03)
                ),

                //back button
                leading: new IconButton(
                    icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
                    onPressed: () =>    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => AdminMenueHome()),
                            (route) => false)
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
                  child: StreamBuilder(
                    stream: _firebaseRef.onValue,
                    builder: (context, snap) {
                      if (snap.hasData && !snap.hasError && snap.data != null && snap.data.snapshot.value as Map != null ) {
                        //assign fetched data to map
                        Map data = snap.data.snapshot.value;
                        List item = [];
                        //add data to the list
                        data.forEach((index, data) => {
                          item.add({"id": index,"review": data['review'], "rating": data['rating']})
                        });
                        //create a list view
                        return ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (context, index) {
                            if(item[index] != null){
                              return Container(
                                margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                                child: Card(
                                    color: adminCColor,
                                    elevation: 10,
                                    child:GestureDetector(
                                      onTap: (){
                                        Review review = new Review(item[index]['id'], item[index]['review'], double.parse(item[index]['rating'].toString()));
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext context) {
                                              return UpdateReview(review:review);
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
                                                    shadowColor: Colors.black12,
                                                    color: accentColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Container(
                                                      // child: ClipRRect(
                                                      //   borderRadius: BorderRadius.circular(30),
                                                      //   child: Image.network(item[index]["assets/Runner-Games.jpg"], fit: BoxFit.cover),
                                                      // ),
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
                                                    alignment: Alignment.centerLeft,
                                                    child: RatingBar.builder(
                                                      initialRating: item[index]['rating'].toDouble(),
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder: (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      itemSize: 20,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: size.width*0.15,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(item[index]['review'],
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: size.width*0.035,
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ),
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
                          child: Text('empty values'),
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