import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  final _auth = FirebaseAuth.instance;
  Future<UserCredential?> loginWithGoogle() async{
    try{
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      return await _auth.signInWithCredential(credential);

    }catch (e){
      print(e.toString());
    }
    return null;
  }
}

