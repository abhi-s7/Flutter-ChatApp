import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/WelcomeScreen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //this gives darder theme
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //     body1: TextStyle(color: Colors.black54),
      //   ),
      // ),
      initialRoute: WelcomeScreen.id,
      //this way we don't have to create object of WelcomeScreen as we have specified id
      //otherwise we had to do.. WelcomeScreen().id
      //which means we have to create the object of the class just to access the variable id
      //this way were whole new WelcomeScreen just to be able to access id
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      //the other way
      /*
      routes: {
        '/': (context) => WelcomeScreen(),//but one of them have to be '/<nothing>' which tells that it is home
        '/login': (context) => LoginScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/chat': (context) => ChatScreen(),
      },
      */
    );
  }
}
