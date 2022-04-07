import 'package:cool_alert/cool_alert.dart';
import 'package:epic_games/models/Category.dart';
import 'package:epic_games/models/UserList.dart';
import 'package:epic_games/screens/CategoryList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../util/constants.dart';
import 'UserListView.dart';

class UpdateUser extends StatefulWidget {
  final UserList userList;
  UpdateUser({Key key, @required this.userList}) : super(key: key);
  @override
  _UpdateUserState createState() => new _UpdateUserState();
}


class _UpdateUserState extends State<UpdateUser> {
  final _namecontroller = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  var _firebaseRef = FirebaseDatabase().reference().child("Users");

  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namecontroller.text = widget.userList.name;
    _emailController.text = widget.userList.email;
    _contactController.text = widget.userList.contact;


  }

  Future update() async {

    _firebaseRef.child(widget.userList.id).update({
      "name": _namecontroller.text,
      "email": _emailController.text,
      "contact": _contactController.text,
    });
    Fluttertoast.showToast(msg:'User Details Updated Successfully',backgroundColor: Colors.grey,textColor: Colors.black);
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
            toolbarHeight: size.height*0.12,
            backgroundColor: primaryColor,
            title: Text(_namecontroller.text,
                style: TextStyle(
                    color: accentColor,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
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
                                    _firebaseRef.child(widget.userList.id).set(null);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (c) => UserListView()),
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
                              color: accentColor,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Name:",
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
                            controller: _namecontroller,
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
                                return 'Name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Contact:",
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
                            controller: _contactController,
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
                                return 'Contact can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),


                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Email:",
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
                            controller: _emailController,
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
                                return 'email can\'t be empty';
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
                                "Update User",
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
                ),
            )
        )
    );

  }
}

