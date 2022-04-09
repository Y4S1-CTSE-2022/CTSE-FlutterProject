import 'package:epic_games/models/Category.dart';
import 'package:epic_games/models/Game.dart';
import 'package:epic_games/screens/AddGameList.dart';
import 'package:epic_games/screens/AdminMenueHome.dart';
import 'package:epic_games/screens/ViewGames.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'UpdateCategory.dart';
import 'UpdateGame.dart';
import '../util/constants.dart';

class CategoryList extends StatefulWidget {

  @override
  _CategoryListState createState() => new _CategoryListState();
}


class _CategoryListState extends State<CategoryList> {
  final _firebaseRef = FirebaseDatabase().reference().child("Category");

  final _firestore = FirebaseStorage.instance.ref();
// no need of the file extension, the name will do fine.

  DateTime firstPress;
  List categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDBData();


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

  Future loadDBData() async {
    final event = await _firebaseRef.once(DatabaseEventType.value);
    final Map data = event.snapshot.value;

    data.forEach((key, value) async {
      var img = _firestore.child('category_img/'+ value["image"]);
      var getImg = await img.getDownloadURL();

      categoryList.add({
        "id": key,
        "category": value["category"],
        "description": value["description"],
        "image": getImg
      });
    });
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
                toolbarHeight: size.height*0.11,
                backgroundColor: primaryColor,
                title: Text("CATEGORY LIST",
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
                child: Builder(builder: (context) {
                  if (categoryList.length > 0) {
                    return ListView.builder(
                      itemCount: categoryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                          child: Card (
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListTile(
                                onTap: () {},
                                // leading:  Image.network(categoryList[index]["image"]),
                                title: Text(categoryList[index]["category"]),
                                subtitle: Text(categoryList[index]["description"]),
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  } else  {
                    return Container(
                      color: primaryColor,
                      child: Text('No Data'),
                    );
                  }
                }),
            )
        ),
        onWillPop: onWillPop
    );
  }
}