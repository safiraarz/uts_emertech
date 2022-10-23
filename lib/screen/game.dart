import 'dart:async';
import 'dart:math';
import 'package:color_mixer_160419158/class/range.dart';
import 'package:color_mixer_160419158/screen/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
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
  late double _hitung;
  late Timer _timer;
  double opacityLevel = 0;
  double _iniValue = 20;
  bool _isrun = false;
  int _question_no = 0;
  int _first_winner = 0;
  int _second_winner = 0;
  int _third_winner = 0;

  //variable yg disimpan utk result
  int total_time = 0; //untuk hitung total waktu yg dimainkan
  int color_mixed = 0; //untuk hitung brp kali color di random
  int avg_guesses = 0; //untuk hitung rata2 tebakan tiap soal
  int hints_used = 0; //untuk hitung brp total hint digunakan
  double total_score = 0; //untuk hitung total score

  double curr_score = 0;
  int benar = 0;

//untuk score
  double hint_mlt = 1; //untuk perhitungan skor di hint multiplier
  int guess_mlt = 0; //untuk perhitungan skor di guess multiplier

  String random_hex = "";
  String player_hex = "";
  String euc_guess = "";

  //coba color
  int randomR = Random().nextInt(256);
  int randomG = Random().nextInt(256);
  int randomB = Random().nextInt(256);

  final TextEditingController red_value = TextEditingController();
  final TextEditingController green_value = TextEditingController();
  final TextEditingController blue_value = TextEditingController();

  static int result_red = 255;
  static int result_green = 255;
  static int result_blue = 255;
  Color _color_result =
      Color.fromRGBO(result_red, result_green, result_blue, 1);
  int _euc = 0;
  //coba color

  //Set Shared

  void setNewTopOne(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("first_winner", data);
    main();
  }

  void setNewTopTwo(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("second_winner", data);
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
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  finishQuiz() {
    _timer.cancel();

    if (total_score >= _third_winner && total_score < _second_winner) {
      doRemove("third_winner");
      List<String> data = ['$username', '$total_score'];
      print("Third Winner " + data.toString());
      setNewTopThree(data);
    } else if (total_score >= _second_winner && total_score < _first_winner) {
      doRemove("second_winner");
      List<String> data = ['$username', '$total_score'];
      print("Second Winner " + data.toString());
      setNewTopTwo(data);
    } else if (total_score >= _first_winner) {
      doRemove("First Winner");
      List<String> data = ['$username', '$total_score'];
      print("First winner " + data.toString());
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Result(
                                  final_time: total_time,
                                  final_color_mixed: color_mixed,
                                  final_avg_guesses: avg_guesses,
                                  final_hints_used: hints_used,
                                  final_total_score: total_score,
                                )));
                  },
                  child: const Text('SHOW RESULT'),
                ),
              ],
            ));
  }

  startTimer() {
    _timer = new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_isrun) {
          _hitung--;
          if (_hitung <= 0) {
            finishQuiz();
          }
        }
        _isrun = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
        List<String> data = ['$username', '$total_score'];
        setNewTopOne(data);
      } else {
        _first_winner = int.parse(resultOne[1]);
        print("First " + _first_winner.toString());
        secondHighScore().then((resultTwo) {
          print(resultTwo.length);
          if (resultTwo.length == 0) {
            List<String> data = ['$username', '$total_score'];
            setNewTopTwo(data);
          } else {
            _second_winner = int.parse(resultTwo[1]);
            print("Second " + _second_winner.toString());
            thirdHighScore().then((resultThree) {
              if (resultThree.length == 0) {
                List<String> data = ['$username', '$total_score'];
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
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  //class
  double _euclidean() {
    double euc = sqrt(((randomR - result_red) * (randomR - result_red)) +
        ((randomG - result_green) * (randomG - result_green)) +
        ((randomB - result_green) * (randomB - result_green)));
    return euc;
  }

  String result_euc() {
    if (_euclidean() > 128) {
      euc_guess = "Try Again!";
    } else if (_euclidean() > 64 && _euclidean() <= 128) {
      euc_guess = "Too far!";
    } else if (_euclidean() > 32 && _euclidean() <= 64) {
      euc_guess = "You got this!";
      benar++;
    } else if (_euclidean() > 16 && _euclidean() <= 32) {
      euc_guess = "Close enough";
    } else if (_euclidean() < 16) {
      euc_guess = "Almost!";
    }
    return euc_guess;
  }

  double score_result() {
    setState(() {
      if (color_mixed >= 5) {
        curr_score = hint_mlt * 1 * _hitung;
      } else {
        curr_score = hint_mlt * (5 - color_mixed) * _hitung;
      }
      total_score = total_score + curr_score;
    });
    print(total_score);
    return total_score;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            Divider(
              height: 15,
            ),
            LinearPercentIndicator(
              center: Text(formatTime(_hitung.ceil())),
              width: MediaQuery.of(context).size.width,
              lineHeight: 30.0,
              percent:
                  (_hitung / _iniValue) >= 1.0 || (_hitung / _iniValue) <= 0.0
                      ? 1.0
                      : (_hitung / _iniValue),
              backgroundColor: Colors.grey,
              progressColor: Color.fromRGBO(randomR, randomG, randomB, 1),
            ),
            Divider(
              height: 10,
            ),
            Text(
              "Score: $total_score",
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
                  height: 150.0,
                  width: 150.0,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(randomR, randomG, randomB, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: new Center()),
                ),
                Container(
                  height: 150.0,
                  width: 150.0,
                  child: Container(
                      decoration: BoxDecoration(
                          color: _color_result,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: new Center()),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$random_hex",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                Text(
                  "$player_hex",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ],
            ),
            Divider(
              height: 15,
            ),
            Text(
              "$euc_guess",
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            Divider(
              height: 15,
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                    controller: red_value,
                    decoration: InputDecoration(hintText: 'Red (0-255)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CustomRangeTextInputFormatter(),
                    ],
                    onChanged: (v) {
                      if (red_value != "") {
                        _euclidean();
                        result_red = int.parse(red_value.text);
                      } else {
                        result_red = 255;
                      }
                    })),
            Divider(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: green_value,
                  decoration: InputDecoration(hintText: 'Green (0-255)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CustomRangeTextInputFormatter(),
                  ],
                  onChanged: (v) {
                    if (green_value != "") {
                      _euclidean();
                      result_green = int.parse(green_value.text);
                    } else {
                      result_green = 255;
                    }
                  }),
            ),
            Divider(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: blue_value,
                  decoration: InputDecoration(hintText: 'Blue (0-255)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CustomRangeTextInputFormatter(),
                  ],
                  onChanged: (v) {
                    if (blue_value != "") {
                      _euclidean();
                      result_blue = int.parse(blue_value.text);
                    } else {
                      result_blue = 255;
                    }
                  }),
            ),
            Divider(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      print("as");

                      setState(() {
                        _euclidean();
                        result_euc();
                        print(_euclidean());
                        _color_result = Color.fromRGBO(
                            result_red, result_green, result_blue, 1);

                        total_time += (_iniValue - _hitung).ceil();
                        print(_hitung);
                        print("color");
                        color_mixed += 1;
                        print(color_mixed);
                        // avg_guesses = (color_mixed / benar).ceil();
                        print(avg_guesses);
                        score_result();

                        print("colorss");

                        red_value.text = "";
                        green_value.text = "";
                        blue_value.text = "";
                      });

                      score_result();
                    },
                    child: const Text("GUESS COLOR")),
                ElevatedButton(
                    onPressed: () {
                      hints_used += 1;
                      random_hex =
                          "#${Color.fromRGBO(randomR, randomG, randomB, 1).value.toRadixString(16)}";
                      player_hex =
                          "#${Color.fromRGBO(result_red, result_green, result_blue, 1).value.toRadixString(16)}";
                      _hitung -= _hitung / 2;

                      //menghitung value hint multiplier
                      // if (hints_used == 0) {
                      //   hint_mlt += 1;
                      // } else if (hints_used >= 1) {
                      //   hint_mlt += 0.5;
                      // }
                      hint_mlt = 0.5;
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
