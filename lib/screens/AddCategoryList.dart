import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:epic_games/screens/AdminHome.dart';
import 'package:epic_games/screens/Categories.dart';
import 'package:epic_games/screens/CategoryList.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../util/constants.dart';
import 'AdminMenueHome.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddCategoryList extends StatefulWidget {

  @override
  _AddCategoryListState createState() => new _AddCategoryListState();
}


class _AddCategoryListState extends State<AddCategoryList> {
  DateTime currentBackPressTime;
  int popped = 0;

  final _formKey = GlobalKey<FormState>();
  final _newCategoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  var timestamp = DateTime.now().microsecondsSinceEpoch;
  var path = null;
  var filename = 'No file selected';

  ProgressDialog pr;

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  var _firebaseRef = FirebaseDatabase().reference().child("Categories");

  Future addNewCategory() async {
    try {
      if (path != null) {
        uploadFile(filename, path);

        if (filename != 'No file selected') {
          _firebaseRef.push().set({
            "category": _newCategoryController.text,
            "description":_descriptionController.text,
            "image":filename,
          });
        }
      }

      Fluttertoast.showToast(msg:'Added Successfully',backgroundColor: Colors.grey,textColor: Colors.black);
      pr.hide();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => CategoryList()),
              (route) => false);

    } catch (e) {
      pr.hide();
      print(e);
      Fluttertoast.showToast(msg:'Something Happened',backgroundColor: Colors.grey,textColor: Colors.black);
    }
  }

  void clearData() {
    _newCategoryController.clear();
    _descriptionController.clear();
    path = null;
    filename = 'No file selected';
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']
    );

    if (result == null) {
      return;
    } else {
      Fluttertoast.showToast(msg: result.files.single.name,backgroundColor: Colors.grey,textColor: Colors.black);
    }

    path = result.files.single.path;
    filename = timestamp.toString() + "." + result.files.single.extension;
  }

  Future uploadFile(filename, path) async {
    File file = File(path);

    try {
      await storage.ref('category_img/$filename').putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: 'Something went wrong',backgroundColor: Colors.grey,textColor: Colors.black);
    }
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
                            margin: const EdgeInsets.fromLTRB(0.0,20,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("New Category",
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
                            controller: _newCategoryController,
                            cursorColor: textColorLight,
                            decoration: InputDecoration(
                              hintText: "Category",
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
                            controller: _descriptionController,
                            cursorColor: textColorLight,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
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
                              // filled: true,
                              contentPadding:EdgeInsets.all(15.0),
                              // fillColor:textFieldColor,
                            ),
                            style: TextStyle(
                                color: textColorLight,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
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
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Image",
                                style: TextStyle(
                                  color: textColorLight,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          width: size.width * 0.9,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColorDark,
                              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                            ),
                            onPressed: () => {
                              selectFile()
                            },
                            child: Text(
                              "Upload image",
                              style: TextStyle(
                                  color: textColorLight,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                            ),
                            ),
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
                                  addNewCategory();
                                }
                              },
                              child: Text(
                                "Add Category",
                                style: TextStyle(
                                    color: textColorDark,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18),
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

