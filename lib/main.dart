import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kisisel_asistan/services/message_api.dart';
import 'package:kisisel_asistan/services/push_notifications.dart';
import 'auth/logIn.dart';
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: '${dotenv.env["F_APIKEY"]}',
        appId: '${dotenv.env["APP_ID"]}',
        messagingSenderId: '${dotenv.env["MS_ID"]}',
        projectId: '${dotenv.env["PROJECT_ID"]}')
  );
  await MessageApi().initNotifications();
      runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      home: const HomePage(),
      routes: {
        PushNotification.route: (context) => const PushNotification(),
      },

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
    return FutureBuilder(
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
        return const Scaffold(
        body:  Center(
          child:CircularProgressIndicator(),
        ),
        );
      },
  );
}
}

