
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ApplicationLoginState { loggedOut, loggedIn }

class ApplicationState extends ChangeNotifier {
  List<Map<dynamic, dynamic>> cartList = [];

  User? user;
  ApplicationLoginState loginState = ApplicationLoginState.loggedOut;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    FirebaseAuth.instance.authStateChanges().listen((userFir) {
      if (userFir != null) {
        loginState = ApplicationLoginState.loggedIn;
        user = userFir;
      } else {
        loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password,
      void Function(FirebaseAuthException e) errorCallBack, void Function() loginSuccess) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //  loginSuccess callback
      loginSuccess();
    } on FirebaseAuthException catch (e) {
      errorCallBack(e);
    }
  }

  Future<void> signUp(String email, String password,
      void Function(FirebaseAuthException e) errorCallBack, void Function() signUpSuccess) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //signup callback
      signUpSuccess();
    } on FirebaseAuthException catch (e) {
      errorCallBack(e);
    }
  }

  void addToCart(Map<dynamic, dynamic> product) {
    cartList.add(product);
    notifyListeners();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

