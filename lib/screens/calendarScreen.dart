import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final eventsCollection = FirebaseFirestore.instance.collection('events');

  Future<void> loadEvents() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Firestore'dan verileri çek
        final eventsSnapshot = await eventsCollection.where('userId', isEqualTo: user.uid).get();

        setState(() {
          mySelectedEvents = {};
          for (var doc in eventsSnapshot.docs) {
            final eventDate = (doc.data()['event_date'] as Timestamp).toDate();
            final eventTitle = doc.data()['event_title'] as String;
            final eventDescp = doc.data()['event_descp'] as String;
            final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);
            if (mySelectedEvents[formattedDate] == null) {
              mySelectedEvents[formattedDate] = [];
            }
            mySelectedEvents[formattedDate]?.add({
              "event_title": eventTitle,
              "event_descp": eventDescp,
            });
          }
        });
      }}catch (e){
      print('Firestore veri çekme hatası: $e');
    }
  }

// Add event to Firestore (replace with your logic)
  Future<void> addEventToFirestore(DateTime date,String title, String descp) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final eventRef = eventsCollection.doc();
      await eventRef.set({
        'userId': user.uid,
        'event_date': Timestamp.fromDate(date),
        'event_title': title,
        'event_descp': descp,
      });
    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  Map<String,List> mySelectedEvents = {};

  TextEditingController titleController = TextEditingController();
  TextEditingController descpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descpController = TextEditingController();
    _selectedDate = _focusedDay;
    loadEvents();
  }

  List _listOfDayEvents(DateTime dateTime){
    if(mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null){
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    }else{
      return [];
    }

  }

  _showAddEventDialog() async{
    await showDialog(
        context: context,
        builder: (context)=> AlertDialog(
      title: const Text("Add new event",textAlign: TextAlign.center,),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          TextField(
            controller: descpController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:()=> Navigator.pop(context),
          child: Text('Cancel'),),
        TextButton(child: Text('Add event'),
          onPressed:() async {
          if(titleController.text.isEmpty && descpController.text.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Başlık ve açıklama giriniz..'),
              duration: Duration(seconds: 2),),
            );
            return;
          }else {
            final eventTitle = titleController.text;
            final eventDescp = descpController.text;

            setState(() {
              if(mySelectedEvents[DateFormat('yyyy-MM-dd')
                  .format(_selectedDate!)] != null) {
                mySelectedEvents[DateFormat('yyyy-MM-dd').format(_selectedDate!)]?.add({
                  "event_title": eventTitle,
                  "event_descp": eventDescp,
                });
              } else {
                mySelectedEvents[DateFormat('yyyy-MM-dd').format(_selectedDate!)]=[
                  {"event_title": eventTitle, "event_descp": eventDescp}];
              }
            });
            await addEventToFirestore(_selectedDate!, eventTitle, eventDescp);

            titleController.clear();
            descpController.clear();
            Navigator.pop(context);
            return;
          }
        },),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE9C2C5),
        centerTitle: true,
        title: const Text('Takvim ve Olaylar'),
      ),
      body: SingleChildScrollView(
        child: Column(
        children:<Widget>[
          TableCalendar(focusedDay: _focusedDay, firstDay: DateTime(2020), lastDay: DateTime(2030),
              calendarFormat: _calendarFormat,
        
              onDaySelected: (selectedDay,focusedDay){
            if(!isSameDay(_selectedDate,selectedDay)){
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay;
              });
            }
              },
              selectedDayPredicate: (day){
                return isSameDay(_selectedDate,day);
              },
            onFormatChanged: (format){
            if(_calendarFormat != format){
              setState(() {
                _calendarFormat = format;
              });
            }
            },
        
            onPageChanged: (focusedDay){
            _focusedDay = focusedDay;
            },
            eventLoader: _listOfDayEvents,
          ),
        
          if(_selectedDate != null)
          ..._listOfDayEvents(_selectedDate!).map(
                  (myEvents) => ListTile(
                    leading: const Icon(
            Icons.done_outline,
            color: Colors.pink,
          ),
          title: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text('Event Title:  ${myEvents['event_title']}'),
          ),
          subtitle: Text('Description:  ${myEvents['event_descp']}'),
                  ),
          ),
            ],
            ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF9DB0CE),
          onPressed:() =>
            _showAddEventDialog(),
          label: const Text('Add Event')),
    );
  }
}