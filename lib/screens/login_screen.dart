import 'package:abhishek_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abhishek_chat_app/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool _showProgressBar = false;

  _callSetStates(value) {
    setState(() {
      _showProgressBar = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showProgressBar,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                //this means that if size is availabel the it will take whole 200.0
                //but if the size is limited then it will adjust its height and there will be no overflow
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType
                    .emailAddress, //to make the keyboard compatible for the email i.e. it displays @ and .com
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Email',
                  //copy with property is used to override the existing key in the widget
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText:
                    true, //this will protect the text and make it like password
                onChanged: (value) {
                  password = value;
                },
                //to override some fields that we want to specity in theme use .copyWith()
                //it will copy whole thing but it will change what so ever we pass in .copyWith()
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password.'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Log in',
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    try {
                      _callSetStates(true);

                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      //UserCredential
                      print('User RuntimeType ${user.runtimeType}');

                      if (user != null) {
                        Navigator.pushReplacementNamed(context, ChatScreen.id);
                      }
                    } on FirebaseAuthException catch (e) {
                      _callSetStates(false);

                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    } catch (e) {
                      _callSetStates(false);
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
