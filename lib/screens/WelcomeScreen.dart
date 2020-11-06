import 'package:abhishek_chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:abhishek_chat_app/screens/login_screen.dart';
import 'package:abhishek_chat_app/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  //Here STATIC is a modifier which tell the variable is binded/associated with the class
  //thus we no longer have to create an object of this class to access this variable
  //thus it will be very helpful for using named route
  /*
    And in order to use const with a instance variable of class we must specify static
   */

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    // with SingleTickerProviderStateMixin {
    with
        TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationController2;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _doAnimations();
    _doTweenAnimations();
  }

  void _doAnimations() {
    _animationController = AnimationController(
      duration: Duration(seconds: 1), //tells how long
      vsync: this,
      /*
          this is where we provide the TickerProvider
          i.e. the thing that can be acted as the Ticker for our AnimatinoController
          which means that we have enable _WelcomeScreenState class to act as a TickerProvider
    
          usually it is state object i.e. WelcomeScreenState
          Therefore inherit SingleTickerProviderStateMixin
          •	It is the ability to act as a single mixing
    
          	This- keyword to reference the object made from the class in the classes own code
    
          */
      //upperBound: 100.0//cannot use with Curve
    );

    // Curve represent the type of animations - Consider curve as the curve in a graph.
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.bounceInOut);
    // parent - to what the curve should be applied
    // :::::::: Note:: whle using curves then we cannot use upperBound more than 1 because curves expects value from 0 to 1

    _animationController.forward(); //this will proceed animation to forward
    //By default AnimationController will animate a number and with every tick of the ticker it will increase the number from 0 to 1
    //in one seconds we get 60 ticks and animate in 60 steps in 1 seconds

    //_animationController.reverse(from: 1.0);

    //listener to listen to the animation & it accepts a callback
    _animationController.addListener(() {
      //now we can listen to the value of the controller
      print(_animationController.value);
      setState(() {
        //then it will change the background color because it should re-render when _animationController value changes
      });
    });

    /*
    To check the status of the animation use addStatusListener() which will listen to the status of the animation
    End of the reverse animation - dismissed
    End of the forward animation - completed
    */

    /*
    _animationController.addStatusListener((status) {
      print(status);
      if (status == AnimationStatus.completed) {
        _animationController.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    */

    //even if the screen is dismissed the animaiton take some resourse therefore it is important to dispose it
  }

  void _doTweenAnimations() {
    // animations that works on two values
    // predefined tween animation that goes in b/w value
    //also border radius tween, alignment tween

    _animationController2 =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_animationController2); //this animate() returns an animation

    _animationController2.forward();
    _animationController2.addListener(() {
      setState(() {
        print(_animation.value);
      });
    });
  }

  // Pre-packaged animation

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    _animationController2.dispose();
    //i.e. when the screen is destroyed then dispose the method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red.withOpacity(_animationController.value),
      backgroundColor: _animation.value,
      //backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[
              Hero(
                //this is the Hero Tag to use Hero Animation
                tag: 'logo', //starting hero widget
                child: Container(
                  child: Image.asset('images/logo.png'),
                  //height: 60.0,
                  height: _animationController.value * 100,
                ),
              ),
              TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 600),
                totalRepeatCount: 4,
                //it expects a List of String
                text: ['Flash Chat'],
                //'${_animationController.value.toInt()*100}%',//using controller value to display the percentage(0-100%)
                //style property is same just name is textStyle
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
                /*
                Other properties
                  repeatForever: true, //this will ignore [totalRepeatCount]
                  pause: Duration(milliseconds:  1000),
                  text: ["do IT!", "do it RIGHT!!", "do it RIGHT NOW!!!"],
                  textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  pause: Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true
                */
              ),
            ]),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              //************LOGIN Button************ */
              title: 'Log In',
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              //************REGISTRATION Button************ */
              title: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
