import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:epic_games/models/Category.dart';
import 'package:epic_games/screens/ViewGames.dart';
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

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddGameList extends StatefulWidget {

  @override
  _AddGameListState createState() => new _AddGameListState();
}


class _AddGameListState extends State<AddGameList> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = 0;
  ProgressDialog pr;

  Category category;
  List<Category> categoryList = [];
  var _selectedCategory = 'Select';

  var path = null;
  var filename = 'No file selected';
  var _selectedCategoryId = null;
  var timestamp = DateTime.now().microsecondsSinceEpoch;

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final _firebaseRef = FirebaseDatabase().reference().child("Games");
  final _dbCategories = FirebaseDatabase().reference().child("Categories");

  Future loadCategories() async {
    print(categoryList.length);
    _dbCategories.once().then((DatabaseEvent databaseEvent) {
      Map<dynamic, dynamic> categories = databaseEvent.snapshot.value;

      // categories.forEach((key, value) {
      //   Category category = Category.fromJson(value);
      //   categoryList.add(category);
      // });
    });
  }

  Future addGametoDB() async {
    if (path != null) {
      uploadFile(filename, path);
    }

    // categoryList.forEach((element) {
    //   if (element.categoryName == _selectedCategory) {
    //     return _selectedCategoryId = element.id;
    //   }
    // });

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      if (_selectedCategory != 'Select') {
          _firebaseRef.push().set({
            "name": _nameController.text,
            "video_url": _videoUrlController.text,
            "category": _selectedCategory,
            "id": user.uid + timestamp.toString(),
            "image":filename,
            "description":_descriptionController.text,
            "year":_yearController.text,
            "rating": _ratingController
          });

          Fluttertoast.showToast(msg:'Added Successfully',backgroundColor: Colors.grey,textColor: Colors.black);
          pr.hide();

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => ViewGames()),
                  (route) => false);
      }

    } on FirebaseAuthException catch (e) {
      pr.hide();
      Fluttertoast.showToast(msg: e.message, backgroundColor: Colors.grey,textColor: Colors.black);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => ViewGames()),
              (route) => false);

    } catch (e) {
      pr.hide();
      print(e);
      Fluttertoast.showToast(msg:'Something went wrong', backgroundColor: Colors.grey,textColor: Colors.black);
    }
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
      Fluttertoast.showToast(msg: result.files.single.name, backgroundColor: Colors.grey,textColor: Colors.black);
    }

    path = result.files.single.path;
    filename = timestamp.toString() + "." + result.files.single.extension;
  }

  Future uploadFile(filename, path) async {
    File file = File(path);

    try {
      await storage.ref('games_img/$filename').putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: 'Something went wrong', backgroundColor: Colors.grey,textColor: Colors.black);
    }
  }

  void clearData() {
    _nameController.clear();
    _nameController.clear();
    _videoUrlController.clear();
    _categoryController.clear();
    _yearController.clear();
    _descriptionController.clear();
    _selectedCategory = 'Select';
    _selectedCategoryId = null;
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
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
          toolbarHeight: size.height*0.11,
          backgroundColor: primaryColor,
          title: Text("ADD GAME",
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
                                return 'Please enter the name of the game';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Category",
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
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Video_url",
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
                            controller: _videoUrlController,
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
                                return 'Please enter a video url';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
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
                            keyboardType: TextInputType.number,
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
                                return 'Please enter year';
                              } if (value.length < 4){
                                return 'Please enter a correct year';
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
                                return 'Please add a description';
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: primaryColorDark,
                                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                              ),
                              onPressed: () => {
                                selectFile()
                              },
                              child: Text("Upload image",
                                style: TextStyle(
                                  color: textColorLight,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),),
                            ),
                          )),
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
                                  addGametoDB();
                                }
                              },
                              child: Text("Add Game",
                                style: TextStyle(
                                  color: textColorDark,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),),
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
