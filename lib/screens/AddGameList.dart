import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../util/constants.dart';
import 'AdminMenueHome.dart';

class AddGameList extends StatefulWidget {

  @override
  _AddGameListState createState() => new _AddGameListState();
}


class _AddGameListState extends State<AddGameList> {
  // DateTime currentBackPressTime;
  // int popped = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = 0;
  var filename = 'No file selected';
  ProgressDialog pr;

  UploadTask task;
  File file;

  var _firebaseRef = FirebaseDatabase().reference().child("Games");

  Future addGametoDB() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      _firebaseRef.push().set({
        "name": _nameController.text,
        "video_url": _videoUrlController.text,
        "category": _categoryController.text,
        "id": user.uid+_nameController.text,
        "image":1233,
        "description":_descriptionController.text,
        "year":_yearController.text,
        "rating": _ratingController
      });

      Fluttertoast.showToast(msg:'Added Successfully');
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
      Fluttertoast.showToast(msg:'Something Happened');
    }
  }

  Future selectFile() async {
    print("HERE");
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']
    );

    if (result == null) return;

    final path = result.files.single.path;
    filename = result.files.single.name;

    print(filename);

    setState(() => file = File(path));
  }

  void clearData() {
    _nameController.clear();
    _nameController.clear();
    _videoUrlController.clear();
    _categoryController.clear();
    _yearController.clear();
    _descriptionController.clear();
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
            title: Text("ADD GAME",
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
                                return 'Game name can\'t be empty';
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Action",
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
                                return 'Category can\'t be empty';
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
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _videoUrlController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              hintText: "http://game.com",
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
                                return 'video_url can\'t be empty';
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
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                hintText: "2022",
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
                                  return 'Year can\'t be empty';
                                }if(value.length < 4){
                                  return 'Year length should more than 4';
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
                            controller: _descriptionController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.multiline,
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
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Image",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: primaryColorDark,
                                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                                  ),
                                  onPressed: () => {
                                    print("FILE"),
                                    selectFile()
                                  },
                                  child: Text("Upload"),
                                )
                              ),

                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    width: size.width * 0.8,
                                    child: Text(
                                      filename,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height*0.02),
                                    ),
                                ),
                              ),
                            ],
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
                                  addGametoDB();
                                }
                              },
                              child: Text(
                                "Add Game",
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

