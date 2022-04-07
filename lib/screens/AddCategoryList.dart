import 'dart:async';
import 'dart:io';
import 'package:epic_games/screens/AdminHome.dart';
import 'package:epic_games/screens/Categories.dart';
import 'package:epic_games/screens/CategoryList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../util/constants.dart';
import 'AdminMenueHome.dart';

class AddCategoryList extends StatefulWidget {

  @override
  _AddCategoryListState createState() => new _AddCategoryListState();
}


class _AddCategoryListState extends State<AddCategoryList> {
  DateTime currentBackPressTime;
  int popped = 0;
  final _formKey = GlobalKey<FormState>();
  final _newCategoryController = TextEditingController();
  final _discriptioController = TextEditingController();

  ProgressDialog pr;

  var _firebaseRef = FirebaseDatabase().reference();

  Future addNewCategory() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      _firebaseRef.child("CategoryList").push().set({
        "categoryname": _newCategoryController.text,
        "description":_discriptioController.text,
      });

      Fluttertoast.showToast(msg:'Added Successfully');
      pr.hide();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => CategoryList()),
              (route) => false);

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
            title: Text("ADD CATEGORIES  ",
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


                        Container(

                            margin: const EdgeInsets.fromLTRB(0.0,20,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("New Category",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _newCategoryController,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: "Action ",
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
                                return 'Category name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
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
                            controller: _discriptioController,

                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Description",
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
                                return 'Description can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Container(
                        //     margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                        //     width: size.width*0.9,
                        //     child:  Text("Image",
                        //         style: TextStyle(
                        //             color: accentColor,
                        //             fontSize: size.height*0.02)
                        //     )
                        // ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                        //   width: size.width * 0.9,
                        //   child: TextFormField(
                        //     controller: _imageController,
                        //
                        //     cursorColor: primaryColor,
                        //     keyboardType: TextInputType.multiline,
                        //     decoration: InputDecoration(
                        //       hintText: "Description",
                        //       hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(5)),
                        //         borderSide: BorderSide.none,
                        //       ),
                        //       filled: true,
                        //       contentPadding:EdgeInsets.all(15.0),
                        //       fillColor:textFieldColor,
                        //     ),
                        //     style: TextStyle(
                        //         fontSize: size.height*0.023
                        //     ),
                        //     validator: (value) {
                        //       if (value.isEmpty) {
                        //         return 'Image can\'t be empty';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
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
                                  addNewCategory();
                                }
                              },
                              child: Text(
                                "Add New Category",
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

