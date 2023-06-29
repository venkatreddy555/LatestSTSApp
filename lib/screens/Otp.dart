import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:schooltrackingsystem/widgets/custom_button.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});


  @override
  State<Otp> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<Otp> {
  String smsOTP = "";
  String errorMessage = '';
  String Mobilenumber='';
  String OTP='';
  var token = '';


  @override
  void initState() {
    super.initState();
    retrieveStringValue();
  }

  Future<void> clickOnLogin(BuildContext context) async {
      _logindetails();
  }


  @override
  Widget build(BuildContext context) {
    final routeData =
    ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    Mobilenumber = routeData['MobileNumber'].toString();
    OTP = routeData['OTP'].toString();

    return WillPopScope(
        onWillPop: () async {
      // show the snackbar with some text
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('The System Back Button is Deactivated')));
      return false;
    },
    child:Scaffold(
      // resizeToAvoidBottomInset : false,
      // backgroundColor: Colors.cyan.shade100,
      body: SingleChildScrollView(
        child: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.fromRGBO(23, 171, 144, 1),
          Color.fromRGBO(243, 246, 249, 0.6),
          Color.fromRGBO(23, 171, 144, 0.4),
        ],
    )),
        child: Center(

          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(20.0),
                  child:   Image.asset(
                    'assets/images/fks_logo.png',
                    fit: BoxFit.contain,
                    width: 150,
                    height: 65,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 70),
                const Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter the OTP send to your phone number",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Pinput(
                  length: 5,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.cyan.withAlpha(100),
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(23, 171, 144, 1)
                    ),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      smsOTP = value;
                    });
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomButton(
                    text: "Verify",
                    onPressed: () {
                      if (smsOTP != null) {
                        verifyOtp();
                        // verifyOtpyOtp(context, otpCode!);
                      } else {
                        showSnackBar(context, "Enter 6-Digit code");
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Didn't receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(height: 10),

                 InkWell(
                  onTap:(){
                    clickOnLogin(context);
                  },
                  child: const Text(
                     "Resend New Code",
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.cyan,
                     ),
                   ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),),);
  }
  //Method for verify otp entered by user
  Future<void> verifyOtp() async {
    if (smsOTP == '') {
      showAlertDialog(context, 'please enter 5 digit otp');
      return;
    } else if(smsOTP==OTP){
      try {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
      } catch (e) {
        handleError(e as PlatformException);
      }
    }else{
      showSnackBar(context, "Invalid Otp");
      return;
    }

  }
  //Method for handle the errors
  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  retrieveStringValue() async {
    token = await SaveSharedPreference.getTokenData();
    Mobilenumber = await SaveSharedPreference.getMobileNumber();
    print("otp screen Token $token");
  }

  Future _logindetails() async {
    var data = {
      'MobileNumber':Mobilenumber,
      'DeviceToken': token
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STSLogin/VerifyMobileNumber');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage=body['Message'].toString();
    var OTP=body['OTP'].toString();
    print("OTP $OTP");
    var MobileNumber=body['MobileNumber'].toString();
    var Username=body['Username'].toString();
    var UserId=body['UserId'].toString();
    SaveSharedPreference.saveMobileNumber(MobileNumber);
    if (responsecode == "0") {
      SaveSharedPreference.saveUserId(UserId);
      SaveSharedPreference.saveUsername(Username);


    }

  }
}

