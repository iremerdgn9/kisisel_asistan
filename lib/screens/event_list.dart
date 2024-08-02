
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListWidget extends StatefulWidget {

  const EventListWidget({super.key});

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {

  List<Map<String, dynamic>> events = [];


  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('events')
            .where('userId', isEqualTo: user.uid)
            .get();

        setState(() {
          events = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'event_date': (data['event_date'] as Timestamp).toDate(),
              'event_title': data['event_title'],
              'event_descp': data['event_descp'],
              'event_time': data['event_time'],
              'event_icon': data['event_icon'] ?? 'default',
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Firestore veri çekme hatası: $e');
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
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
                        children: [
                          if (events.isNotEmpty)
                            ...events.map((event) => ListTile(
                              leading: Icon(_getIcon(event['event_icon']),
                                color: Colors.pink,
                              ),
                              title: Text(event['event_title']),
                              subtitle: Text('${event['event_descp']}\n'
                                  'Tarih: ${DateFormat('dd/MM/yyyy').format(event['event_date'])}\n'
                                  'Saat: ${event['event_time']}'),
                            ))
                          else
                            Text('No events available'),
                        ],

      );

  }
  }
