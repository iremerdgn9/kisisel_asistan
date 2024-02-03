import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisisel_asistan/auth/logIn.dart';
import 'package:kisisel_asistan/dashboard.dart';
import '/auth/signUp.dart';

class ProfileScreen extends StatelessWidget {
  final String? adSoyad;

  const ProfileScreen({super.key, required this.adSoyad});

  Future<String> _getAdSoyadFromFirestore(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return snapshot.data()?['adSoyad'] ?? adSoyad ?? 'Misafir Kullanıcı';
    } catch (e) {
      print('Firestore veri çekme hatası: $e');
      return adSoyad ?? 'Misafir Kullanıcı';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profilim'),
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
      body: FutureBuilder<String>(
        future: _getAdSoyadFromFirestore(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      colors: [
                        Color(0xFFCEA0AA),
                        Color(0xFFE9C2C5),
                        Color(0xFFFEE1DD),
                        Color(0xFF9DB0CE),
                      ],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  child: const Column(
                    children: <Widget>[
                      SizedBox(height: 40,),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/images/human.png"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Text("Hoşgeldiniz, ${snapshot.data}",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                ),
                SizedBox(height: 100,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFB8D8E9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LogIn(),));
                        },
                        child: const Text(
                          "Sign Out", style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator(); // Veri henüz yüklenmediyse gösterilecek widget
          }
        },
      ),
    );
  }
}






