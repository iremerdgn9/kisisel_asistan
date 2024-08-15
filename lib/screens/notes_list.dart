import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<Map<String, dynamic>> notes = [];
  User? user;
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> snapshot =await FirebaseFirestore.instance.collection('notes')
            .where('userId', isEqualTo: user.uid)
            .get();

        setState(() {
          notes = snapshot.docs.map((doc) {
            final data = doc.data();
            DateTime creationDate = DateTime.now(); // Default value
            if (data['creation_date'] is Timestamp) {
              creationDate = (data['creation_date'] as Timestamp).toDate();
            } else if (data['creation_date'] is String) {
              creationDate = DateTime.parse(data['creation_date'] as String);
            }
            return {
              'note_title': data['note_title'] ?? 'No Title',
              'creation_date': creationDate,
              'note_content': data['note_content'] ?? 'No Content',
              //'creation_date': (data['creation_date'] as Timestamp).toDate(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Firestore veri çekme hatası: $e');
    }
  }
  @override
  Widget build(BuildContext context) {

    return  StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No notes available'));
        }
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                    final noteTitle = doc['note_title'] ?? 'No Title';
                    final creationDate = doc['creation_date'] != null
                        ? _parseCreationDate(doc['creation_date'])
                        : DateTime.now();
                    final noteContent = doc['note_content'] ?? 'No Content';
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Icon(
                          _getIcon('default'),
                          color: Colors.pink,
                        ),
                        title: Text(noteTitle),
                        subtitle: Text(
                          'Date: ${DateFormat('dd/MM/yyyy').format(creationDate)}\nContent: $noteContent',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return Center(child: Text('No notes available'));
      },
    );
  }
  DateTime _parseCreationDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      return DateTime.parse(date);
    } else {
      return DateTime.now();
    }
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'sports':
        return Icons.sports_soccer;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      default:
        return Icons.note;
    }
  }
}
