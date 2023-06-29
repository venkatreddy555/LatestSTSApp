import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:permission_handler/permission_handler.dart';

import '../webservices/API.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<LoginScreen> {
  final _contactEditingController = TextEditingController();
  var token = '';

  @override
  void initState() {
    super.initState();
    retrieveStringValue();
    requestMultiplePermissions();
  }

  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else {
      _logindetails();
      // await Navigator.pushNamed(context, '/Otp',
      //     arguments: '${_contactEditingController.text}');

      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Otp()));
    }
  }

  retrieveStringValue() async {
    token = await SaveSharedPreference.getTokenData();
    print("Login Token $token");
  }

  Future _logindetails() async {
    var data = {
      'MobileNumber': _contactEditingController.text.toString(),
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
      var RoleId=body['RoleId'].toString();
      var EmployeeId=body['EmployeeId'].toString();
      var BranchId=body['BranchId'].toString();
          SaveSharedPreference.saveMobileNumber(MobileNumber);
      if (responsecode == "0") {
        SaveSharedPreference.saveUserId(UserId);
        SaveSharedPreference.saveUsername(Username);
        SaveSharedPreference.saveRoleId(RoleId);
        SaveSharedPreference.saveEmployeeId(EmployeeId);
        SaveSharedPreference.saveBranchId(BranchId);
        await Navigator.pushNamed(context, '/Otp',
            arguments: {'MobileNumber':MobileNumber,'OTP':OTP});

      }

  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // show the snackbar with some text
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('The System Back Button is Deactivated')));
      return false;
    },
    child:Scaffold(
      body: Center(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan),
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _contactEditingController,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10)),
                        prefix: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '(+91)',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan),
                          ),
                        ),
                        // suffixIcon: const Icon(
                        //   Icons.check_circle,
                        //   color: Colors.white,
                        //   size: 32,
                        // ),
                      ),
                      maxLength: 10,
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          clickOnLogin(context);
                          // Navigator.of(context).push(
                          //   // MaterialPageRoute(builder: (context) => Otp()),
                          // );
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(const Color.fromRGBO(23, 171, 144, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Send',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
  void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.manageExternalStorage
    ].request();
    print("location permission: ${statuses[Permission.location]}, "
        "storage permission: ${statuses[Permission.storage]}");
  }
}
