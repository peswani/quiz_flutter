import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'db/quiz_db.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  int timeTaken = 0;
  int score = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () async {
      final helper = DatabaseHelper();
      final s = await helper.getScore();
      final t = await helper.getTotalTime();
      setState(() {
        score = s;
        timeTaken = t;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/images/background.json',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              repeat: true,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Score : $score",
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 58.0),
                  child: Text("Time Taken : $timeTaken sec",
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: () => _playAgain(),
                      child: new Text("Play Again!!"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playAgain() async {
    await DatabaseHelper().deleteAll();
    Navigator.of(context).pop();
  }
}
