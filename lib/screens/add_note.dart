import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kisisel_asistan/screens/noteScreen.dart';
import 'package:kisisel_asistan/screens/detail_notes.dart';
class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
String date= DateTime.now().toString();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Note'),
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
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Note Title',
                hintStyle: TextStyle(color: Color(0xFFc9c7c7)),

              ),
            ),
            SizedBox(height: 25.0,),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Note Content',
                hintStyle: TextStyle(color: Color(0xFFc9c7c7)),
              ),
            ),
            SizedBox(height: 25.0,),
            Text(date,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()async{
      if (_titleController.text.isEmpty && _mainController.text.isEmpty) {
        // Kullanıcıya uyarı göster
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Uyarı"),
              content: Text("Başlık ve içerik boş bırakılamaz."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Tamam"),
                ),
              ],
            );
          },
        );
      } else {
        // Kontrol 2: Başlık boş mu?
        if (_titleController.text.isEmpty) {
          // Kullanıcıya uyarı göster
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Uyarı"),
                content: Text("Başlık boş bırakılamaz."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Tamam"),
                  ),
                ],
              );
            },
          );
        } else {
          // Kontrol 3: İçerik boş mu?
          if (_mainController.text.isEmpty) {
            // Kullanıcıya uyarı göster
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Uyarı"),
                  content: Text("İçerik boş bırakılamaz."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Tamam"),
                    ),
                  ],
                );
              },
            );
          } else {
            FirebaseFirestore.instance.collection("notes").add({
              "note_title": _titleController.text,
              "creation_date": date,
              "note_content": _mainController.text,
            }).then((value) {
              print(value.id);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NoteScreen(),),
              );
            }).catchError((error) =>
                print("failed to add new note due to $error "));
          }
        }
      }
        },
        backgroundColor: Color(0xFF9DB0CE),
        label: Text("Save"),
        icon: Icon(Icons.save_as),
      ),
    );
  }
}
