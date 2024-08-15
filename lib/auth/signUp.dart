import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kisisel_asistan/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  static Future<User?> createUserWithEmailAndPassword(
      {required String adSoyad,required String email, required String password, required BuildContext context}) async {
    await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "${dotenv.env["F_APIKEY"]}",
      appId: "${dotenv.env["APP_ID"]}",
      messagingSenderId: "${dotenv.env["MS_ID"]}",
      projectId: "${dotenv.env["PROJECT_ID"]}",
    ),);
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'adSoyad': adSoyad,
        'email': email,
      });
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        print("No User Found for that email");
      }
    }
    return user;
  }

  bool _isPasswordVisible = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _adSoyadController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
    Widget build(BuildContext context) {

      return Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(" Sign-Up", style: TextStyle(color: Color(
                          0xFF535878), fontSize: 25,),),
                      const SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF9DB0CE),
                              blurRadius: 20,
                              offset: Offset(1, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _adSoyadController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Ad-Soyad",
                                hintStyle: TextStyle(color: Color(0xFFc9c7c7)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter your ad-soyad";
                                }
                                return null;
                              },

                            ),

                            const SizedBox(height: 10,),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Color(0xFFc9c7c7)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter your email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Color(0xFFc9c7c7)),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                },
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter your password";
                                } else {
                                  if (value.length < 6) {
                                    return "Password should be at least 6 characters";
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10,),

                            Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFFB8D8E9),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      User? user = await createUserWithEmailAndPassword(adSoyad: _adSoyadController.text,email: _emailController.text, password: _passwordController.text, context: context);
                                      print(user);
                                      if(user != null){
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard(adSoyad: '', email: '',),));
                                      }
                                    },
                                    child: const Text(
                                      "Create Account", style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}



