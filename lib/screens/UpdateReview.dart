import 'package:cool_alert/cool_alert.dart';
import 'package:epic_games/models/Review.dart';
import 'package:epic_games/screens/Categories.dart';
import 'package:epic_games/screens/CategoryList.dart';
import 'package:epic_games/screens/GameDetail.dart';
import 'package:epic_games/screens/ViewReview.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'AdminHome.dart';
import '../models/Game.dart';
import '../util/constants.dart';

class UpdateReview extends StatefulWidget {
  final Review review;
  UpdateReview({Key key, @required this.review}) : super(key: key);
  @override
  _UpdateReviewState createState() => new _UpdateReviewState();
}


class _UpdateReviewState extends State<UpdateReview> {
  final _reviewController = TextEditingController();
  double rate = 0;

  var _firebaseRef = FirebaseDatabase().reference().child("Review");

  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reviewController.text = widget.review.review;
    rate = widget.review.rating;
  }

  Future update() async {

    _firebaseRef.child(widget.review.id).update({
      "rating": rate.toDouble(),
      "review": _reviewController.text,
    });
    Fluttertoast.showToast(msg:'Review Updated Successfully');
    pr.hide();

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) {
    //       return ViewReview(gameId: widget.review.gameId, userId: widget.review.userId);
    //     }));
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (c) => ViewReview(gameId: widget.review.gameId, userId: widget.review.userId)),
    //         (route) => false);
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
          title: Text("Review Update",
              style: TextStyle(
                  color: accentColor,
                  fontSize: size.height*0.03)
          ),
          centerTitle: true,
        ),
        body:SafeArea(
            child:  Container(
              height: size.height*0.92,
              width: size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(height: size.height*0.03),
                      Container(
                        width: size.width*0.9,
                        height: size.height*0.05,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                text: "Do you want to delete this review?",
                                confirmBtnText: "Yes",
                                onConfirmBtnTap: (){
                                  _firebaseRef.child(widget.review.id).set(null);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (c) => ViewReview()),
                                          (route) => false);
                                },
                                cancelBtnText: "No",
                                confirmBtnColor: Colors.red,
                                backgroundColor: primaryColor
                            );
                          },
                          child: Icon(
                            Icons.delete_outline,
                            size: size.height*0.05,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Container(height: size.height*0.02 ),
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
                      Container(height: size.height*0.02 ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                          width: size.width*0.9,
                          child:  Text("Review",
                              style: TextStyle(
                                  color: accentColor,
                                  fontSize: size.height*0.02)
                          )
                      ),
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
                              // width: 0.0 produces a thin "hairline" border
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none,
                              //borderSide: const BorderSide(),
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
                                await update();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return Categories();
                                    }));
                              }
                            },
                            child: Text(
                              "Update Review",
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
              ),
            )
        )
    );

  }
}

