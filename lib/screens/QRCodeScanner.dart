import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:schooltrackingsystem/datamodelclass/StudentDetailsDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/Constants.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  _QRCodeScanner createState() => _QRCodeScanner();
}

class _QRCodeScanner extends State<QRCodeScanner> {
  String _scanBarcode = 'Unknown';
  String TitleText = 'QR Code Scan';
  var EmployeeId;
  var EmployeeVehicleId;
  var EmployeeRouteId;
  var StudentvehicleId;
  var StudentvehicleNumber;
  var StudentRouteName;
  var StudentId;
  var BranchId;
  var ClassId;
  var SectionId;
  bool studentdatavisible = false;
  bool studentdatanotmatchvisible = false;
  List<StudentDetailsDataModelClass> list = [];
  String location = 'Null, Press Button';
  String Address = 'Fetching Location...';
  var currentLocationLatitude;
  var currentLocationLongitude;

  @override
  void initState() {
    setState(() {
      scanQR();
      getcurrentlocation();
    });
    super.initState();
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

  Future getEmployeevehicleData() async {
    EmployeeId = await SaveSharedPreference.getEmployeeId();
    print("EmployeeId $EmployeeId");
    var data = {'Action': 'GetVehicleIdByEmpId', 'EmployeeId': EmployeeId};
    var res = await CallApi().postData(data, 'STS/GetVehicleId');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    print(body);
    if (responsecode == "1") {
      EmployeeVehicleId = body['VehicleId'].toString();
      print('EmployeevehicleId $EmployeeVehicleId');
      EmployeeRouteId = body['RouteId'].toString();
    } else {
      EmployeeVehicleId = '';
      print('EmployeevehicleId $EmployeeVehicleId');
      showSnackBar(context, "Vehicle Not assigned");
    }
  }



  Future<List<StudentDetailsDataModelClass>> getStudentData(
      AdmissionNumber) async {
    Map<String, dynamic>? data;
    print(AdmissionNumber);
    if (AdmissionNumber != null) {
      data = {'AdmissionNo': AdmissionNumber};
    }
    var res = await CallApi().postData(data, 'STS/Savetudent');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    StudentvehicleId=rest[0]['VehicleId'];
    StudentvehicleNumber=rest[0]['VehicleNo'];
    StudentRouteName=rest[0]['RouteName'];
    BranchId=rest[0]['BranchId'];
    StudentId=rest[0]['StudentId'];
    ClassId=rest[0]['ClassId'];
    SectionId=rest[0]['SectionId'];
    print('StudentvehicleId $StudentvehicleId');
    print('EmployeeVehicleId $EmployeeVehicleId');
    if(EmployeeVehicleId==StudentvehicleId){
      print('true');
      senddatatoserverAttendanceStatus(BranchId,StudentId,ClassId,SectionId);
    }else{
      print('false');
    _showMyDialog();
    }
    print(rest);
    list = rest
        .map<StudentDetailsDataModelClass>(
            (json) => StudentDetailsDataModelClass.fromJson(json))
        .toList();
    return list;
  }

  Future senddatatoserverAttendanceStatus(BranchId,StudentId,ClassId,SectionId) async {
    EmployeeId = await SaveSharedPreference.getEmployeeId();
    print("EmployeeId $EmployeeId");
    var data = {'BranchId': BranchId, 'StudentId': StudentId,'ClassId':ClassId,'EmployeeId':EmployeeId,'Latitude':currentLocationLatitude,'Longitude':currentLocationLongitude,'Location':Address,'SectionId':SectionId};
    var res = await CallApi().postData(data, 'STS/SaveStudenAttendance');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    print(body);
    if (responsecode == "1") {
      _showMyAttendanceSucessDialog();
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("Barcode Response $barcodeScanRes");
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
    setState(() {
      _scanBarcode = barcodeScanRes;
      if (_scanBarcode != null) {
        TitleText = 'Student Details';
        getEmployeevehicleData();
        getStudentData(_scanBarcode);
        print('listdatasize ${list.length}');
      } else {
        TitleText = 'QR Code Scan';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return WillPopScope(
      onWillPop: () async {
        // show the snackbar with some text
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
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
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70),
                    )),
                height: 298.2 + statusBarHeight,
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
              padding: const EdgeInsets.all(12.5),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(
                              AntDesign.arrowleft,
                              color: Colors.white,
                            ),
                            iconSize: 40.0,
                            onPressed: () {
                              _goBack(context);
                            },
                          ),
                           FutureBuilder(
                              future: getStudentData(_scanBarcode),
                              builder: (context, snapshot) {
                                return snapshot.data != null
                                    ? ListView.builder(
                                    itemCount: list.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(2.0),
                                    itemBuilder: (context, position) {
                                      return Container(
                                        margin: const EdgeInsets.only(top: 0),
                                        child:  Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white,width: 1),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          'https://www.tecdatum.org/STSStudentImage/${list[0].studentImage}' ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80'))
                                                // color: Colors.orange[100],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  '${list[0].surName} ${list[0].firstName}',style: const TextStyle(fontSize: 25,color: Colors.white),),
                                                Text(
                                                  '${list[0].rollNo}',style: const TextStyle(fontSize: 20,color: Colors.white),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Card(
                                                      elevation: 25,
                                                      shadowColor: Colors.black,
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .outline,
                                                        ),
                                                        borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(12)),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(20.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment:
                                                                      Alignment.topLeft,
                                                                      child: Column(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                        mainAxisSize:
                                                                        MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 160,
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    // clickOnParentRequest(context);
                                                                                    // Navigator.of(context).push(
                                                                                    //   // MaterialPageRoute(builder: (context) => Otp()),
                                                                                    // );
                                                                                  },
                                                                                  style: ButtonStyle(
                                                                                    foregroundColor:
                                                                                    MaterialStateProperty.all<Color>(Colors.white),
                                                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                                                        const Color.fromRGBO(13, 191, 194, 1)),
                                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                      RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  child: const Padding(
                                                                                    padding: EdgeInsets.all(14.0),
                                                                                    child: Text(
                                                                                      'Attendance',
                                                                                      style: TextStyle(fontSize: 16),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 30,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                            mainAxisSize:
                                                                            MainAxisSize
                                                                                .max,
                                                                            children: [
                                                                              const Text(
                                                                                  'ClassName',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              const Text(' : ',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              Text(
                                                                                '${list[0].className}',
                                                                                style: const TextStyle(
                                                                                    fontSize:
                                                                                    14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w200),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                            mainAxisSize:
                                                                            MainAxisSize
                                                                                .max,
                                                                            children: [
                                                                              const Text(
                                                                                  'Gender',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              const Text(' : ',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              Text(
                                                                                '${list[0].genderName}',
                                                                                style: const TextStyle(
                                                                                    fontSize:
                                                                                    14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w200),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                            mainAxisSize:
                                                                            MainAxisSize
                                                                                .max,
                                                                            children: [
                                                                              const Text(
                                                                                  'Father Name',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              const Text(' : ',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              Text(

                                                                                '${list[0].fatherName}',
                                                                                style: const TextStyle(
                                                                                    fontSize:
                                                                                    14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w200),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                            mainAxisSize:
                                                                            MainAxisSize
                                                                                .max,
                                                                            children: [
                                                                              const Text(
                                                                                  'Father Mobile Number',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              const Text(' : ',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              Text(

                                                                                '${list[0].fatherMobileNo}',
                                                                                style: const TextStyle(
                                                                                    fontSize:
                                                                                    14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w200),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                            mainAxisSize:
                                                                            MainAxisSize
                                                                                .max,
                                                                            children: [
                                                                              const Text('DOB',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              const Text(' : ',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      16,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w500)),
                                                                              Text(
                                                                                '${list[0].dob}',
                                                                                style: const TextStyle(
                                                                                    fontSize:
                                                                                    14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w200),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
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
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    : const Center(
                                    child: CircularProgressIndicator());
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _goBack(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const DashBoardScreen(),
      ),
          (route) => false,//if you want to disable back feature set to false
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (_) => AssetGiffDialog(
          image: Image.asset(
            'assets/images/error.gif',
            fit: BoxFit.cover,
          ),
          title:  const Text(
            'Student not allowed in this route vehicle \n Please check your  route Vehicle Information',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,),
          ),
          entryAnimation: EntryAnimation.top,
          description: Text(
            'Vehicle Number  :  $StudentvehicleNumber \n'
            'RouteName  :  $StudentRouteName \n'
            'Admission Number :  $_scanBarcode',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w300),
          ),
          onOkButtonPressed: () {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const DashBoardScreen(),
              ),
                  (route) => false,//if you want to disable back feature set to false
            );
          },
        ),
      );
  }

  Future<void> _showMyAttendanceSucessDialog() async {
    return showDialog(
      context: context,
      builder: (_) => AssetGiffDialog(
        image: Image.asset(
          'assets/images/success.gif',
          fit: BoxFit.cover,
        ),
        title:  const Text(
          'Attendance Completed \n The Attendance was recorded successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,),
        ),
        entryAnimation: EntryAnimation.top,
        // description: Text(
        //   'Vehicle Number  :  $StudentvehicleNumber \n'
        //       'RouteName  :  $StudentRouteName \n'
        //       'Admission Number :  $_scanBarcode',
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w300),
        // ),
        onOkButtonPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const DashBoardScreen(),
            ),
                (route) => false,//if you want to disable back feature set to false
          );
        },
      ),
    );
  }
}
