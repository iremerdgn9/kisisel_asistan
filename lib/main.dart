import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisisel_asistan/profileScreen.dart';
import '/dashboard.dart';
import 'auth/logIn.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget{
  const HomePage({Key? key}): super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //initialize firebase app
  Future<FirebaseApp> _initializeFirebase() async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();
    FirebaseFirestore.instance.collection("users");
    return firebaseApp;
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const LogIn();
        } else if (snapshot.hasError) {
          // Hata durumunda yapılacak işlemler
          return Center(
            child: Text("Bir hata oluştu: ${snapshot.error}"),
          );
        }
        return const Center(
          child:CircularProgressIndicator(),
        );
      },
    ),
  );
}


}

