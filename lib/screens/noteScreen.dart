import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kisisel_asistan/dashboard.dart';
import 'package:kisisel_asistan/screens/add_note.dart';
import 'package:kisisel_asistan/screens/detail_notes.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();

  Future<void> deleteNoteOnFirestore(String noteId) async {
    await FirebaseFirestore.instance.collection("notes").doc(noteId).delete();
  }
  Future<void> editNoteOnFirestore(String noteId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance.collection("notes").doc(noteId).update(updatedData);
  }
}

class _NoteScreenState extends State<NoteScreen> {
  final Map<int, bool> _favoriteMap = {};
  bool _isFavorite = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY NOTES'),
        centerTitle: true,
        backgroundColor: Color(0xFFE9C2C5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard(adSoyad: '', email: '',),),
            );
          },
        ),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("notes").snapshots(),
                builder:(context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }

                  if(snapshot.hasData){
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:2,
                    ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) =>NoteDetail(doc),),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(18.0),
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFFEE1DD),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget> [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:<Widget> [
                                    Icon(Icons.done_all),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: Text(doc["note_title"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text(doc["creation_date"],),
                                SizedBox(height: 10,),

                                Expanded(
                                  child: Text(doc["note_content"],
                                  overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                    ListTile(
                                      leading:
                                      IconButton(
                                          icon: Icon(Icons.favorite),
                                          onPressed: () {
                                            //Navigator.push(
                                              //context,
                                              //MaterialPageRoute(builder: (context) => FavoriteScreen()),
                                            //);
                                          },
                                        ),
                                      minLeadingWidth: 2,
                                      //style: ListTileStyle(),
                                      trailing: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(Icons.check_box_outlined,color: _isFavorite? Colors.green : null),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isFavorite = !_isFavorite;
                                        });
                                      },
                                    ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if(snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Veri bulunamadı.'));
                  }
                  return Container();
                },
                ),
          ),

        ],

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AddNote(),),
          );
        },
        backgroundColor: const Color(0xFF9DB0CE),
        label: const Text("Add Note"),
        icon: const Icon(Icons.add_card),

      ),
    );

  }
}
