import 'dart:async';
import 'package:color_mixer_160419158/screen/result.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> firstHighScore() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('first_winner') ?? [];
}

Future<List<String>> secondHighScore() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('second_winner') ?? [];
}

Future<List<String>> thirdHighScore() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? top_score = prefs.getStringList('third_winner');
  return prefs.getStringList('third_winner') ?? [];
}

class HighScore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HighScore();
  }
}

class _HighScore extends State<HighScore> {
  bool isChanged = false;
  String first_won = "";
  String second_won = "";
  String thrid_won = "";
  late Timer _timer;
  int _posisi = 1;
  double _left = 0;
  double _top = 0;
  double _wh = 0;

  Display() {
    firstHighScore().then((first_res) {
      setState(() {
        if (first_res.length == 0) {
          first_won = "";
        } else {
          first_won = "Username: ${first_res[0]}\nScore: ${first_res[1]}";
        }
      });
    });
    secondHighScore().then((second_res) {
      setState(() {
        if (second_res.length == 0) {
          second_won = "";
        } else {
          second_won = "Username: ${second_res[0]}\nScore: ${second_res[1]}";
        }
      });
    });
    thirdHighScore().then((third_res) {
      setState(() {
        if (third_res.length == 0) {
          thrid_won = "";
        } else {
          thrid_won = "Username: ${third_res[0]}\nScore: ${third_res[1]}";
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = new Timer.periodic(new Duration(milliseconds: 100), (timer) {
      setState(() {
        isChanged = !isChanged;
        //posisi animasi pergerakan UFO
        _posisi++;
        if (_posisi > 4) _posisi = 1;
        if (_posisi == 1) {
          _left = 250;
          _top = 0;
        }
        if (_posisi == 2) {
          _left = 0;
          _top = 0;
        }
        if (_posisi == 3) {
          _left = 0;
          _top = 100;
        }
        if (_posisi == 4) {
          _left = 250;
          _top = 100;
        }
        //untuk memperbesar kecil ufo
        if (_top == 0) {
          _wh = 100;
        } else if (_top == 200) {
          _wh = 200;
        }
      });
    });

    Display();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'High Score',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                width: 400,
                height: 300,
                child: Stack(children: [
                  Image.asset(
                    "assets/images/stadium.jpg",
                    scale: 0.5,
                  ),
                  AnimatedPositioned(
                    duration: const Duration(seconds: 3),
                    curve: Curves.fastOutSlowIn,
                    left: _left,
                    top: _top,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 3),
                      width: _wh,
                      height: _wh,
                      child: Image.asset("assets/images/result.gif"),
                    ),
                  ),
                ])),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                      color: Color.fromARGB(255, 156, 175, 140),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/first_place.gif",
                              height: 75),
                          Text(
                            first_won,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                      color: Color.fromARGB(255, 156, 175, 140),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/2nd_place.gif",
                              height: 75),
                          Text(
                            second_won,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                      color: Color.fromARGB(255, 156, 175, 140),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/3rd_place.gif",
                              height: 75),
                          Text(
                            thrid_won,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
