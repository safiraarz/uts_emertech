import 'package:color_mixer_160419158/main.dart';
import 'package:color_mixer_160419158/screen/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class Home extends StatelessWidget {
  final Widget rotate = Container();
  final Widget scale = Container();
  final Widget fade = Container();
  final Widget typer = Container();
  final Widget typeWriter = Container();
  final Widget wavy = Container();
  final Widget colorize = Container();
  final Widget textLiquidFill = Container();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // appBar: AppBar(
        //   // title: Text('Home'),
        // ),
        body: Column(
      children: [
        Divider(
          height: 3,
        ),
        FadeIn(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn,
          child: Container(
              height: size.height / 2,
              width: size.width,
              margin: EdgeInsets.all(20),
              // padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 156, 175, 136),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, $active_user!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    Divider(
                      height: 15,
                    ),
                    Text(
                      "The goal of this game is to produce the exact color as shown within a time limit. "
                      "Provide the red, green, and blue values (0 to 255), then press the Guess Color button to answer. "
                      "Your score is determined by the remaining time. When the time is up, then it's a game over! See if you can reach top 5!",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Divider(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Game()));
                          },
                          child: Text("PLAY GAME")),
                    )
                  ],
                ),
              )),
        ),
      ],
    ));
  }
}
