import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animation_calculation.dart';
import 'colorutil.dart';
import 'generate_question.dart';

class OptionWidget extends StatefulWidget {
  final int index;
  final Questions question;
  final Function(bool)? back;
  final Function(int, bool) quickCall;
  final bool? isVisible;

  const OptionWidget(
      {Key? key,
      required this.index,
      this.back,
      required this.question,
      this.isVisible,
      required this.quickCall})
      : super(key: key);

  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget>
    with TickerProviderStateMixin {
  String text = "A";

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();
  late AnimationController _animationController;
  late AnimationController _zoomOutController;
  late Animation _scaleAnimation;
  late Animation _scaleDownAnimation;
  late Animation<Offset> _animation;

  bool isCorrectAnswer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.index == 1) {
      text = "B";
    } else if (widget.index == 2) {
      text = "C";
    } else if (widget.index == 3) {
      text = "D";
    }
    print("called");
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _zoomOutController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.33, curve: Curves.easeOut)));

    _scaleAnimation = Tween(begin: 120.0, end: 150.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.33, 0.66, curve: Curves.easeOut)));

    _scaleDownAnimation = Tween(begin: 150.0, end: 0.0).animate(CurvedAnimation(
        parent: _zoomOutController,
        curve: Interval(0.0, 1, curve: Curves.easeOut)));

    _zoomOutController.addListener(() {
      setState(() {});
    });
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: AnimatedOpacity(
        opacity: widget.isVisible ?? true ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: FlipCard(
          flipOnTouch: false,
          key: flipKey,
          back: Container(
            width: _scaleDownAnimation.value,
            height: _scaleDownAnimation.value,
            child: Card(
              color: Colors.white,
              child: _zoomOutController.isAnimating
                  ? Container()
                  : Icon(
                      isCorrectAnswer ? Icons.check : Icons.close,
                      color: isCorrectAnswer ? Colors.green : Colors.red,
                      size: 50,
                    ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
            ),
          ),
          front: Card(
            key: cardKey,
            elevation: 2,
            child: GestureDetector(
              onTap: () {
                bool isRight = widget.question.options[widget.index] ==
                    widget.question.answer;
                widget.quickCall.call(widget.index, isRight);
                final off = AnimationCalculation(cardKey).getPositions();
                _animation = Tween<Offset>(begin: Offset(0, 0), end: off)
                    .animate(_animationController);

                _animationController.forward().whenComplete(() {
                  if (isRight) {
                    setState(() {
                      isCorrectAnswer = true;
                    });
                  } else {
                    isCorrectAnswer = false;
                  }
                  flipKey.currentState!.toggleCard();
                  if (isRight) {
                    Future.delayed(Duration(seconds: 1), () {
                      _zoomOutController.forward().whenComplete(() {
                        widget.back?.call(isRight);
                        Future.delayed(Duration(seconds: 3), () {
                          flipKey.currentState!.toggleCard();
                          _animationController.reset();
                          _zoomOutController.reset();
                        });
                      });
                    });
                  } else {
                    widget.back?.call(isRight);
                    Future.delayed(Duration(seconds: 1), () {
                      flipKey.currentState!.toggleCard();
                      _animationController.reset();
                      _zoomOutController.reset();
                    });
                  }
                });
              },
              child: Container(
                width: _scaleAnimation.value,
                height: _scaleAnimation.value,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                        maxRadius: 20,
                        backgroundColor:
                            ColorUtil.getBackGroundColor(widget.index),
                        child: Text(
                          text,
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                        )),
                    Text(
                      widget.question.options[widget.index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _zoomOutController.dispose();
    _animationController.removeListener(() {});
    _animationController.dispose();
  }
}
