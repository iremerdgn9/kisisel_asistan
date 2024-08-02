import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kisisel_asistan/screens/noteScreen.dart';
import 'package:kisisel_asistan/screens/detail_notes.dart';
class EditNote extends StatefulWidget {
   final QueryDocumentSnapshot doc;
   EditNote(this.doc,{super.key});

  @override
  State<EditNote> createState() => _EditNoteState();


   Future<void> editNoteOnFirestore(String noteId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance.collection("notes").doc(noteId).update(updatedData);
  }
}

class _EditNoteState extends State<EditNote> {
  bool _isEditEnabled = false;
  String _noteTitle = '';
  String _noteContent = '';
  String date= DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    _noteTitle = widget.doc['note_title'];
    _noteContent = widget.doc['note_content'];
  }
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()async{
          if (_titleController.text.isEmpty && _mainController.text.isEmpty) {
            // Kullanıcıya uyarı göster
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Uyarı"),
                  content: const Text("Başlık ve içerik boş bırakılamaz."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Tamam"),
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
                Map<String, dynamic> updatedData = {
                  'note_title': _titleController.text,
                  'note_content': _mainController.text,
                  "creation_date": date,
                };
                await widget.editNoteOnFirestore(widget.doc.id, updatedData);
                setState(() {
                  _isEditEnabled = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Note edited successfully."),
                    ),
                  );
                  print(widget.doc.id);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const NoteScreen(),),
                  );
                });
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
