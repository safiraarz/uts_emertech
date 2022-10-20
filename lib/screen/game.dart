import 'dart:async';
import 'dart:math';
import 'package:color_mixer_160419158/class/range.dart';
import 'package:color_mixer_160419158/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import '../class/color2.dart';
import '../main.dart';

String username = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

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

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  late final controller;
  late int _hitung;
  late Timer _timer;
  double opacityLevel = 0;
  int _iniValue = 10;
  bool _isrun = false;
  int _question_no = 0;
  int _stage = 0;
  int _point = 0;
  int _first_winner = 0;
  int _second_winner = 0;
  int _third_winner = 0;

  //coba color
  Random random = Random();
  int randomR = 0;
  int randomG = 0;
  int randomB = 0;
  //coba col

  //Set Shared

  void setNewTopOne(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("first_winner", data);
    main();
  }

  void setNewTopTwo(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("_second_winner", data);
    main();
  }

  void setNewTopThree(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("third_winner", data);
    main();
  }

  void doRemove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    main();
  }

  String formatTime(int hitung) {
    var secs = hitung;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  finishQuiz() {
    _timer.cancel();

    if (_point >= _third_winner && _point < _second_winner) {
      doRemove("third_winner");
      List<String> data = ['$username', '$_point'];
      print("Third Winner " + data.toString());
      setNewTopThree(data);
    } else if (_point >= _second_winner && _point < _first_winner) {
      doRemove("second_winner");
      List<String> data = ['$username', '$_point'];
      print("Second Winner " + data.toString());
      setNewTopTwo(data);
    } else if (_point >= _first_winner) {
      doRemove("First Winner");
      List<String> data = ['$username', '$_point'];
      print("Pengecekan one " + data.toString());
      setNewTopOne(data);
    }
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('GAME OVER'),
              content: Text('Good game, great eyes!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'SHOW RESULT');
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text('SHOW RESULT'),
                ),
              ],
            ));
  }

  Fade() {
    setState(() {
      controller = FadeInController(autoStart: true);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Fade();
    super.initState();
    checkUser().then((String result) {
      if (result == '') {
        username = "Kosong";
      } else {
        username = result;
      }
    });
    firstHighScore().then((resultOne) {
      print(resultOne.length);
      if (resultOne.length == 0) {
        List<String> data = ['$username', '$_point'];
        setNewTopOne(data);
      } else {
        _first_winner = int.parse(resultOne[1]);
        print("First " + _first_winner.toString());
        secondHighScore().then((resultTwo) {
          print(resultTwo.length);
          if (resultTwo.length == 0) {
            List<String> data = ['$username', '$_point'];
            setNewTopTwo(data);
          } else {
            _second_winner = int.parse(resultTwo[1]);
            print("Second " + _second_winner.toString());
            thirdHighScore().then((resultThree) {
              if (resultThree.length == 0) {
                List<String> data = ['$username', '$_point'];
                setNewTopThree(data);
              } else {
                _third_winner = int.parse(resultThree[1]);
                print("Third " + _third_winner.toString());
              }
            });
          }
        });
      }
    });
    _hitung = _iniValue;
    //startTimer();
    controller.fadeIn();
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    randomR = random.nextInt(256);
    randomG = random.nextInt(256);
    randomB = random.nextInt(256);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: LinearPercentIndicator(
                center: Text(formatTime(_hitung)),
                width: MediaQuery.of(context).size.width - 20,
                lineHeight: 25.0,
                percent: 1 - (_hitung / _iniValue),
                backgroundColor: Colors.grey,
                progressColor: Colors.blueAccent,
              ),
            ),
            Text(
              "Score: ",
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Guess this color! ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                Text(
                  "Your color",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  // height: 150.0,
                  // width: 150.0,
                  // color: Colors.transparent,
                  // child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Colors.green,
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  //     child: new Center()),
                  child: ColorOptions(randomR, randomG, randomB)
                ),
                Container(
                  height: 150.0,
                  width: 150.0,
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: new Center()),
                ),
              ],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "#Coba kiri ",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                Text(
                  "#Coba kanan",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ],
            ),
            Divider(
              height: 15,
            ),
            Text(
              "#Coba too far atau ga ",
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            Divider(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Red (0-255)'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                CustomRangeTextInputFormatter(),
              ],
            ),
            Divider(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Green (0-255)'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                CustomRangeTextInputFormatter(),
              ],
            ),
            Divider(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Blue (0-255)'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                CustomRangeTextInputFormatter(),
              ],
            ),
            Divider(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text("GUESS COLOR")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text("SHOW HINT")),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
