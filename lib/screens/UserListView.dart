import 'package:epic_games/models/Category.dart';
import 'package:epic_games/models/Game.dart';
import 'package:epic_games/models/UserList.dart';
import 'package:epic_games/screens/AdminMenueHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'UpadteUser.dart';
import 'UpdateCategory.dart';
import 'UpdateGame.dart';
import '../util/constants.dart';

class UserListView extends StatefulWidget {



  @override
  _UserListViewState createState() => new _UserListViewState();
}


class _UserListViewState extends State<UserListView> {
  var _firebaseRef = FirebaseDatabase().reference().child("Users");
  DateTime firstPress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (firstPress == null ||
        now.difference(firstPress) > Duration(seconds: 2)) {
      firstPress = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  WillPopScope(
        child: Scaffold(
            backgroundColor: primaryColor,
            resizeToAvoidBottomInset:false,
            extendBodyBehindAppBar: true,
            appBar:  AppBar(
                elevation: 0,
                toolbarHeight: size.height*0.12,
                backgroundColor: primaryColor,
                title: Text("USER LIST",
                    style: TextStyle(
                        color: accentColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                ),
                //back button
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
                  onPressed: () =>    Navigator.of(context).pushAndRemoveUntil(
                     MaterialPageRoute(builder: (c) => AdminMenueHome()),
                         (route) => false)
                ),

                centerTitle: true,
                actions: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right:5.0),
                    child: IconButton(
                      icon:Icon(
                        Icons.logout,
                        size: size.width*0.06,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => Login()),
                                (route) => false);
                      },
                    ),
                  )
                ]
            ),
            body:SafeArea(
                child:  Container(
                  height: size.height*0.92,
                  child: StreamBuilder(
                    stream: _firebaseRef.onValue,
                    builder: (context, snap) {
                      if (snap.hasData && !snap.hasError && snap.data != null && snap.data.snapshot.value as Map != null ) {
                        //assign fetched data to map
                        Map data = snap.data.snapshot.value;
                        print(snap.data.snapshot.value);
                        List item = [];
                        //add data to the list
                        data.forEach((index, data) => item.add({"id": index,"contact": data['contact'],"email": data['email'],"name": data['name']}));
                        //create a list view
                        return ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (context, index) {
                            if(item[index] != null){
                              return Container(
                                margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                                child: Card(
                                    color: primaryColorDark,
                                    elevation: 10,
                                    child:GestureDetector(
                                      onTap: (){
                                        UserList user = new UserList(item[index]['id'], item[index]['contact'], item[index]['email'],item[index]['name']);
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext context) {
                                              return UpdateUser(userList:user);
                                            }));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(13),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: size.width*0.8-70,
                                              child: Column(
                                                children: [
                                                  Container(
                                                      padding: const EdgeInsets.all(5),
                                                      alignment: Alignment.centerLeft,
                                                      child: Row(
                                                          children:[
                                                            Text(item[index]['name'],
                                                                style: TextStyle(
                                                                  color: textColorLight,
                                                                  fontFamily: 'Nunito',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 25,)
                                                            ),
                                                          ]
                                                      )
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(5),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(item[index]['email'],
                                                        style: TextStyle(
                                                          color: textColorLight,
                                                          fontFamily: 'Nunito',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20,)
                                                    ),
                                                  ),
                                                  Container(
                                                      padding: const EdgeInsets.all(5),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(item[index]["contact"],
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          color: textColorLight,
                                                          fontFamily: 'Nunito',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20,)

                                                    ),
                                                  ),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        );
                      }
                      else
                        return Container(
                          color: primaryColor,
                          child: Text('empty values'),
                        );
                    },
                  ),
                )
            )
        ),
        onWillPop: onWillPop
    );
  }
}