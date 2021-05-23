import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/db/quiz_db.dart';
import 'package:quiz_app/generate_question.dart';
import 'package:quiz_app/score_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'get_ready_animation.dart';
import 'option_widget.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({Key? key, required this.category}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _start = 10;
  int initialValue = 10;

  int questionPosition = 0;
  late List<Questions> questions;
  late AnimationController _controller;

  late Animation _questionAnimation;
  late Animation _titleAnimation;
  late Animation _optionsAnimation;
  late Animation _progressAnimation;
  GlobalKey _option2Key = GlobalKey();
  Timer? _timer;

  bool _visible = true;
  bool index0Vis = true;
  bool index1Vis = true;
  bool index2Vis = true;
  bool index3Vis = true;

  //singleton
  DatabaseHelper helper = DatabaseHelper();
  int timeTaken = 0;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (!mounted) {
          return;
        }
        if (_start == 0) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                timer.cancel();
              });
            }
          });

          await startNewQuestion();

          helper.saveScore(questionPosition, initialValue, 0);
        } else {
          timeTaken = timeTaken + 1;

          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  Future<void> startNewQuestion() async {
    _timer?.cancel();
    setQuestionPosition();
    if (questionPosition >= questions.length) {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ScoreScreen(),
        ),
      );
      Navigator.pop(context);
    }
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => GetReadyScreen(),
      ),
    );

    setState(() {
      index0Vis = true;
      index1Vis = true;
      index3Vis = true;
      index2Vis = true;
      _visible = true;
    });
    _start = initialValue;

    _controller.reset();

    _controller.forward();

    Future.delayed(Duration(seconds: 2), () {
      if (this.showTimer) {
        startTimer();
      }
    });
  }

  int answerIndex = -1;

  bool showTimer = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      questionPosition = prefs.getInt("pos") ?? 0;

      final time = prefs.getString("timer_time") ?? "10";
      _start = int.parse(time);
      initialValue = _start;
    });
    Future.delayed(Duration(milliseconds: 300), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final showTimer = prefs.getBool("show_timer") ?? true;

      setState(() {
        this.showTimer = showTimer;
      });
    });

    questions = GenerateQuestions.getQuestions(widget.category);
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _titleAnimation = Tween(begin: 0.0, end: 25.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.20, curve: Curves.easeOut)));
// fontSize goes from 0.0 to 34.0
    _questionAnimation = Tween(begin: 0.0, end: 30.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.20, 0.40, curve: Curves.easeOut)));

    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.40, 0.60, curve: Curves.easeOut)));

    _optionsAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.60, 0.85, curve: Curves.easeOut)));
    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });

    Future.delayed(Duration(seconds: 3), () {
      if (this.showTimer) {
        startTimer();
      }
    });
  }

  Future<void> setQuestionPosition() async {
    questionPosition++;

    print("position set to $questionPosition");
    if (questionPosition <= questions.length - 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("pos", questionPosition);
    }
  }

  Future<void> answerClicked(int position, bool isCorrect) async {
    print("time taken : ${initialValue - _start}");
    helper.saveScore(
        questionPosition, initialValue - _start, isCorrect ? 1 : 0);
    setState(() {
      _timer?.cancel();
    });

    if (questionPosition == questions.length - 1) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ScoreScreen(),
        ),
      );
      Navigator.pop(context);
    }
    if (isCorrect) {
      await startNewQuestion();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.removeListener(() {});
    _controller.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Lottie.asset(
            'assets/images/background.json',
            fit: BoxFit.fill,
            alignment: Alignment.center,
            repeat: true,
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 46.0, left: 12, right: 12),
            child: SingleChildScrollView(
              child: Container(
                width: 400,
                height: MediaQuery.of(context).size.height + 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Text("🎉 Oh My Quiz",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: _titleAnimation.value)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Text(questions[questionPosition].question,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: _questionAnimation.value,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            )),
                      ),
                    ),
                    this.showTimer
                        ? Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: Opacity(
                              opacity: _progressAnimation.value,
                              child: AnimatedOpacity(
                                opacity: _visible ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 500),
                                child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                      animationEnabled: true,
                                      angleRange: 360,
                                      startAngle: 90,
                                      customWidths: CustomSliderWidths(
                                          progressBarWidth: 10)),
                                  min: 0,
                                  max: initialValue.toDouble(),
                                  initialValue:
                                      (initialValue - _start).toDouble(),
                                ),
                              ),
                            ))
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.transparent,
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: Opacity(
                          opacity: _optionsAnimation.value,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OptionWidget(
                                    index: 0,
                                    quickCall: (index, isRight) {
                                      if (isRight && index == 0) {
                                        setState(() {
                                          _timer?.cancel();
                                          index2Vis = false;
                                          index1Vis = false;
                                          index3Vis = false;
                                          _visible = false;
                                        });
                                      }
                                    },
                                    isVisible: index0Vis,
                                    question: questions[questionPosition],
                                    back: (isCorrect) {
                                      answerClicked(0, isCorrect);
                                    },
                                  ),
                                  OptionWidget(
                                      quickCall: (index, isRight) {
                                        if (isRight && index == 1) {
                                          setState(() {
                                            _timer?.cancel();
                                            index0Vis = false;
                                            index2Vis = false;
                                            index3Vis = false;
                                            _visible = false;
                                          });
                                        }
                                      },
                                      isVisible: index2Vis,
                                      index: 1,
                                      question: questions[questionPosition],
                                      back: (isCorrect) {
                                        answerClicked(1, isCorrect);
                                      }),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OptionWidget(
                                        index: 2,
                                        quickCall: (index, isRight) {
                                          if (isRight && index == 2) {
                                            setState(() {
                                              _timer?.cancel();
                                              index0Vis = false;
                                              index1Vis = false;
                                              index3Vis = false;
                                              _visible = false;
                                            });
                                          }
                                        },
                                        isVisible: index2Vis,
                                        question: questions[questionPosition],
                                        back: (isCorrect) {
                                          answerClicked(2, isCorrect);
                                        }),
                                    OptionWidget(
                                        quickCall: (index, isRight) {
                                          if (isRight && index == 3) {
                                            setState(() {
                                              _timer?.cancel();
                                              index0Vis = false;
                                              index1Vis = false;
                                              index2Vis = false;
                                              _visible = false;
                                            });
                                          }
                                        },
                                        isVisible: index3Vis,
                                        key: _option2Key,
                                        index: 3,
                                        question: questions[questionPosition],
                                        back: (isCorrect) {
                                          answerClicked(3, isCorrect);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
