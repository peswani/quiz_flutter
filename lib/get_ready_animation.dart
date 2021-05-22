import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GetReadyScreen extends StatefulWidget {
  const GetReadyScreen({Key? key}) : super(key: key);

  @override
  _GetReadyScreenState createState() => _GetReadyScreenState();
}

class _GetReadyScreenState extends State<GetReadyScreen> {
  int _start = 4;
  late Timer _timer;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });

          if (_start == 0) {
            Navigator.pop(context);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Get Ready!",
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: Text(_start <= 3 ? "$_start" : "",
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    )),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
