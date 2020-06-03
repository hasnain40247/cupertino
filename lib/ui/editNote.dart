import 'package:finalnote/databasehelper/databasehelper.dart';
import 'package:finalnote/table/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class editNote extends StatefulWidget {
  final String title;
  final Note note;

  const editNote({Key key, this.title, this.note}) : super(key: key);
  @override
  _editNoteState createState() => _editNoteState(this.title, this.note);
}

class _editNoteState extends State<editNote> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final String title;
  final Note note;

  _editNoteState(this.title, this.note);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    return Scaffold(
      backgroundColor: Color(0xffc5cae9),
      appBar: AppBar(
        backgroundColor: Color(0xff5c6bc0),
        title: Text("$title Your Note"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(height: 300,width: 200,
            child: Image.asset("images/dnl.png"),
          ),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 220,
              width: 500,
              child: Card(
                elevation: 17,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                          cursorColor: Colors.black,
                          controller: titleController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.deepPurple)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Enter Your Note Title",
                              labelStyle: TextStyle(color: Colors.black)),
                          onChanged: (value) {
                            updateTitle();
                          }),
                      SizedBox(
                        height: 11,
                      ),
                      TextField(
                          cursorColor: Colors.black,
                          controller: descriptionController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.deepPurple)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Enter Your Note Description",
                              labelStyle: TextStyle(color: Colors.black)),
                          onChanged: (value) {
                            updateDescription();
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Color(0xff5c6bc0),
                                  child: Text("Save"),
                                  onPressed: savedata),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Color(0xff5c6bc0),
                                  child: Text("Delete"),
                                  onPressed: deletedata),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      )
    );
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void savedata() async {
    movetoLastScreen(context);
    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id != null) //saving when updatubg
    {
      await databaseHelper.updateNote(note);
    } else {
      await databaseHelper.insert(note);
    }
  }

  void deletedata() async {
    movetoLastScreen(context);
    if (note.id == null) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Status"),
                content: Text("No Note Was Deleted"),
              ));
      return;
    }
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0)
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Status"),
                content: Text("Note Was Deleted"),
              ));
    else
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Status"),
                content: Text("Note Could Not Be Deleted"),
              ));
  }
}

void movetoLastScreen(BuildContext context) {
  Navigator.pop(context, true);
}
