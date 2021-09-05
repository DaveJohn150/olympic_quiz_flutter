import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';

final double width = window.physicalSize.width; // window.devicePixelRatio;
final double height = window.physicalSize.height; // window.devicePixelRatio;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olympic Quiz',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Olympics Quiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
    var questionText;
    var b1 ;
    var b2 ;
    var b3 ;
    var b4 ;
    List<List<String>> data = [];
  _MyHomePageState();

    Future<List<List<String>>> loadAsset() async {
      String f = await rootBundle.loadString('assets/olympicData.txt');
      List<List<String>> finalData = [];
      List<String> lines = f.split("\n");
      for (var l in lines){
        List<String> qData = l.split(", ");
      finalData.add(qData);
      }
      Future.delayed(Duration(seconds: 10));
      return finalData;

    //temporary filling data
      data.add([ "1896", "Athens", "Greece" ]);
    data.add([ "1900", "Paris", "France" ]);
    data.add([ "1904", "St Louis", "USA" ]);
    data.add([ "1908", "London", "UK" ]);
    data.add(["1912", "Stockholm", "Sweden" ]);
    data.add(["1920","Antwerp","Netherlands" ]);

    for ( var i in data){
      print(i[0]);
    }
  }
Future<void> loadFile() async{
      data = await loadAsset();
      setNextQuestion();
}
      var current = 0; // index for data
      List<String> answers = ["","","","",""];
      var rng = new Random();

      void setNextQuestion() {
        setState(() {
            current = rng.nextInt(data.length); //selects an index for which question to use
            answers = ["", "", "", "", ""];
            var index = rng.nextInt(4); //index of correct answer
            answers[index] = data[current][1];
            getQuestionText();
            var unusedAnswers = List.from(data);
            unusedAnswers.removeAt(current);
            for (var i = 0; i < 4; i++) {
              if (i != index) {
                int idx;
                if (unusedAnswers.length > 4 - i) {
                  idx = rng.nextInt(unusedAnswers.length);
                  answers[i] = unusedAnswers[idx][1];
                  unusedAnswers.removeAt(idx);
                }
              }
            }
            b1 = answers[0];
            b2 = answers[1];
            b3 = answers[2];
            b4 = answers[3];
      });
      }

      void getQuestionText(){
      questionText = "Which was the Olympic city in " + data[current][0] + "?";
      }

      String getAnswer(index){
      return answers[index];
      }

      void getCorrectAnswer(){
          questionText = "Incorrect! It was in " + data[current][1] + ".";
    }

      void checkAnswer(a){
        setState(() {
        if (answers[a] == data[current][1]){
            questionText = "Correct!";
        }
        else {
            getCorrectAnswer();
          }
        });
      }



  @override
  void initState() {
super.initState();
loadFile();
  }
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: <Widget>[

            Text(
              '$questionText',
            ),
                  // when running on phone the buttons too big
            Padding(padding: EdgeInsets.only(top: height/8)),
            Row( children: <Widget> [
              Padding(padding: EdgeInsets.only(left: 2)),
              Expanded(child: ElevatedButton(onPressed: () {checkAnswer(0);
              Timer(Duration(seconds: 2), () => setNextQuestion());},
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(width/2,height/12))),
                  child: Text("$b1"))),
              Padding(padding: EdgeInsets.only(right: 5)),
              Expanded(child: ElevatedButton(onPressed: () {checkAnswer(1);
              Timer(Duration(seconds: 2), () => setNextQuestion());},
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(width/2,height/12))),
                  child: Text("$b2"))),
              Padding(padding: EdgeInsets.only(right: 2)),
            ]),
            Padding(padding: EdgeInsets.only(top: 5)),
            Row( children: <Widget> [
              Padding(padding: EdgeInsets.only(left: 2)),
              Expanded(child: ElevatedButton(onPressed: () {checkAnswer(2);
              Timer(Duration(seconds: 2), () => setNextQuestion());},
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(width/2,height/12))),
                  child: Text("$b3"))),
              Padding(padding: EdgeInsets.only(right: 5)),
              Expanded(child: ElevatedButton(onPressed: () {checkAnswer(3);
              Timer(Duration(seconds: 2), () => setNextQuestion());},
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(width/2,height/12))),
                  child: Text("$b4"))),
              Padding(padding: EdgeInsets.only(right: 2)),
            ]),
            Padding(padding: EdgeInsets.only(bottom: 2))
          ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


