import 'package:flutter/material.dart';
import 'package:kanji_app/views/session_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:kanji_app/model/kotoba.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String _title = 'Kanji App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(title: _title),
      },
      title: _title,
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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        child: Center(child: Text('ERROR')),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SessionView(kotobaList: snapshot.data);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popAndPushNamed('home');
        },
        tooltip: 'Reset',
        child: Icon(Icons.restore),
      ),
    );
  }

  Future<List<Kotoba>> loadData() async {
    var data = await rootBundle.loadString('assets/kotoba.tsv');
    var parsedData =
        CsvToListConverter(fieldDelimiter: '\t', eol: '\n').convert(data);
    var result = List<Kotoba>();
    try {
      parsedData.forEach((element) {
        result.add(Kotoba(kanji: element[0], hiragana: element[1], english: element[2], example: element[3]));
      });
    } catch (e) {
      print(e);
    }

    return result..shuffle();
  }
}
