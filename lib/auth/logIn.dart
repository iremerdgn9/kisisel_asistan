import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kisisel_asistan/auth/googleSignIn.dart';
import 'package:kisisel_asistan/auth/signUp.dart';
import 'package:kisisel_asistan/dashboard.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LogIn extends StatefulWidget {
  final String? adSoyad;
  final String? email;
  const LogIn({Key? key, this.adSoyad, this.email}): super(key: key);
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _auth = AuthService();
  static Future<User?> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async {
    await Firebase.initializeApp();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      //await FirebaseFirestore.instance.collection('users').doc('userId').set({
      //'adSoyad': adSoyad,
      //'email': email,
      //});
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        print("No User Found for that email");
      }
    }
    return user;
  }


  bool _isPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


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
            children:<Widget>[
              SizedBox(height: 60,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    const Text(" Log-in", style: TextStyle(color: Color(0xFF535878), fontSize: 25,),),
                    const SizedBox(height: 50,),
                    Container(
                      padding: EdgeInsets.all(10),
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
                              padding: EdgeInsets.all(10),
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
                            child: TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                border: InputBorder.none,
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
                            ),
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
                                    User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context,);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:<Widget> [

                              Column(
                                children: [
                                  SignInButton(
                                    Buttons.google,
                                    text: 'Sign Up With Google',
                                    onPressed: () async {
                                      UserCredential? userCredential = await _auth.loginWithGoogle();
                                      if (userCredential != null) {
                                        User? user = userCredential.user;
                                        if (user != null) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => Dashboard(
                                                adSoyad: user.displayName ?? 'Misafir Kullanıcı',
                                                email: user.email ?? 'email',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(
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
