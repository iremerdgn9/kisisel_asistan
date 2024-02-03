import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kisisel_asistan/auth/logIn.dart';
import 'package:kisisel_asistan/screens/calendarScreen.dart';
import 'package:kisisel_asistan/screens/newsScreen.dart';
import 'package:kisisel_asistan/screens/weatherScreen.dart';
import '/auth/signUp.dart';
import 'package:kisisel_asistan/profileScreen.dart';
import 'package:kisisel_asistan/screens/noteScreen.dart';

class Dashboard extends StatefulWidget {
  final String? adSoyad;
  final String? email;

  const Dashboard({super.key,required this.adSoyad, required this.email});

@override
_DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {


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
          MaterialPageRoute(builder: (context) => NoteScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WeatherScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen()),
        );
        break;
      default:
      // Default case
    }
  }

  late String adSoyad;
  late String email;

  @override
  void initState() {
    super.initState();
    adSoyad = widget.adSoyad ?? 'Misafir Kullanıcı';
    email = widget.email ?? 'email';
    _loadUserData(); // Firestore verilerini yükle
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Firestore'dan verileri çek
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        // Firestore'dan alınan verileri kullanarak adSoyad ve email'i güncelle
        setState(() {
          adSoyad = snapshot['adSoyad'] ?? 'Misafir Kullanıcı';
          email = snapshot['email'] ?? 'email';
        });
      }
    } catch (e) {
      print('Firestore veri çekme hatası: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70, // İstediğiniz yüksekliği ayarlayın
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
            title: Row(
              children: [
                Text(" My",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color:Color(0xFFCEA0AA) ),),
                Text("Personal",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Color(0xFF9DB0CE) ),),
                Text("Assistant",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Color(
                      0xFF364765) ),),
              ],
            ),
        ),
      body: SingleChildScrollView(
         child: SafeArea(
          bottom: true,
          child: Column(
            children:<Widget> [
              Container(
                width: width,
                height: height,
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
                      onTap: (){
                        _navigateToPage(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 1.0,horizontal: 1.0),
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
                  ],
          ),
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
                    SizedBox(height: 20), // İstenilen boşluk
          
                    Text(" ${adSoyad}",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5), // İstenilen boşluk
                  ],
                ),
                accountEmail: Column(
                  children: [
                    Text(" ${email}"),
                    SizedBox(height: 5), // İstenilen boşluk
                  ],
                ),
                currentAccountPicture: Column(
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
                          Navigator.pushNamed(context, '/HavaDurumu');
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
                          Navigator.pushNamed(context, '/HavaDurumu');
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
                            Navigator.pushNamed(context, '/Finans');
                          }
                      ),
                    ],
                  ),
                  ListTile(
                      title: new Text("En Yeniler",
                        style: TextStyle(fontSize: 18),),
                      leading: new Icon(Icons.newspaper),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/EnYeniler');
                      }
                  ),
                  ListTile(
                      title: new Text("Profilim",
                        style: TextStyle(fontSize: 18),),
                      leading: new Icon(Icons.person),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ProfileScreen(adSoyad: ''),));
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
