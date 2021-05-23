import 'package:chewie/chewie.dart';
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
  ChewieController? chewieController;
  int position = 0;

  final List<Notes> notes = [];

  String currentNote = "";

  bool isInitialsed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://sample-videos.com/video123/mp4/480/big_buck_bunny_480p_2mb.mp4',
    )..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: false,
          showControlsOnInitialize: false,
          allowPlaybackSpeedChanging: false,
          allowFullScreen: false,
        );
        setState(() {
          isInitialsed = true;
        });
      });

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.duration.inSeconds ==
              _controller.value.position.inSeconds) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => QuizScreen(
                category: widget.category,
              ),
            ));
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
                child: isInitialsed
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          children: [
                            Chewie(controller: chewieController!),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentNote = "";
                                  _controller.play();
                                });
                              },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 45.0),
                                  child: Text(
                                    "$currentNote",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
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

                    return Text("",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18));
                  },
                ),
              ),
              isInitialsed
                  ? Container(
                      width: double.infinity,
                      child: Card(
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: TextButton(
                            onPressed: () async {
                              chewieController?.pause();
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
                              chewieController!.play();
                            },
                            child: Text("Add Note",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18))),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController?.dispose();
    super.dispose();
  }
}
