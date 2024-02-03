import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kisisel_asistan/auth/signUp.dart';
import 'package:kisisel_asistan/dashboard.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}): super(key: key);
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  static Future<User?> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async {
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey:
      "AIzaSyC5o8T9tzN_epew6XVZCZKJhUp2lNp0M8A",
      appId:
      "1:959087843995:android:211db8eefb37184a22443e",
      messagingSenderId: "959087843995",
      projectId: "kisisel-asistan-login",
    ),);
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        print("No User Found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              const SizedBox(height: 120,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    const Text(" Log-in", style: TextStyle(color: Color(0xFF535878), fontSize: 25,),),
                    const SizedBox(height: 40,),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow:[
                          BoxShadow(
                            color: Color(0xFF9DB0CE),
                            blurRadius:20,
                            offset: Offset(1,10),
                          ),
                        ],
                      ),

                      child: Column(
                        children:<Widget> [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  color: Color(0xFFb5b5b5),
                                )),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Color(0xFFc9c7c7)),
                                ),
                              )
                          ),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  color: Color(0xFFb5b5b5),
                                )),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Color(0xFFc9c7c7)),
                                ),
                              )
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                },
                                child: const Text("Forgot Password?", style:TextStyle(color: Color(0xFFE9C2C5),),
                                ),),
                            ],
                          ),

                          const SizedBox(height: 30,),

                          Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xFFB8D8E9),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);
                                    print(user);
                                    if(user != null){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Dashboard(adSoyad: '', email: '',),));
                                    }
                                  },
                                  child: const Text(
                                    "Login", style: TextStyle(color:Colors.white,fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {

                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const SignUp(),));

                                },
                                child: const Text("Create Account", style:TextStyle(color: Color(
                                    0xFFB68277),),
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                height: 350,
                width: width,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children:<Widget>[
                    Positioned(
                      bottom: 100.0,
                      width: 200.0,
                      height: 200,
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/note-taking.png'),
                              fit: BoxFit.fill,
                            )
                        ),
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