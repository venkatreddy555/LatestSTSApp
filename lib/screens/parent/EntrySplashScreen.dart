

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/screens/LoginScreen.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EntrySplashScreen extends StatefulWidget {
  const EntrySplashScreen({super.key});

  @override
  State<EntrySplashScreen> createState() => _EntrySplashScreenState();
}

class _EntrySplashScreenState extends State<EntrySplashScreen> {
  bool isShowSignInDialog = false;
  String? mtoken="";
  var UserId;

  @override
  void initState() {
    startTimer();
    getToken();
    retrieveStringValue();
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: <SystemUiOverlay>[]);
    super.initState();
  }
  retrieveStringValue() async {
    UserId = await SaveSharedPreference.getUserId();
    print("Login $UserId");
  }
  startTimer() async {
    var duration = const Duration(seconds: 5);
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
    return Scaffold(
      body: Stack(
                children: [
                  const RiveAnimation.asset(
                    "assets/images/minhduc.riv",
                    fit: BoxFit.fill,
                  ),
                  AnimatedPositioned(
                    top: isShowSignInDialog ? -50 : 0,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    duration: const Duration(milliseconds: 260),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Column(
                                children: [
                                  const SizedBox(height: 80),
                                  Image.asset(
                                    'assets/images/fks_logo.png',
                                    fit: BoxFit.contain,
                                    color: Colors.black45,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),







      //

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