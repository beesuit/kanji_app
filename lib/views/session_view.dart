import 'package:flutter/material.dart';
import 'package:kanji_app/model/kotoba.dart';

class SessionView extends StatefulWidget {
  final List<Kotoba> kotobaList;
  final defaultStyle = TextStyle(color: Colors.white, fontSize: 15);
  final correctStyle = TextStyle(color: Colors.green[700], fontSize: 20);
  final wrongStyle = TextStyle(color: Colors.redAccent[700], fontSize: 20);

  SessionView({Key key, @required this.kotobaList}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  int kotobasNumber;
  int current;
  bool correct;
  int correctCount;
  int wrongCount;
  double accuracy;
  bool finished;

  @override
  void initState() {
    super.initState();
    kotobasNumber = widget.kotobaList.length;
    current = 0;
    correct = true;
    correctCount = 0;
    wrongCount = 0;
    accuracy = 0;
    finished = false;
  }

  @override
  Widget build(BuildContext context) {
    var previousKotoba = current > 0 ? widget.kotobaList[current - 1] : null;
    var currentKotoba = !finished ? widget.kotobaList[current] : previousKotoba;

    var style = correct ? widget.correctStyle : widget.wrongStyle;
    var child = current < widget.kotobaList.length ? buildKotobaBody(currentKotoba, previousKotoba, style) : buildStatsBody();

    return Container(
      child: Center(
        child: child,
      ),
    );
  }

  Widget buildStatsBody() {
    return Card(
      color: Colors.deepPurple,
      elevation: 15,
      shadowColor: Colors.blueGrey[600],
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Stats', style: widget.defaultStyle.copyWith(color: Colors.lightGreenAccent)),
            Text('Correct:$correctCount', style: widget.defaultStyle),
            Text('Wrong:$wrongCount', style: widget.defaultStyle),
            Text('Acc:${(accuracy*100).toStringAsPrecision(2)}%', style: widget.defaultStyle),
          ],
        ),
        width: double.infinity,
        padding: EdgeInsets.all(5),
      ),
    );
  }

  Widget buildKotobaBody(Kotoba currentKotoba, Kotoba previousKotoba, TextStyle style) {
    var focusNode = FocusNode();
    var textController = TextEditingController();

    return Column(
        children: <Widget>[
          buildStatsBody(),
          Card(
            color: Colors.blueAccent,
            elevation: 15,
            shadowColor: Colors.blueGrey[600],
            child: Container(
              //height: 200,
              child: Center(child: Text(currentKotoba.kanji, style: TextStyle(fontSize: 100, color: Colors.white),)),
              width: 300,
            ),
          ),
          TextField(
            onSubmitted: (answer) {
              _submitAnswer(answer, currentKotoba.hiragana);
              textController.clear();
              focusNode.requestFocus();
            },
            autocorrect: false,
            autofocus: true,
            textAlign: TextAlign.center,
            focusNode: focusNode,
            controller: textController,
          ),
          if (current>0) Text(correct ? 'CORRECT!' : 'WRONG!', style: style.copyWith(fontWeight: FontWeight.bold)),
          Text(previousKotoba?.hiragana ?? '', style: style),
          Text(previousKotoba?.english ?? '', style: style),
          Text(previousKotoba?.example ?? '', style: style),
        ],
      );
  }

  void _submitAnswer(String submmitedAnswer, String correctAnswer) {
    setState(() {
      correct = submmitedAnswer == correctAnswer;
      if (correct) correctCount+=1; else wrongCount+=1;

      accuracy = correctCount/kotobasNumber;
      current += 1;
      
      if (current == kotobasNumber) finished = true;
    });
    print(widget.kotobaList[current].kanji);
  }
}
