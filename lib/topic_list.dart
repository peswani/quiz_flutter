import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/score_screen.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colorutil.dart';
import 'generate_question.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> categories = [
    "Animals",
    "Politics",
    "Plants",
    "Movies",
    "Science",
    "Math",
    "History",
    "Geography"
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkForComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final questionPosition = prefs.getInt("pos") ?? 0;
    if (questionPosition ==
        GenerateQuestions.getQuestions("category").length - 1) {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ScoreScreen(),
        ),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/images/background.json',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              repeat: true,
            ),
          ),
          //
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Column(
                children: [
                  Align(
                    child: IconButton(
                        onPressed: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => Settings(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings)),
                    alignment: Alignment.topRight,
                  ),
                  Text(
                    "Select a category...",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemCount: categories.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 0,
                            color: Colors.transparent,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final item = categories[index];
                          return Card(
                            color: ColorUtil.getBackGroundColor(index),
                            elevation: 2,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 12, right: 10),
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Text(
                                    categories[index],
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.lato(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_right,
                                  color: Colors.white,
                                ),
                                onTap: () async {
                                  bool isComplete = await checkForComplete();
                                  if (isComplete) return;
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          VideoApp(
                                        category: categories[index],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
