
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kisisel_asistan/screens/noteScreen.dart';

class NoteDetail extends StatefulWidget {
  NoteDetail(this.doc, {super.key});
  QueryDocumentSnapshot doc;

  @override
  State<NoteDetail> createState() => _NoteDetailState();

  Future<void> deleteNoteOnFirestore(String noteId) async {
    await FirebaseFirestore.instance.collection("notes").doc(noteId).delete();
  }
  Future<void> editNoteOnFirestore(String noteId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance.collection("notes").doc(noteId).update(updatedData);
  }
}

class _NoteDetailState extends State<NoteDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('Note Detail'),
      centerTitle: true,
      backgroundColor: Color(0xFFE9C2C5),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NoteScreen(),),
          );
        },
      ),
    ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.done_all),
                SizedBox(width: 8),
                Text(
                  widget.doc["note_title"],
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text(widget.doc["creation_date"],),
            SizedBox(height: 15,),
        
            Text(widget.doc["note_content"],
            style: TextStyle(fontSize: 15),),
            SizedBox(height: 10,),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(18.0),
              child: FloatingActionButton.extended(
                heroTag: Icons.edit,
                onPressed: () {
                  Map<String, dynamic> updatedData = {/* Updated data here */};
                  widget.editNoteOnFirestore(widget.doc.id, updatedData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Note edited successfully."),
                    ),
                  );
                },
                backgroundColor: Color(0xFF9DB0CE),
                label: Text("Edit"),
                icon: Icon(Icons.edit),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(18.0),
              child: FloatingActionButton.extended(
                heroTag: Icons.delete,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Deletion"),
                        content: Text("Are you sure you want to delete this note?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.deleteNoteOnFirestore(widget.doc.id);
                              Navigator.pop(context); // Close the dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => NoteScreen()),
                              );
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                  },
                backgroundColor: Color(0xFF9DB0CE),
                label: Text("Delete"),
                icon: Icon(Icons.delete),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
