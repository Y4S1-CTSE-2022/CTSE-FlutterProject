import 'package:cool_alert/cool_alert.dart';
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

class UpdateGame extends StatefulWidget {
  final Game game;
  UpdateGame({Key key, @required this.game}) : super(key: key);
  @override
  _UpdateGameState createState() => new _UpdateGameState();
}


class _UpdateGameState extends State<UpdateGame> {
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _videoLinkController = TextEditingController();
  final _categoryController = TextEditingController();
  double rate = 0;
  var _firebaseRef = FirebaseDatabase().reference().child('Games');

  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.game.name;
    _yearController.text = widget.game.year.toString();
    _descriptionController.text = widget.game.description;
    _videoLinkController.text = widget.game.video_url;
    _categoryController.text = widget.game.category;
    rate = widget.game.rate;
  }

  Future update() async {

    _firebaseRef.child(widget.game.id).update({
      "name": _nameController.text,
      "year": int.parse(_yearController.text),
      "description": _descriptionController.text,
      "video_url": _videoLinkController.text,
      "rate": rate,
    });
    Fluttertoast.showToast(msg:'Game Updated Successfully');
    pr.hide();
    Navigator.of(context).pop();
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
            title: Text("Game Update",
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
                                  text: "Do you want to delete this game?",
                                  confirmBtnText: "Yes",
                                  onConfirmBtnTap: (){
                                    _firebaseRef.child(widget.game.id).set(null);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (c) => AdminHome()),
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
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Name of the Game",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _nameController,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: "Name",
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
                                return 'Name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Category",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _categoryController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Category",
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
                                return 'Category can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Year",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _yearController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Year",
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
                                return 'Year can\'t be empty';
                              }else if(value.length != 4){
                                return 'Enter a valid year';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Video Link",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _videoLinkController,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: "Video Link",
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
                                return 'Video Link can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Description",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _descriptionController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Description",
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
                                return 'Description can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Rating",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
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
                            onRatingUpdate: (rating) {
                              print(rating);
                              rate = rating;
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
                                  update();
                                }
                              },
                              child: Text(
                                "Update",
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

