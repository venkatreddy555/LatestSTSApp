import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/screens/LoginScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';


class SplashSceen extends StatefulWidget {
  const SplashSceen({Key, key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<SplashSceen> {
  String? mtoken="";
  var UserId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    getToken();
    retrieveStringValue();

  }
  retrieveStringValue() async {
    UserId = await SaveSharedPreference.getUserId();
    print("Login $UserId");
  }


  startTimer() async {
    var duration = const Duration(seconds: 10);
    return Timer(duration, route);
  }

  route() {
  if(UserId!=null){
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }else{
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  }

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/ic_splachfks.gif'),
              fit: BoxFit.fill)),
    );
  }
void getToken() async{
    await FirebaseMessaging.instance.getToken().then((token) => {
      setState((){
        mtoken=token;
        SaveSharedPreference.saveTokenData(mtoken);
        print("my token is Splash $mtoken");
    })

    }
    );
}

}
