import 'package:flutter/material.dart';



const primaryColor = Color(0xFF021f3f);
const accentColor = Color(0xFFF2855E);
const primaryColorDark = Color(0xFF6FEF8D);
const textFieldColor = Color(0xFFFFFFFF);
const adminCColor = Color(0xE8FFF7EE);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}