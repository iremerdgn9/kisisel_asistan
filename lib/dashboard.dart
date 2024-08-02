import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kisisel_asistan/screens/calendarScreen.dart';
import 'package:kisisel_asistan/screens/event_list.dart';
import 'package:kisisel_asistan/screens/newsScreen.dart';
import 'package:kisisel_asistan/screens/notes_list.dart';
import 'package:kisisel_asistan/screens/weatherScreen.dart';
import 'package:kisisel_asistan/profileScreen.dart';
import 'package:kisisel_asistan/screens/noteScreen.dart';

class Dashboard extends StatefulWidget {
  final String? adSoyad;
  final String? email;

  const Dashboard({super.key,required this.adSoyad, required this.email});

@override
_DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard>{


  List<String> imgData = [
    "assets/images/notes.png",
    "assets/images/newspaper.png",
    "assets/images/cloudy-day.png",
    "assets/images/timetable.png",
  ];
  List<String> titles = [
    "Notlar",
    "Haberler",
    "Hava Durumu",
    "Takvim"];

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoteScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeatherScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarScreen()),
        );
        break;
      default:
      // Default case
    }
  }


  late String adSoyad;
  late String email;
 // List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    adSoyad = widget.adSoyad ?? 'Misafir Kullanıcı';
    email = widget.email ?? 'email';
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if(snapshot.exists){
        setState(() {
          adSoyad = snapshot.data()?['adSoyad'] ?? 'Misafir Kullanıcı';
          email = snapshot.data()?['email'] ?? 'email';
        });
      }else{
          print('kullanıcı dökümanı bulunamadı');
        }
    }} catch (e) {
      print('Firestore veri çekme hatası: $e');
    }
  }



bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.pink;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFFFEDEA),
        leading: Builder(
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.all(18.0),
              icon: Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
            title: const Row(
              children: [
                Text(" My",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color:Color(0xFFCEA0AA) ),),
                Text("Personal",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color:Color(0xFF9DB0CE) ),),
                Text("Assistant",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color:Color(
                      0xFF364765) ),),
              ],
            ),
        ),
      body: SafeArea(
        child: Column(
          children:<Widget> [
            Container(
              width: width,
              //height: 40,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFCEA0AA),
                borderRadius: BorderRadius.circular(15)
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 5,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: imgData.length,
                itemBuilder: (context,index) {
                    return InkWell(
                      onTap: () {
                        _navigateToPage(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(imgData[index],
                                width: 100,),
                              Text(titles[index]),
                            ],
                          ),
                        ),
                      ),
                    );
                },
                  ),
            ),

            DefaultTabController(
              length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 6,
                              ),
                            ]),
                        child: TabBar(
                          labelColor: Color(0xFF364765),
                          unselectedLabelColor: Color(0xFF9DB0CE),
                          indicatorColor: Colors.amber,
                          tabs: <Widget>[
                            Tab(text: "Etkinlikler"),
                            Tab(text: "Notlar"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.3,
                        child: TabBarView(
                            children: <Widget>[
                              const SingleChildScrollView(
                                  child: EventListWidget()),
                              SingleChildScrollView(
                                  child: NoteList()),
                            ],
                          ),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        elevation: 3.0,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Color(0xFF5E7E9D), // UserAccountsDrawerHeader'ın arka plan rengi
          ),
                currentAccountPictureSize: Size.square(55.0),
                accountName: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
          
                    Text(" ${adSoyad}",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5),
                  ],
                ),
                accountEmail: Column(
                  children: [
                    Text(" ${email}"),
                    SizedBox(height: 5),
                  ],
                ),
                currentAccountPicture: const Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/personal-assistant.png"),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.tag_faces, size: 30.0,),
                    tooltip: 'Smile',
                    onPressed: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: new Text("Ana Sayfa",
                      style: TextStyle(fontSize: 18),),
                    trailing: new Icon(Icons.arrow_right),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Dashboard(adSoyad: '', email: '',),));
                    },
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.category_outlined),
                    title: Text("Kategoriler",
                      style: TextStyle(fontSize: 18),),
                    trailing: Icon(Icons.arrow_drop_down_circle_outlined),
                    children: [
                      ListTile(
                        title: new Text("Notlarım",
                          style: TextStyle(fontSize: 18),),
                        leading: Icon(Icons.note_alt_sharp),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> NoteScreen(),));
                        },
                      ),
                      Divider(
                        height: 0.1,
                      ),
                      ListTile(
                        title: new Text("Takvim",
                          style: TextStyle(fontSize: 18),),
                        leading: Icon(Icons.calendar_month),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> CalendarScreen(),));
                        },
                      ),
                      Divider(
                        height: 0.1,
                      ),
                      ListTile(
                        title: new Text("Hava Durumu",
                          style: TextStyle(fontSize: 18),),
                        leading: Icon(Icons.wb_sunny),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> WeatherScreen(),));
                        },
                      ),
                      Divider(
                        height: 0.1,
                      ),
                      ListTile(
                          title: new Text("Haberler",
                            style: TextStyle(fontSize: 18),),
                          leading: new Icon(Icons.newspaper),
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> NewsScreen(),));
                          }
                      ),
                    ],
                  ),
                 /* ListTile(
                      title: new Text("Favorilerim",
                        style: TextStyle(fontSize: 18),),
                      leading: new Icon(Icons.newspaper),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/Favoriler');
                      }
                  ), */
                  ListTile(
                      title: new Text("Profilim",
                        style: TextStyle(fontSize: 18),),
                      leading: new Icon(Icons.person),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ProfileScreen(adSoyad: ''),));
                    }
                  ),
          
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
