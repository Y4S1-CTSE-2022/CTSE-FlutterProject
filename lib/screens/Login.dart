

import 'package:epic_games/screens/ViewGames.dart';
import 'package:epic_games/screens/Categories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'AdminMenueHome.dart';
import 'GameList.dart';
import 'Register.dart';
import '../util/constants.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  DateTime currentBackPressTime;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  ProgressDialog pr;


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future authenticateUser(String username, String password) async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username,
          password: password
      );
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      if (user == null) {
        Fluttertoast.showToast(msg:'No user found');
      } else {
          print('User is signed in!');
          Fluttertoast.showToast(msg:'Login Successful');
          pr.hide();
          if(user.email == "admin@gmail.com"){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) =>AdminMenueHome()),
                    (route) => false);
          }else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => Categories()),
                    (route) => false);
          }

      }

    } on FirebaseAuthException catch (e) {
      pr.hide();
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg:'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg:'Wrong password provided for that user.');
      }
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
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: Container(
              width: size.width * 1,
              height: size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                      width: size.width,
                      //Display the logo
                      child: Image.asset('assets/splash.gif'),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: size.width * 0.85,
                        child: TextFormField(
                          cursorColor: primaryColor,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email_outlined,
                                color: accentColor),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
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
                        )
                    ),
                    Container(
                        width: size.width * 0.85,
                        child: TextFormField(
                          cursorColor: primaryColor,
                          obscureText: true,
                          controller: _passwordController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock_outline,
                                color: accentColor),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
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
                              return 'Please enter the Password';
                            }
                            return null;
                          },
                        )
                    ),
                    Container(height: size.height * 0.025),
                    Container(
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: accentColor,
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                          ),
                          onPressed: () async {
                            if (FocusScope
                                .of(context)
                                .isFirstFocus) {
                              FocusScope.of(context).requestFocus(
                                  new FocusNode());
                            }
                            pr = ProgressDialog(context, type: ProgressDialogType.Normal,
                                isDismissible: false,
                                showLogs: true);
                            pr.update(message: "Authenticating...");
                            if (_formKey.currentState.validate()) {
                              await pr.show();
                              authenticateUser(_emailController.text,
                                  _passwordController.text);
                            }
                          },
                          child: Text("Login",
                            style: TextStyle(
                              color: textColorDark,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),),
                        ),
                      ),
                    ),

                    Container(
                      height: size.height * 0.01,
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator
                              .of(context)
                              .push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Register()
                              )
                          );
                        },
                        child: Text(
                          "Not registered yet?",
                          style: TextStyle(
                            fontSize: size.height*0.02,
                            color: textFieldColor
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}