import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future registerUserWithEmailPassword(
      String name, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        await DatabaseService(uid:user.uid).savingUserData(name, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
  //login
  Future loginWithUserNameAndEmail(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  //signOut
  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmail("");
      await HelperFunction.saveUserName("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
