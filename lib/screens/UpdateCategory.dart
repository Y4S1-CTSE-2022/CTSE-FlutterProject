import 'package:cool_alert/cool_alert.dart';
import 'package:epic_games/models/Category.dart';
import 'package:epic_games/screens/CategoryList.dart';
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

class UpdateCategory extends StatefulWidget {
  final Category category;
  UpdateCategory({Key key, @required this.category}) : super(key: key);
  @override
  _UpdateCategoryState createState() => new _UpdateCategoryState();
}


class _UpdateCategoryState extends State<UpdateCategory> {
  final _categorynameController = TextEditingController();
  final _descriptionController = TextEditingController();

  var _firebaseRef = FirebaseDatabase().reference().child('Games').child("CategoryList");

  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categorynameController.text = widget.category.categoryName;
    _descriptionController.text = widget.category.description;
  }

  Future update() async {

    _firebaseRef.child(widget.category.id).update({
      "categoryname": _categorynameController.text,
      "description": _descriptionController.text,

    });
    Fluttertoast.showToast(msg:'CategoryList Updated Successfully');
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
            title: Text("CategoryList Update",
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
                                    _firebaseRef.child(widget.category.id).set(null);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (c) => CategoryList()),
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
                            child:  Text("Name of the Category",
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _categorynameController,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: "Category name",
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
                                "Update Category",
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

