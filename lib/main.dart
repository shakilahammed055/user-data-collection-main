import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_me/screens/add_user.dart';
import 'package:test_me/screens/basenav_layout.dart';
import 'package:test_me/screens/profile.dart';
import 'package:test_me/screens/signin/signin.dart';
import 'package:test_me/screens/signup/signup.dart';
import 'package:test_me/screens/user/user_list.dart';
import 'package:test_me/screens/welcome/welcome.dart';
Future<void> main() async{
  init();
  runApp(const MyApp());
}

Future init()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(),
      initialRoute: WelcomeScreen.path,
      routes: {
        WelcomeScreen.path: (ctx)=> WelcomeScreen(),
        SignInScreen.path: (ctx)=> SignInScreen(),
        SignUpScreen.path: (ctx)=> SignUpScreen(),
        BaseNavLayout.path: (ctx)=> BaseNavLayout(),
        ProfileScreen.path: (ctx)=> ProfileScreen(),
        AddUserScreen.path: (ctx)=> AddUserScreen(),
        UserListScreen.path: (ctx)=> UserListScreen()
      },
    );
  }
}

