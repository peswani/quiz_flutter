import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/db/quiz_db.dart';
import 'package:quiz_app/model/notes.dart';
import 'package:quiz_app/quiz_play.dart';
import 'package:video_player/video_player.dart';

import 'add_note.dart';

class VideoApp extends StatefulWidget {
  final String category;

  const VideoApp({Key? key, required this.category}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  int position = 0;

  final List<Notes> notes = [];

  String currentNote = "";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://sample-videos.com/video123/mp4/480/big_buck_bunny_480p_2mb.mp4',
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.setLooping(false);
          _controller.play();
        });
      });
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.duration.inSeconds ==
              _controller.value.position.inSeconds) {
        Navigator.pop(context);
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => QuizScreen(
              category: widget.category,
            ),
          ),
        );
      }
    });
    getAllNotes();
  }

  Future<void> getAllNotes() async {
    final notes = await DatabaseHelper().getAllNotes();
    print("notes from database $notes");
    this.notes.clear();

    this.notes.addAll(notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/images/background.json',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              repeat: true,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: _controller.value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          if (_controller.value.isPlaying) {
                            setState(() {
                              _controller.pause();
                            });
                          } else {
                            setState(() {
                              print("trying to play video...");
                              _controller.play();
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                            Positioned.fill(
                              child: _controller.value.isBuffering
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                      ],
                                    )
                                  : !_controller.value.isPlaying
                                      ? Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                        )
                                      : Container(),
                            )
                          ],
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, VideoPlayerValue value, child) {
                    if (position != value.position.inSeconds) {
                      position = value.position.inSeconds;

                      for (Notes n in notes) {
                        if (n.duration == position) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((_) => setState(() {
                                    // print(n);
                                    currentNote = n.note;
                                    _controller.pause();
                                  }));
                          break;
                        }
                      }
                    }

                    return Text(
                        "Time  ${value.position.inMinutes.toString()} : ${value.position.inSeconds.toString()}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Card(
                      color: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextButton(
                          onPressed: () async {
                            await Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => AddNotes(
                                  category: widget.category,
                                  position: position,
                                ),
                              ),
                            );
                            getAllNotes();
                          },
                          child: Text("Add Note",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18))),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentNote = "";
                    _controller.play();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text("$currentNote",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 22)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
