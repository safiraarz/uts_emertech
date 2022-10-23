import 'dart:math';
import 'package:color_mixer_160419158/screen/game.dart';
import 'package:color_mixer_160419158/screen/high_score.dart';
import 'package:color_mixer_160419158/screen/home.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  Result({
    Key? key,
    required this.final_time,
    required this.final_color_mixed,
    required this.final_avg_guesses,
    required this.final_hints_used,
    required this.final_total_score,
  }) : super(key: key);
  int final_time;
  int final_color_mixed;
  int final_avg_guesses;
  int final_hints_used;
  int final_total_score;

  @override
  State<Result> createState() => _ResultState();
}

String formatTime(int hitung) {
  var secs = hitung;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String time = formatTime(widget.final_time);
    return Scaffold(
        appBar: AppBar(
          title: Text('Result'),
        ),
        body: Container(
            height: 375,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1),
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 20)]),
            child: Column(children: [
              Text(
                "Final Score: ${widget.final_total_score}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
              Divider(
                height: 20,
              ),
              Text(
                "Total time played: " + time,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Text(
                "Color mixed: ${widget.final_color_mixed}",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Text(
                "Average guesses: ${widget.final_avg_guesses}",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Text(
                "Hint used: ${widget.final_hints_used}",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Divider(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Game()));
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text("MAIN MENU")),
            ])));
  }
}
