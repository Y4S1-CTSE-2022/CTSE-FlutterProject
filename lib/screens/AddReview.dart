import 'dart:async';
import 'package:epic_games/screens/ViewReview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../util/constants.dart';
import 'AdminMenueHome.dart';

class AddReview extends StatefulWidget {
  final String gameId;
  AddReview({Key key, @required this.gameId}) : super(key: key);
  @override
  _AddReviewState createState() => new _AddReviewState();
}


class _AddReviewState extends State<AddReview> {
  DateTime currentBackPressTime;
  int popped = 0;
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double rate = 0;

  ProgressDialog pr;

  var _firebaseRef = FirebaseDatabase().reference();

  Future addNewReview() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      _firebaseRef.child("Review").push().set({
        "gameId": widget.gameId,
        "userId": user.uid,
        "rating": rate.toDouble(),
        "review":_reviewController.text,
      });

      Fluttertoast.showToast(msg:'Added Successfully');
      pr.hide();

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return ViewReview(gameId: widget.gameId);
          }));

    } catch (e) {
      pr.hide();
      print(e);
      Fluttertoast.showToast(msg:'Something Happened');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true);
    return  Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset:false,
        extendBodyBehindAppBar: true,
        appBar:  AppBar(
          elevation: 0,
          toolbarHeight: size.height*0.08,
          backgroundColor: primaryColor,
          title: Text("ADD REVIEWS  ",
              style: TextStyle(
                  color: accentColor,
                  fontSize: size.height*0.03)
          ),
          centerTitle: true,
          //back button
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () =>    Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (c) => AdminMenueHome()),
                      (route) => false)
          ),
        ),


        body:SafeArea(
            child:  Container(
                child:SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(height: size.height*0.02),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                          width: size.width,
                          //Display the logo
                          child: Image.asset('assets/Runner-Games.jpg'),
                        ),
                        Container(height: size.height*0.03 ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Rate",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: RatingBar.builder(
                            initialRating: rate,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: Colors.white10,
                            onRatingUpdate: (rating) {
                              print(rating);
                              rate = rating;
                            },
                            itemSize: 40,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Review",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(height: size.height*0.02 ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _reviewController,

                            cursorColor: primaryColor,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Review",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(15.0),
                              fillColor:textFieldColor,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Review can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),

                        Container(height: size.height*0.02 ),
                        Container(
                          width: size.width*0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                              color: accentColor,
                              onPressed: () async {
                                if (FocusScope.of(context)
                                    .isFirstFocus) {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode());
                                }
                                pr.update(message: "Please wait...");
                                if (_formKey.currentState.validate()) {
                                  await pr.show();
                                  addNewReview();
                                }
                              },
                              child: Text(
                                "Add New Review",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height*0.02),
                              ),
                            ),
                          ),
                        ),
                        Container(height: size.height*0.03 ),

                      ],
                    ),
                  ),
                )
            )
        )
    );

  }

}

