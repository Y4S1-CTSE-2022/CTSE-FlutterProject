import 'dart:async';
import 'dart:io';
import 'package:epic_games/models/Category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../util/constants.dart';
import 'AdminMenueHome.dart';

class AddCategory extends StatefulWidget {

  @override
  _AddCategoryState createState() => new _AddCategoryState();
}


class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final _catNameController = TextEditingController();
  ProgressDialog pr;

  var timestamp = DateTime.now().microsecondsSinceEpoch;

  var _firebaseRef = FirebaseDatabase().reference().child("Categories");

  Future addCategory() async {
    try {
      _firebaseRef.push().set({
        "id": timestamp,
        "category": _catNameController.text
      });

      Fluttertoast.showToast(msg:'Category Added Successfully');
      pr.hide();
      clearData();

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (c) => AdminHome()),
      //         (route) => false);

    } on FirebaseAuthException catch (e) {
      pr.hide();
      Fluttertoast.showToast(msg: e.message);

    } catch (e) {
      pr.hide();
      print(e);
      Fluttertoast.showToast(msg:'Something went wrong');
    }
  }

  void clearData() {
    _catNameController.clear();
  }

  @override
  void initState() {
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
          title: Text("ADD CATEGORY",
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
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Category Name",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _catNameController,
                            cursorColor: primaryColor,
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
                                return 'Please enter the name of the game';
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
                                  addCategory();
                                }
                              },
                              child: Text(
                                "Add Category",
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

