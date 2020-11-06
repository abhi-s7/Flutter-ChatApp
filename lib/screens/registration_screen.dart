import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abhishek_chat_app/components/rounded_button.dart';
import 'package:abhishek_chat_app/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
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
        /*It must be wrapped inside the body of the scaffold
          inAsyncCall accepts a boolean value and if true means it will start showing the progressBar
          Other Properties

          ModalProgressHUD(
          @required inAsyncCall: bool,
          @required child: Widget,
          opacity: double,
          color: Color,
          progressIndicator: CircularProgressIndicator,
          offset: double
          dismissible: bool,
        );
        */
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment
                .stretch, //otherwise the buttons won't be stretched
            children: <Widget>[
              Flexible(
                child: Hero(
                  //ending hero widget
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
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email.'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password.'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: () {
                  try {
                    setState(() {
                      _showProgressBar = true;
                      //because inorder to show the progressBar we must re-render the screen
                    });

                    final newUserFuture = _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    print('newUser runtimetype ${newUserFuture.runtimeType}');

                    if (newUserFuture != null) {
                      Navigator.pushReplacementNamed(context, ChatScreen.id);
                      _callSetStates(false);
                    }
                  } on FirebaseAuthException catch (e) {
                    _callSetStates(false);

                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    _callSetStates(false);

                    print(e);
                  }

                  /* Verify User email

                  FirebaseAuth auth = FirebaseAuth.instance;

                    // Get the code from the email:
                    String code = 'xxxxxxx';

                    try {
                      await auth.checkActionCode(code);
                      await auth.applyActionCode(code);

                      // If successful, reload the user:
                      auth.currentUser.reload();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-action-code') {
                        print('The code is invalid.');
                      }
                    }

                  */
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
