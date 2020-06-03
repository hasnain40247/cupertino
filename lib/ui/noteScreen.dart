import 'package:finalnote/databasehelper/databasehelper.dart';
import 'package:finalnote/table/table.dart';
import 'package:finalnote/ui/editNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class noteScreen extends StatefulWidget {
  @override
  _noteScreenState createState() => _noteScreenState();
}

class _noteScreenState extends State<noteScreen> {
DatabaseHelper databaseHelper=DatabaseHelper();
List<Note> noteList;


  TextEditingController taskController = TextEditingController();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if(noteList==null)
      {
        noteList=List<Note>();
        updateView();
      }
    return Scaffold(
        backgroundColor: Color(0xffc5cae9),
        appBar: AppBar(
          backgroundColor: Color(0xff5c6bc0),
          title: Text("My To-Do List"),
          centerTitle: true,
        ),
        body: Container(
         child: ListView.builder(
             itemCount: count,
             itemBuilder: (BuildContext context, int index){
           return Dismissible(
             key:Key('${noteList[index]}'),
             background: Container(
               color: Colors.red,
               child: Icon(Icons.delete),
             ),
             onDismissed: (direction){
               if(direction== DismissDirection.endToStart){
                 _delete(context, noteList[index]);
               }
               else if(direction== DismissDirection.startToEnd){
                 _delete(context, noteList[index]);
               }
             },
             child: Padding(
               padding: const EdgeInsets.only(top:9.0,right: 11,left: 11),
               child: noteTile(noteList[index]),
             ),
           );
         }),

        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor:Color(0xff5c6bc0) ,
        onPressed: () async{
            bool result=await Navigator.push(context, MaterialPageRoute(builder: (context){
          return editNote(title: "Add",note: Note('',''),);
    }),);
            if(result==true)
              {
              updateView();}
        },

    ));

  }




  Widget noteTile(Note note)
  {
    return Container(
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(24)
      ),
      child: ListTile(
        title: Text("${note.title}"),
        subtitle: Text("Date Created: ${note.date}",style: TextStyle(fontStyle: FontStyle.italic),),
      onLongPress: ()async{
        bool result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>editNote(title: "Edit",note: note,)));
        if(result==true)
          updateView();
      },
        onTap: ()=>_showDialog(note),
      ),
    );
  }

  void updateView() {
    final Future<Database> dbFuture=databaseHelper.initializeData();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });
  }

  void noteedit(Note note) async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>editNote(title: "Edit",note: note,)));
    if(result==true)
      updateView();
}

void _delete(BuildContext context,Note note) async{
  int result=await databaseHelper.deleteNote(note.id);
  if(result !=0)
  {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successfully Deleted")));
    updateView();
  }
}
void _showDialog(Note note) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("${note.title}"),
        content: Text(note.description==null? "Write A Description...":note.description),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close",style: TextStyle(color: Colors.deepPurpleAccent),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}

