import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schooltrackingsystem/datamodelclass/MastersDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/ViewAllRoutesEditDataModelClass.dart';
import 'package:schooltrackingsystem/screens/AddNewRoute.dart';
import 'package:schooltrackingsystem/screens/AdminApprovedRequestList.dart';
import 'package:schooltrackingsystem/screens/ChildrensProfileList.dart';
import 'package:schooltrackingsystem/screens/LiveTracking.dart';
import 'package:schooltrackingsystem/screens/LoginScreen.dart';
import 'package:schooltrackingsystem/screens/NotificationsList.dart';
import 'package:schooltrackingsystem/screens/ParentRequestStop.dart';
import 'package:schooltrackingsystem/screens/QRCodeScanner.dart';
import 'package:schooltrackingsystem/screens/Trackingscreen.dart';
import 'package:schooltrackingsystem/screens/admin/ParentRequestList.dart';
import 'package:schooltrackingsystem/screens/admin/RemovePointfromRoute.dart';
import 'package:schooltrackingsystem/screens/admin/ViewAndEditRoutesList.dart';
import 'package:schooltrackingsystem/screens/driver/IDCardMissingRequest.dart';
import 'package:schooltrackingsystem/screens/driver/ParentRequestListVerifiedbyDriver.dart';
import 'package:schooltrackingsystem/screens/driver/StudentdirectionScreen.dart';
import 'package:schooltrackingsystem/screens/parent/Attendance.dart';
import 'package:schooltrackingsystem/utils/Constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var UserName;
  var RoleId;
  var EmployeeId;
  bool isVisiblechildrenslist = false;
  bool isVisibleviewroutes = false;
  bool isVisibleParentRequestStop = false;
  bool isVisibleParentRequestlist = false;
  bool isVisibleAdminApprovedRequestList = false;
  bool Routes = false;
  bool attendancedata = false;
  bool removepoint = false;
  bool driverlayoutstart = false;
  bool qrcodescanner = false;
  bool studentdirectiondriver = false;
  bool parentrequestapproveddriver = false;
  bool routesdriver = false;
  bool idcardmissingdriver = false;
  bool breakdowndriver = false;
  bool vehiclestartvisible=true;
  bool vehiclestopvisible=false;
  int counter = 0;
  var VehicleNo;
  var TotalStudents;
  var NoOfStudentsAttended;
  var absentstudents;
  var dropdownlistId;
  var dropdownListName;
  List<MastersDataModelClass> list = [];
  String location = 'Null, Press Button';
  String Address = 'Fetching Location...';
  var currentLocationLatitude;
  var currentLocationLongitude;
  var UserId;
  String? mtoken="";
  final ViewAllRoutesEditDataModelClass article=ViewAllRoutesEditDataModelClass();
    clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('newLaunch');
  }
  @override
  void initState() {
    getToken();
    _updatetokendata();
    retrieveStringValue();
    vehiclestartvisible=true;
    vehiclestopvisible=false;
    getcurrentlocation();
    init();
    super.initState();
  }


  init() async {
    String deviceToken = await getDeviceToken();
    print("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCIATION ######");
    print(deviceToken);
    print("############################################################");

    // listen for user to click on notification 
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      String? title = remoteMessage.notification!.title;
      String? description = remoteMessage.notification!.body;
     print(title);
     print(description);
      //im gonna have an alertdialog when clicking from push notification
      // Alert(
      //   context: context,
      //   type: AlertType.error,
      //   title: title, // title from push notification data
      //   desc: description, // description from push notifcation data
      //   buttons: [
      //     DialogButton(
      //       child: Text(
      //         "COOL",
      //         style: TextStyle(color: Colors.white, fontSize: 20),
      //       ),
      //       onPressed: () => Navigator.pop(context),
      //       width: 120,
      //     )
      //   ],
      // ).show();
    });
  }

