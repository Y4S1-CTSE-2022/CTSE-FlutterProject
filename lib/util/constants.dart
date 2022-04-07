import 'package:flutter/material.dart';


const primaryColor = Color(0xff141823);
const primaryColorDark = Color(0xFF242430);
const accentColor = Color(0xFFFFD701);
const textFieldColor = Color(0xFFA8A8A8);
const textColorLight = Color(0xFFFFFFFF);
const textColorDark = Color(0xFF1A1A1A);
const adminCColor = Color(0xE8FFF7EE);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}