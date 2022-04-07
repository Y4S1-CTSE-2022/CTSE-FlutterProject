import 'dart:async';
import 'package:epic_games/screens/Categories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../util/constants.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => new _RegisterState();
}


class _RegisterState extends State<Register> {
  DateTime currentBackPressTime;
  int popped = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  ProgressDialog pr;
  var _firebaseRef = FirebaseDatabase().reference().child('Games').child("Users");

  Future register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      _firebaseRef.child(user.uid).set({
        "name": _nameController.text,
        "email": _emailController.text,
        "contact": _contactController.text,
        "id": user.uid,
      });
      Fluttertoast.showToast(msg:'Registered Successfully');
      pr.hide();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => Categories()),
              (route) => false);
    } on FirebaseAuthException catch (e) {
      pr.hide();
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg:'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg:'The account already exists for that email.');
      }
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
            title: Text("Registration",
                style: TextStyle(
                    color: accentColor,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 25)),
            centerTitle: true,
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
                          child: Image.asset('assets/splash.gif'),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Full Name",
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
                              hintText: "Full Name",
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
                                return 'Full name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Contact No.",
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Contact No",
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
                                return 'Contact No can\'t be empty';
                              } else if (value.length != 10) {
                                return 'Contact No should be valid. Please enter 01 digit contact No.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Email",
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email",
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
                                return 'Email can\'t be empty';
                              } else if (!value.isValidEmail()) {
                                return 'Email should be valid';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Password",
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
                            obscureText: true,
                            controller: _passwordController,
                            cursorColor: textColorLight,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Password",
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
                                return 'Password can\'t be empty';
                              }if(value.length < 6){
                                return 'Password length should more than 6';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Confirm Password",
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
                            controller: _confirmPasswordController,
                            obscureText: true,
                            cursorColor: textColorLight,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
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
                                return 'Confirm Password can\'t be empty';
                              }else if(value != _passwordController.text){
                                return 'Passwords does not match';
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
                                  register();
                                }
                              },
                              child: Text(
                                "Sign Up",
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

