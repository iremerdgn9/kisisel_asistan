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
        final eventsSnapshot = await eventsCollection.where('userId', isEqualTo: user.uid).get();

        setState(() {
          mySelectedEvents = {};
          for (var doc in eventsSnapshot.docs) {
            final eventDate = (doc.data()['event_date'] as Timestamp).toDate();
            final eventTitle = doc.data()['event_title'] as String;
            final eventDescp = doc.data()['event_descp'] as String;
            final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);
            final eventTime = doc.data()['event_time'] as String;
            if (mySelectedEvents[formattedDate] == null) {
              mySelectedEvents[formattedDate] = [];
            }
            final eventTimeSplit = eventTime.split(':');
            final eventHour = int.parse(eventTimeSplit[0]);
            final eventMinute = int.parse(eventTimeSplit[1]);
            final eventDateTime = DateTime(eventDate.year, eventDate.month, eventDate.day, eventDate.hour, eventDate.minute);

            mySelectedEvents[formattedDate]?.add({
              "event_title": eventTitle,
              "event_descp": eventDescp,
              "event_time": eventDateTime,
              "event_icon": doc.data()['event_icon'] ?? 'default',
            });
          }
        });
      }}catch (e){
      print('Firestore veri çekme hatası: $e');
    }
  }

  Future<void> addEventToFirestore(DateTime date,String title, String descp,TimeOfDay time) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final eventRef = eventsCollection.doc();
      await eventRef.set({
        'userId': user.uid,
        'event_date': Timestamp.fromDate(date),
        'event_title': title,
        'event_descp': descp,
        'event_time': '${time.hour}:${time.minute}',
        'event_icon': _selectedIcon,

      });

    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  Map<String,List> mySelectedEvents = {};
  String _selectedIcon = 'default';
  TimeOfDay? _selectedTime;


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
    //final selectedDateKey = DateFormat('yyyy-MM-dd').format(dateTime);
    if(mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null){
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    }else{
      return [];
    //final events = mySelectedEvents[selectedDateKey];

    //return events != null ? List.from(events) : [];

  }}

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
          ListTile(
            title: const Text('Select Time'),
            trailing: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
            subtitle: _selectedTime != null
                ? Text('Selected Time: ${_selectedTime!.format(context)}')
                : const Text('No time selected'),
          ),
          const Text('Select Icon'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.sports_soccer),
                color: _selectedIcon == 'sports' ? Colors.blue : Colors.black,
                onPressed: () {
                  setState(() {
                    _selectedIcon = 'sports';
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.work),
                color: _selectedIcon == 'work' ? Colors.blue : Colors.black,
                onPressed: () {
                  setState(() {
                    _selectedIcon = 'work';
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.school),
                color: _selectedIcon == 'school' ? Colors.blue : Colors.black,
                onPressed: () {
                  setState(() {
                    _selectedIcon = 'school';
                  });
                },
              ),
              // Add more icons as needed
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:()=> Navigator.pop(context),
          child: Text('Cancel'),),
        TextButton(child: Text('Add event'),
          onPressed:() async {
          if(titleController.text.isEmpty && descpController.text.isEmpty || _selectedTime == null){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Başlık, açıklama ve saat giriniz..'),
              duration: Duration(seconds: 2),),
            );
            return;
          }else {
            final eventTitle = titleController.text;
            final eventDescp = descpController.text;
            final selectedTime = _selectedTime!;

            setState(() {
              if(mySelectedEvents[DateFormat('yyyy-MM-dd')
                  .format(_selectedDate!)] != null) {
                mySelectedEvents[DateFormat('yyyy-MM-dd').format(_selectedDate!)]?.add({
                  "event_title": eventTitle,
                  "event_descp": eventDescp,
                  "event_time": selectedTime,
                });
              } else {
                mySelectedEvents[DateFormat('yyyy-MM-dd').format(_selectedDate!)]=[
                  {"event_title": eventTitle, "event_descp": eventDescp,"event_time": DateTime(
              _selectedDate!.year,
              _selectedDate!.month,
              _selectedDate!.day,
              selectedTime.hour,
              selectedTime.minute,
              ),
              "event_icon": _selectedIcon,
                  }];
              }
            });
            await addEventToFirestore(_selectedDate!, eventTitle, eventDescp,selectedTime);

            titleController.clear();
            descpController.clear();
            _selectedTime = null;
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
          ..._listOfDayEvents(_selectedDate!).map((myEvents) {
          if (myEvents['event_icon'] != null &&
              myEvents['event_time'] != null) {
            return ListTile(
              leading: Icon(
                _getIcon(myEvents['event_icon'] ?? ''),
                color: Colors.pink,
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text('Event Title:  ${myEvents['event_title']}'),
              ),
              subtitle: Text('Description:  ${myEvents['event_descp']}\n'
                  'Time: ${DateFormat('HH:mm').format(
                  (myEvents['event_time']))}'),
            );
          }else{
            return SizedBox.shrink();
          }
    },
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

}