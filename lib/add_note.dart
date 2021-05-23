import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/model/notes.dart';

import 'db/quiz_db.dart';

class AddNotes extends StatefulWidget {
  final String category;
  final int position;

  const AddNotes({Key? key, required this.category, required this.position})
      : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final FocusNode myFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();

  GlobalKey<ScaffoldState> key = GlobalKey();

  String? nameError;

  @override
  void initState() {
    super.initState();

    myFocusNode.requestFocus();
    nameController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 38),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    focusNode: myFocusNode,
                    textCapitalization: TextCapitalization.words,
                    controller: nameController,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      //store.errorMsgName,
                      hintText: "Add a note",
                      labelText: "Add a note",
                      errorText: nameError,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16, top: 30),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () => _addNotesAction(),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _addNotesAction() async {
    String note = nameController.text;

    if (note.length < 4) {
      setState(() {
        nameError = "Please type at least 4 letter";
      });
      return;
    } else {
      setState(() {
        nameError = null;
      });
    }

    final notes =
        Notes(category: widget.category, duration: widget.position, note: note);
    final row = await DatabaseHelper().saveNote(notes);
    print("inserted row $row");
    Navigator.pop(context);
  }
}
