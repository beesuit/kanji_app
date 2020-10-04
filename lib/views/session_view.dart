import 'package:flutter/material.dart';
import 'package:kanji_app/model/kotoba.dart';

class SessionView extends StatefulWidget {
  final List<Kotoba> kotobaList;
  final defaultStyle =
      TextStyle(color: Colors.white, fontSize: 15, locale: Locale('ja-JP'));
  final correctStyle = TextStyle(color: Colors.green[700], fontSize: 20);
  final wrongStyle = TextStyle(color: Colors.redAccent[700], fontSize: 20);

  SessionView({Key key, @required this.kotobaList}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  int kotobaNumber;
  int current;
  bool correct;
  int correctCount;
  int wrongCount;
  double accuracy;
  bool finished;

  @override
  void initState() {
    super.initState();
    kotobaNumber = widget.kotobaList.length;
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
    var child = !finished
        ? buildKotobaBody(currentKotoba, previousKotoba, style)
        : buildStatsBar();

    return Container(
      child: Center(
        child: child,
      ),
    );
  }

  Widget buildStatsBar() {
    return Card(
      color: Colors.deepPurple,
      elevation: 15,
      shadowColor: Colors.blueGrey[600],
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.translate, color: Colors.white),
            Text('${current + 1}/$kotobaNumber',
                style: widget.defaultStyle
                    .copyWith(color: Colors.lightGreenAccent)),
            Icon(Icons.check_circle, color: Colors.lightGreenAccent),
            Text('$correctCount', style: widget.defaultStyle.copyWith(color: Colors.lightGreenAccent)),
            Icon(Icons.clear, color: Colors.redAccent,),
            Text('$wrongCount', style: widget.defaultStyle.copyWith(color: Colors.redAccent)),
            Icon(Icons.data_usage, color:Colors.white),
            Text('${(accuracy * 100).toStringAsPrecision(2)}%',
                style: widget.defaultStyle.copyWith(color: Colors.lightGreenAccent)),
          ],
        ),
        width: double.infinity,
        padding: EdgeInsets.all(5),
      ),
    );
  }

  Widget buildKotobaBody(
      Kotoba currentKotoba, Kotoba previousKotoba, TextStyle style) {
    var focusNode = FocusNode();
    var textController = TextEditingController();

    return Column(
      children: <Widget>[
        buildStatsBar(),
        Card(
          color: Colors.blueAccent,
          elevation: 15,
          shadowColor: Colors.blueGrey[600],
          child: Container(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                currentKotoba.kanji,
                style: widget.defaultStyle
                    .copyWith(fontSize: 100, color: Colors.white),
              ),
            )),
            //width: 300,
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
        if (current > 0)
          Text(correct ? 'CORRECT!' : 'WRONG!',
              style: style.copyWith(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (current > 0)
              Card(
                margin: EdgeInsets.all(5),
                elevation: 5,
                color: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(previousKotoba?.kanji ?? '',
                      style: style.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
            Text(previousKotoba?.hiragana ?? '', style: style),
          ],
        ),
        Text(previousKotoba?.english ?? '', style: style),
        Text(previousKotoba?.example ?? '', style: style),
      ],
    );
  }

  void _submitAnswer(String submittedAnswer, String correctAnswer) {
    if (submittedAnswer == "") return;

    setState(() {
      correct = submittedAnswer == correctAnswer;
      if (correct)
        correctCount += 1;
      else
        wrongCount += 1;

      accuracy = correctCount / kotobaNumber;
      current += 1;

      if (current == kotobaNumber) {
        finished = true;
        current -= 1;
      }
    });
  }
}
