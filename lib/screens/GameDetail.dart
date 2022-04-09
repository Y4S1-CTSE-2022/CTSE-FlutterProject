import 'package:epic_games/screens/AddReview.dart';
import 'package:epic_games/screens/ViewReview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/Game.dart';
import '../util/constants.dart';

class GameDetail extends StatefulWidget {
  final Game game;
  GameDetail({Key key, @required this.game}) : super(key: key);
  @override
  _GameDetailState createState() => new _GameDetailState();
}


class _GameDetailState extends State<GameDetail> {

  YoutubePlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '${YoutubePlayer.convertUrlToId(widget.game.video_url)}',
      flags: YoutubePlayerFlags(
        mute: false,
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

    Size size = MediaQuery.of(context).size;
    return  Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset:false,
        extendBodyBehindAppBar: true,
        appBar:  AppBar(
            elevation: 0,
            toolbarHeight: size.height*0.08,
            backgroundColor: primaryColor,
            title: Text("Game Details",
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
                  child: Column(
                    children: [
                      Container(height: size.height*0.02),
                      Container(
                        alignment: Alignment.center,
                        width: size.width*0.7,
                        child: Text("${widget.game.name} (${widget.game.year})",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height*0.035)
                        ),
                      ),
                      Container(height: size.height*0.05),
                      Container(
                        width: size.width*0.85,
                        child: YoutubePlayer(
                          controller: _controller,
                        ),
                      ),
                      Container(height: size.height*0.005),
                      Container(
                          height: size.height*0.05
                      ),
                      Container(
                        child: RatingBarIndicator(
                          rating: widget.game.rating.toDouble(),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: size.height*0.04,
                          direction: Axis.horizontal,
                          itemPadding: EdgeInsets.all(5),
                        ),
                      ),
                      Container(height: size.height*0.005),
                      Container(
                        height: size.height*0.05
                      ),
                      Container(
                          height: size.height*0.03
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: size.width*0.85,
                        child: Text("Description",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height*0.03)
                        ),
                      ),
                      Container(
                          height: size.height*0.01
                      ),
                      Container(
                          height: size.height*0.01
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: size.width*0.85,
                        child: Text(
                          "${widget.game.description}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: size.height*0.023,
                              color: Colors.white70
                          ),
                        ),
                      ),
                      Container(
                          height: size.height*0.01
                      ),

                      Container(
                          height: size.height*0.05
                      ),
                      Container(
                        width: size.width*0.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                            color: accentColor,
                            onPressed: () {
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(builder: (c) => AddReview()),
                              //         (route) => false);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) {
                                    return AddReview(gameId: widget.game.id);
                                  }));
                            },
                            child: Text(
                              "Add Review",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height*0.02),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          height: size.height*0.05
                      ),
                      Container(
                        width: size.width*0.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                            color: accentColor,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) {
                                    return ViewReview(gameId: widget.game.id, userId: user.uid);
                                  }));
                            },
                            child: Text(
                              "View Review",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height*0.02),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            )
        )
    );

  }
}

