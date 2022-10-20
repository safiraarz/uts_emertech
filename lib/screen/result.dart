import 'dart:math';
import 'package:color_mixer_160419158/screen/game.dart';
import 'package:color_mixer_160419158/screen/high_score.dart';
import 'package:color_mixer_160419158/screen/home.dart';
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen'),
      ),
      body: Center(
          child: Column(children: [
        Text(
          "Final Score: ", textAlign: TextAlign. center,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        Divider(
          height: 20,
        ),
        Text(
          "Total time played: " , textAlign: TextAlign.left
          /* code how to sum time*/,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        Text(
          "Color mixed: " , textAlign: TextAlign.left
          /* code how to sum how many time played*/,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        Text(
          "Average guesses: ", textAlign: TextAlign.left
           /* code how to sum how many guesses*/,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        Text(
          "Hint used: " , textAlign: TextAlign.left
          /* code how to sum hint used*/,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        Divider(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Game()));
            },
            child: Text("PLAY AGAIN")),
        Divider(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HighScore()));
            },
            child: Text("HIGH SCORES")),
        Divider(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: Text("MAIN MENU")),
      ])),
    );
  }
}