//get device token to use for push notification
  Future getDeviceToken() async {
    //request user permission for push notification 
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }

  getcurrentlocation() async {
    Position position = await _getGeoLocationPosition();
    var RoleId = await SaveSharedPreference.getRoleId();
    print('QRCodeRoleId $RoleId');
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    print("location lat");
    print(location);
    GetAddressFromLatLong(position);
  }

  Future<void> GetAddressFromLatLong(Position position) async{
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocationLatitude=position.latitude.toString();
    currentLocationLongitude=position.longitude.toString();
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.name}, ${place.thoroughfare},${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode},${place.country}.';
    print('Address -  $Address');
  }


  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      await Geolocator.openLocationSettings();
      return Future.error('Location Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }


  retrieveStringValue() async {
    UserName = await SaveSharedPreference.getUsername();
    RoleId = await SaveSharedPreference.getRoleId();
    setState(() {
      if (RoleId == '8' || RoleId == '2') {
        isVisiblechildrenslist = false;
        isVisibleAdminApprovedRequestList = false;
        isVisibleParentRequestStop = false;
        isVisibleParentRequestlist = true;
        isVisibleviewroutes = true;
        attendancedata = false;
        Routes = true;
        removepoint = true;
        driverlayoutstart = false;
        qrcodescanner = false;
        studentdirectiondriver = false;
        parentrequestapproveddriver = false;
        routesdriver = false;
        breakdowndriver = false;
        idcardmissingdriver=false;
      } else if (RoleId == '4' || RoleId == '5') {
        _getvehicleIdListId();
        getbreakdownlistData();
        isVisiblechildrenslist = false;
        isVisibleParentRequestStop = false;
        isVisibleviewroutes = false;
        Routes = false;
        attendancedata = false;
        isVisibleAdminApprovedRequestList = false;
        isVisibleParentRequestlist = false;
        removepoint = false;
        driverlayoutstart = true;
        qrcodescanner = true;
        idcardmissingdriver=true;
        studentdirectiondriver = true;
        routesdriver = true;
        breakdowndriver = true;
        parentrequestapproveddriver = true;
      } else if (RoleId == '6' || RoleId == '7') {
        isVisiblechildrenslist = true;
        isVisibleParentRequestStop = true;
        attendancedata = true;
        isVisibleAdminApprovedRequestList = true;
        isVisibleviewroutes = false;
        removepoint = false;
        isVisibleParentRequestlist = false;
        Routes = false;
        driverlayoutstart = false;
        qrcodescanner = false;
        studentdirectiondriver = false;
        parentrequestapproveddriver = false;
        routesdriver = false;
        breakdowndriver = false;
        idcardmissingdriver=false;
      }
    });

    print("UserName $UserName");
    print("RoleId $RoleId");
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    bool isVisible = true;
    return WillPopScope(
        onWillPop: () async {
      // show the snackbar with some text
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('The System Back Button is Deactivated')));
      return false;
    },
    child:Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(23, 171, 144, 1),
                  Color.fromRGBO(13, 191, 194, 1),
                  Color.fromRGBO(23, 171, 144, 0.4),
                ],
              )),
              height: Constants.headerHeight + statusBarHeight,
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),

          // BODY
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Welcome To",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Container(
                                          // margin: EdgeInsets.all(10),
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color.fromRGBO(23, 171, 144, 1),
                                                Color.fromRGBO(13, 191, 194, 1),
                                                Color.fromRGBO(23, 171, 144, 0.4),
                                              ],
                                            ),
                                            border: Border.all(
                                                color: Colors.white, // Set border color
                                                width: 2.0),   // Set border width
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10.0)), // Set rounded corner radius
                                            // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))] // Make rounded corner of border
                                          ),
                                          child: const Text('BreakDown Vehicle Request',style: TextStyle(color:Colors.white),),
                                        ),
                                        titleTextStyle:
                                        const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20,),
                                        actions: const [

                                        ],
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Padding(padding: EdgeInsets.all(10),
                                            Stack(
                                              alignment:Alignment.center,
                                              children: [
                                                Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10.0),

                                                    )
                                                ),

                                              ],

                                            ),
                                            const SizedBox(height: 10,),
                                            Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.cyan),
                                                        borderRadius: BorderRadius.circular(4)),
                                                    border: const OutlineInputBorder(),
                                                    labelText: 'BreakDown Reason',
                                                    hintText: 'Select Breakdown Reason',
                                                  ),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      print("onchamged $newValue");
                                                      final split = newValue!.split(',');
                                                      final Map<int, String> values = {
                                                        for (int i = 0; i < split.length; i++)
                                                          i: split[i]
                                                      };
                                                      print(values);
                                                      dropdownlistId = values[0];
                                                      dropdownListName= values[1];
                                                      print('BreakDownListName $dropdownListName');
                                                      print('BreakDownListId $dropdownlistId');
                                                    });
                                                  },
                                                  items: list.map((MastersDataModelClass map) {
                                                    print(map.name.toString());
                                                    return DropdownMenuItem<String>(
                                                      value:'${map.id},${map.name}',
                                                      child: Text(
                                                        map.name.toString(),
                                                      ),

                                                    );
                                                  }).toList(),
                                                )
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                InkWell(onTap: (){
                                                  _sendbreakdowndetails();
                                                },
                                                  child: Container(
                                                    margin: const EdgeInsets.all(10),
                                                    padding: const EdgeInsets.all(10),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: [
                                                          Color.fromRGBO(23, 171, 144, 1),
                                                          Color.fromRGBO(13, 191, 194, 1),
                                                          Color.fromRGBO(23, 171, 144, 0.4),
                                                        ],
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.white, // Set border color
                                                          width: 2.0),   // Set border width
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(10.0)), // Set rounded corner radius
                                                      // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))] // Make rounded corner of border
                                                    ),
                                                    child: const Text('Submit',style: TextStyle(color:Colors.white),),
                                                  ),),
                                                const Spacer(),
                                                InkWell(onTap: (){
                                                  Navigator.pushAndRemoveUntil<dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext context) => const DashBoardScreen(),
                                                    ),
                                                        (route) => false,//if you want to disable back feature set to false
                                                  );
                                                },
                                                  child: Container(
                                                    margin: const EdgeInsets.all(10),
                                                    padding: const EdgeInsets.all(10),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: [
                                                          Color.fromRGBO(1, 171, 144, 1),
                                                          Color.fromRGBO(1, 191, 194, 1),
                                                          Color.fromRGBO(1, 171, 144, 0.4),
                                                        ],
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.white, // Set border color
                                                          width: 2.0),   // Set border width
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(10.0)), // Set rounded corner radius
                                                      // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))] // Make rounded corner of border
                                                    ),
                                                    child: const Text('Cancel',style: TextStyle(color:Colors.white),),
                                                  ),
                                                ),
                                                const Spacer(flex: 1,)
                                              ],
                                            ),

                                          ],),
                                      )
                              );
                            },
                            child: Visibility(
                              visible:breakdowndriver,
                              child: Card(
                                elevation: 20,
                                shadowColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                                color: Colors.white,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: const [
                                        Text(
                                          'Breakdown',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.cyan,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Stack(
                              children: <Widget>[
                                 IconButton(
                                    icon: const Icon(Icons.notifications,
                                    color: Colors.white,),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationsList()));
                                      setState(() {
                                        counter = 0;
                                      });
                                    }),
                                counter != 0
                                    ?  Positioned(
                                        right: 11,
                                        top: 11,
                                        child:  Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration:  BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 14,
                                            minHeight: 14,
                                          ),
                                          child: Text(
                                            '$counter',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    :  Container()
                              ],
                            ),

                            // child: IconButton(
                            //   icon: const Icon(
                            //     Icons.notifications,
                            //     color: Colors.white,
                            //   ),
                            //   color: Colors.green,
                            //   splashColor: Colors.purple,
                            //   onPressed: () {
                            //
                            //   },
                            // ),
                          ),
                          InkWell(
                            child: IconButton(
                              icon: const Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                              ),
                              color: Colors.green,
                              splashColor: Colors.purple,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffDialog(
                                    image: Image.asset(
                                      'assets/images/confirm.gif',
                                      fit: BoxFit.cover,
                                    ),
                                    title: const Text(
                                      'The Future Kid\'s School',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                    ),
                                    entryAnimation: EntryAnimation.top,
                                    description: const Text(
                                      'Do you want to logout ?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    onOkButtonPressed: () {
                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginScreen()));
                                                    _deleteCacheDir();
                                                    _deleteAppDir();
                                                    clearSharedPrefs;
                                                    SystemNavigator.pop();
                                    },
                                  ),
                                );
                                // showDialog<String>(
                                //   context: context,
                                //   builder: (BuildContext context) =>
                                //       AlertDialog(
                                //     title:
                                //         const Text('The Future Kid\'s School'),
                                //     content: const Text(
                                //         'Do you really wants to logout?'),
                                //     actions: <Widget>[
                                //       TextButton(
                                //         onPressed: () =>
                                //             Navigator.pop(context, 'Cancel'),
                                //         child: const Text('Cancel'),
                                //       ),
                                //       TextButton(
                                //         onPressed: () => {
                                //           Navigator.pushReplacement(
                                //               context,
                                //               MaterialPageRoute(
                                //                   builder: (context) =>
                                //                       LoginScreen())),
                                //           _deleteCacheDir(),
                                //           _deleteAppDir(),
                                //         },
                                //         child: const Text('Yes'),
                                //       ),
                                //     ],
                                //   ),
                                // );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Row(
                    children: <Widget>[
                      Column(children: <Widget>[
                        Image.asset(
                          'assets/images/fks_logo.png',
                          fit: BoxFit.contain,
                          width: 150,
                          height: 55,
                          color: Colors.white,
                        ),
                      ]),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$UserName',
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 270),
                  child: Column(
                    children: <Widget>[
                      Column(children: <Widget>[
                        Image.asset('assets/images/ic_schoolbus.png',
                            fit: BoxFit.contain,
                            width: 150,
                            height: 80,
                            opacity: const AlwaysStoppedAnimation(.4)),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {

                        },
                        child: Visibility(
                          visible: driverlayoutstart,
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.black,
                            color: const Color.fromRGBO(23, 171, 144, 0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 10),
                                            Visibility(visible: vehiclestartvisible,child:  Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _sendvehiclestartdetails();
                                                  },
                                                  child: Card(
                                                    elevation: 20,
                                                    shadowColor: Colors.white,
                                                    shape:
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                          Radius
                                                              .circular(
                                                              10),
                                                          topRight: Radius
                                                              .circular(
                                                              10)),
                                                    ),
                                                    color: Colors.white,
                                                    child: SizedBox(
                                                      width: 98,
                                                      height: 50,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
                                                            10.0),
                                                        child: Column(
                                                          children: const [
                                                            Text(
                                                              'Start',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                Colors.cyan,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w100,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                            Visibility(visible: vehiclestopvisible,child:  Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _sendvehicleEnddetails();
                                                  },
                                                  child: Card(
                                                    elevation: 20,
                                                    shadowColor: Colors.white,
                                                    shape:
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                          Radius
                                                              .circular(
                                                              10),
                                                          topRight: Radius
                                                              .circular(
                                                              10)),
                                                    ),
                                                    color: Colors.white,
                                                    child: SizedBox(
                                                      width: 98,
                                                      height: 50,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
                                                            10.0),
                                                        child: Column(
                                                          children: const [
                                                            Text(
                                                              'Stop',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                Colors.cyan,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w100,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                            Row(
                                              children: [
                                                Card(
                                                  elevation: 20,
                                                  shadowColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                  ),
                                                  color: Colors.white,
                                                  child: Container(
                                                     width: MediaQuery.of(context).size.width/4.5,
                                                    height: MediaQuery.of(context).size.height/6.50,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        children: [
                                                           Text(
                                                             '$TotalStudents',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.cyan,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Text(
                                                            'Total Students',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      130),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 20,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                  ),
                                                  shadowColor: Colors.white,
                                                  color: Colors.white,
                                                  child: Container(
                                                     width: MediaQuery.of(context).size.width/4.5,
                                                    height: MediaQuery.of(context).size.height/6.50,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '$NoOfStudentsAttended',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.cyan,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Text(
                                                            'Presnet',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      130),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 20,
                                                  shadowColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                  ),
                                                  color: Colors.white,
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width/4.5,
                                                    height: MediaQuery.of(context).size.height/6.50,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "$absentstudents",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.cyan,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Text(
                                                            'Absent',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      130),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                 // width: MediaQuery.of(context).size.width,
                 // height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Row(children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Trackingscreen()));
                          },
                          child: Visibility(
                            visible: isVisible,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.cyan[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/ic_tracking.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Live Tracking',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.cyan,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChildrensProfileList()));
                          },
                          child: Visibility(
                            visible: isVisiblechildrenslist,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                               width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.deepOrangeAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/group.png',
                                            width: 40,
                                            height: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Profiles',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const QRCodeScanner()));
                          },
                          child: Visibility(
                            visible: qrcodescanner,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.deepOrangeAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/scanner.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'QR Code Scanner',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewAndEditRoutesList()));
                          },
                          child: Visibility(
                            visible: isVisibleviewroutes,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.deepOrangeAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/route.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'View Routes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ParentRequestStop()));
                          },
                          child: Visibility(
                            visible: isVisibleParentRequestStop,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                               width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.greenAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/request_stop.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Request Stop',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentdirectionScreen()));
                          },
                          child: Visibility(
                            visible: studentdirectiondriver,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.greenAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/route.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Student Direction',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ParentRequestList()));
                          },
                          child: Visibility(
                            visible: isVisibleParentRequestlist,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.greenAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/note.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Parent Requests',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminApprovedRequestList()));
                          },
                          child: Visibility(
                            visible: isVisibleAdminApprovedRequestList,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.orangeAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/note.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Admin Approved',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ParentRequestListVerifiedbyDriver()));
                          },
                          child: Visibility(
                            visible: parentrequestapproveddriver,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                 width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.orangeAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/note.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Request List',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddNewRoute(article)));
                          },
                          child: Visibility(
                            visible: Routes,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                 width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.orangeAccent[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/route.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Routes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Attendance()));

                          },
                          child: Visibility(
                            visible: attendancedata,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blueGrey[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/ic_attendance.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Attendance Data',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddNewRoute(article)));
                          },
                          child: Visibility(
                            visible: routesdriver,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                 width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blueGrey[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/route.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Routes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RemovePointfromRoute()));
                          },
                          child: Visibility(
                            visible: removepoint,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blueGrey[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/ic_minus.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Remove Point',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const IDCardMissingRequest()));
                          },
                          child: Visibility(
                            visible: idcardmissingdriver,
                            child: Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              child: SizedBox(
                                 width: MediaQuery.of(context).size.width*25/100,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.lightGreen[100],
                                          radius: 40,
                                          child: Image.asset(
                                            'assets/images/idcard.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'ID Card Missing',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      //SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),);
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    await prefrences.clear();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future _getvehicleIdListId() async {
    EmployeeId = await SaveSharedPreference.getEmployeeId();
    var data = {
      'Action': 'GetVehicleIdByEmpId',
      'EmployeeId': EmployeeId
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/GetVehicleId');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage=body['Message'].toString();
    var VehicleID=body['VehicleId'].toString();
    var RouteId=body['RouteId'].toString();
    if (responsecode == "1") {
      _getstudentattendancedata(VehicleID);
      SaveSharedPreference.saveVehicleId(VehicleID);
      SaveSharedPreference.saveRouteId(RouteId);
    }
    }


  Future _getstudentattendancedata(VehicleID) async {
    var data = {
      'VehicleId': VehicleID,
    };
    print('vehicle Id $VehicleID');
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/GetStudentattendanceByVehicleId');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage=body['Message'].toString();
    if (responsecode == "1") {
      setState(() {
        VehicleNo=body['VehicleNo'].toString();
        TotalStudents=body['TotalStudents'].toString();
        NoOfStudentsAttended=body['NoOfStudentsAttended'].toString();
        if(TotalStudents!="0"){
          absentstudents = TotalStudents.toInt() - NoOfStudentsAttended.toInt();
        }else{
          absentstudents='0';
        }
      });

    }

  }

  Future _updatetokendata() async {
     UserId = await SaveSharedPreference.getRoleId();
    var data = {
      'UserId': UserId,'DeviceToken':mtoken
    };
    print('vehicle Id $UserId');
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/UpdateDeviceTokenByUserId');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage=body['Message'].toString();
    if (responsecode == "0") {
      SaveSharedPreference.saveTokenData(mtoken);
      print('updatedtoken $mtoken');

    }

  }

  Future<List<MastersDataModelClass>> getbreakdownlistData() async {
    var data = {'Action': 'BreakdownType'};
    var res = await CallApi().postData(data, 'STS/GetMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<MastersDataModelClass>(
            (json) => MastersDataModelClass.fromJson(json))
        .toList();
    return list;
  }

  Future _sendbreakdowndetails() async {
    var  UserId = await SaveSharedPreference.getUserId();
    var  VehicleID = await SaveSharedPreference.getVehicleId();
    var  EmployeeId = await SaveSharedPreference.getEmployeeId();
    var data = {
      'VehicleId':VehicleID ,
      'EmployeeId': EmployeeId,
      'VehicleBreakdownTypeId':dropdownlistId,
      'UserId': UserId,
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/SaveVehicleBreakdown');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
      showSnackBar(context, responsemessage);
    }else{
      showSnackBar(context, responsemessage);
    }
  }

  Future _sendvehiclestartdetails() async {
    var  VehicleID = await SaveSharedPreference.getVehicleId();
    var  EmployeeId = await SaveSharedPreference.getEmployeeId();
    var data = {
      'VehicleId':VehicleID ,
      'EmployeeId': EmployeeId,
      'Latitude':currentLocationLatitude,
      'Longitude': currentLocationLongitude,
      'Location': Address,
      'Status': 'Start',
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/SaveVehicleStartOrEndDetails');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      vehiclestopvisible=true;
      vehiclestartvisible=false;
      showSnackBar(context, responsemessage);
    }else{
      showSnackBar(context, responsemessage);
    }
  }

  Future _sendvehicleEnddetails() async {
    var  VehicleID = await SaveSharedPreference.getVehicleId();
    var  EmployeeId = await SaveSharedPreference.getEmployeeId();
    var data = {
      'VehicleId':VehicleID ,
      'EmployeeId': EmployeeId,
      'Latitude':currentLocationLatitude,
      'Longitude': currentLocationLongitude,
      'Location': Address,
      'Status': 'End',
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/SaveVehicleStartOrEndDetails');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      vehiclestopvisible=false;
      vehiclestartvisible=true;
      showSnackBar(context, responsemessage);
    }else{
      showSnackBar(context, responsemessage);
    }
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

