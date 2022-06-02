import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/helpers/firebase_helper.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/inventory.dart';
import 'package:liabrary/pages/pages/login_page.dart';


import 'package:uuid/uuid.dart';

var uuid = const Uuid();
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // to ensure initialized WidgetsFlutterBinding
  await Firebase
      .initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyAdIs-95B3gA6uYg62uNOq6fokB8TPMrlA", // Your apiKey
      appId: "1:1085559114804:web:bcaba273b475a013a70e61", // Your appId
      messagingSenderId: "1085559114804", // Your messagingSenderId
      projectId: "liabrary-5f95c", // Your projectId
    ),
      ); // to wait for firebase to initialize the app from console.firebase.google.com

  User? currentUser = FirebaseAuth.instance
      .currentUser; // to store info about logged in user (if any) i.e. email/password

  if (currentUser != null) {
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InventoryPage(userModel: userModel, firebaseUser: firebaseUser),);
  }
}
