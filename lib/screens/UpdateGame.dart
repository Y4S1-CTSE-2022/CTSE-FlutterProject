import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'ViewGames.dart';
import '../models/Game.dart';
import '../util/constants.dart';

class UpdateGame extends StatefulWidget {
  // Game game = new Game("MDrjkhksdahkdakhakdkad", "sssssq", "Puzzle", "http://fggg.com", 2012, "hgsadsgd", "1649315579675274.png", 0);
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
  var _selectedCategory = 'Select';
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
    _selectedCategory = widget.game.category;
    rate = widget.game.rate;
  }

  Future update() async {

    _firebaseRef.child("-N-2kSzah2OIHkGWyQhP").update({
      "category": _selectedCategory,
      "name": _nameController.text,
      "year": int.parse(_yearController.text),
      "description": _descriptionController.text,
      "video_url": _videoLinkController.text,
      "rating": rate,
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => ViewGames()),
            (route) => false);


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
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 25)),
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
                                    _firebaseRef.child("-N-2kSzah2OIHkGWyQhP").set(null);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (c) => ViewGames()),
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
                                  color: textColorLight,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _nameController,
                            cursorColor: textColorLight,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Game",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: accentColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              contentPadding:EdgeInsets.all(15.0),
                            ),
                            style: TextStyle(
                                color: textColorLight,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 18
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
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: adminCColor,
                                  width: 2,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              fillColor: textColorLight,
                              contentPadding:EdgeInsets.all(15.0),
                            ),
                            value: _selectedCategory,
                            items: <String>['Select', 'Action', 'Multiplayer', 'Puzzle', 'Racing']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newVal) {
                              setState(() {
                                _selectedCategory = newVal;
                              });
                            },
                            style: TextStyle(
                                fontSize: size.height*0.023,
                                color: textColorLight
                            ),
                            dropdownColor: textColorDark,
                            validator: (value) {
                              if (value == 'Select') {
                                return 'Please select a category';
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
                                  color: textColorLight,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _yearController,
                            keyboardType: TextInputType.text,
                            cursorColor: textColorLight,
                            decoration: InputDecoration(
                              hintText: "Year",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: accentColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              contentPadding:EdgeInsets.all(15.0),
                            ),
                            style: TextStyle(
                                color: textColorLight,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 18
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
                                  color: textColorLight,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _videoLinkController,
                            cursorColor: textColorLight,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              hintText: "Url",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: accentColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              contentPadding:EdgeInsets.all(15.0),
                            ),
                            style: TextStyle(
                                color: textColorLight,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 18
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
                                  color: textColorLight,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18))
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            cursorColor: textColorLight,
                            decoration: InputDecoration(
                              hintText: "Description",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: adminCColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: accentColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              contentPadding:EdgeInsets.all(15.0),
                            ),
                            style: TextStyle(
                                color: textColorLight,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 18
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Description can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Container(
                        //     margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                        //     width: size.width*0.9,
                        //     child:  Text("Rating",
                        //         style: TextStyle(
                        //             color: accentColor,
                        //             fontSize: size.height*0.02)
                        //     )
                        // ),
                        // Container(
                        //   child: RatingBar.builder(
                        //     initialRating: rate,
                        //     minRating: 1,
                        //     direction: Axis.horizontal,
                        //     allowHalfRating: true,
                        //     itemCount: 5,
                        //     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        //     itemBuilder: (context, _) => Icon(
                        //       Icons.star,
                        //       color: Colors.amber,
                        //     ),
                        //     onRatingUpdate: (rating) {
                        //       print(rating);
                        //       rate = rating;
                        //     },
                        //   ),
                        // ),
                        Container(height: size.height*0.02 ),
                        Container(
                          width: size.width*0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: accentColor,
                                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                              ),
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
                              child: Text("Update Game",
                                style: TextStyle(
                                  color: textColorDark,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),),
                            ),
                          ),
                        ),
                        Container(height: size.height*0.03 )
                      ],
                    ),
                  ),
                ),
            )
        )
    );

  }
}

