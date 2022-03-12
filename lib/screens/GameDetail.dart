import 'package:firebase_database/firebase_database.dart';
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
                      Container(height: size.height*0.01),
                      Container(
                        alignment: Alignment.centerRight,
                        width: size.width*0.85,
                        child: Text("${widget.game.category}",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: size.height*0.025)
                        ),
                      ),
                      Container(height: size.height*0.005),
                      Container(
                        width: size.width*0.85,
                        child: YoutubePlayer(
                          controller: _controller,
                        ),
                      ),
                      Container(
                        height: size.height*0.05
                      ),
                      Container(
                        width: size.width*0.85,
                        child: Text(
                          "\t\t\t\t\t${widget.game.description}",
                          style: TextStyle(
                            fontSize: size.height*0.023,
                            color: Colors.white70
                          ),
                        ),
                      ),
                      Container(
                          height: size.height*0.03
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: size.width*0.85,
                        child: Text("Rating",
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
                        child: RatingBarIndicator(
                          rating: widget.game.rate.toDouble(),
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
                      Container(
                          height: size.height*0.05
                      ),
                    ],
                  ),
                ),
            )
        )
    );

  }
}

