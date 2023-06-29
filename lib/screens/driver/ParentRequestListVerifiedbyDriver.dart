

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/ParentRequestedDetailsForDriverDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ParentRequestListVerifiedbyDriver extends StatefulWidget {
  const ParentRequestListVerifiedbyDriver({super.key});

  @override
  _ParentRequestListVerifiedbyDriverState createState() => _ParentRequestListVerifiedbyDriverState();
}

class _ParentRequestListVerifiedbyDriverState extends State<ParentRequestListVerifiedbyDriver> {
  var EmployeeId;
  var OTP;
  var VehicleId;
  bool isVisibleapprove = false;
  bool isVisiblereject = false;
  bool isVisibleOtpfield = false;
  var complete='Complete';
  var pending='Pending';
  var verify='Verify OTP';
  final _contactEditingController = TextEditingController();
  String location = 'Null, Press Button';
  String Address = 'Fetching Location...';
  var currentLocationLatitude;
  var currentLocationLongitude;


  @override
  void initState() {
    setState(() {
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




  Future<List<ParentRequestedDetailsForDriverDataModelClass>> getData() async {
    List<ParentRequestedDetailsForDriverDataModelClass> list;

    EmployeeId = await SaveSharedPreference.getEmployeeId();
    print(EmployeeId);
    var data = {'EmployeeId': EmployeeId};
    var res = await CallApi().postData(data, 'STS/GetParentRequestedDetailsForDriver');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<ParentRequestedDetailsForDriverDataModelClass>(
            (json) => ParentRequestedDetailsForDriverDataModelClass.fromJson(json))
        .toList();
    return list;
  }

  Future _verifyMobileNumber(Mobilenumber) async {
    var data = {
      'MobileNumber': Mobilenumber
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/SendOTP');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage=body['Message'].toString();
     OTP=body['OTP'].toString();
    print("OTP $OTP");
    if (responsecode == "1") {
        isVisibleOtpfield=true;
        verify="Resend OTP";
    }else{
        isVisibleOtpfield=false;
        verify="Verify OTP";


    }

  }

  Future _driverhandoverperson(ParentRequestId) async {
    EmployeeId = await SaveSharedPreference.getEmployeeId();
    VehicleId = await SaveSharedPreference.getVehicleId();
    var data = {
      'ParentRequestId': ParentRequestId,
      'VerifieLatitude': currentLocationLatitude,
      'VerifiedLongitude': currentLocationLongitude,
      'VerifiedLocation': Address,
      'EmployeeId': EmployeeId,
      'VehicleId': VehicleId,
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/ParentRequestPersonVerified');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage=body['Message'].toString();
    if (responsecode == "1") {
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const ParentRequestListVerifiedbyDriver(),
      );
    }else{


    }

  }

  Widget listViewWidget(List<ParentRequestedDetailsForDriverDataModelClass> parentRequestedDetailsForDriver) {
    return Container(
      child: ListView.builder(
          itemCount: parentRequestedDetailsForDriver.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            if(parentRequestedDetailsForDriver[position].isVerified=='True'){
              isVisibleapprove = true;
              isVisiblereject = false;
              complete='Completed';
            }else if(parentRequestedDetailsForDriver[position].isVerified=='False'){
              isVisibleapprove = true;
              isVisiblereject = true;
              complete='Complete';
              pending='Pending';
            }
            return InkWell(
              onTap: () =>
                  _onTapItem(context, parentRequestedDetailsForDriver[position]),
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                color: Colors.white.withAlpha(200),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text('Parent Name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${parentRequestedDetailsForDriver[position].fatherName}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text('Parent RequestType',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${parentRequestedDetailsForDriver[position].parentRequestType}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text('Route Name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${parentRequestedDetailsForDriver[position].routeName}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text('Date of Request',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${parentRequestedDetailsForDriver[position].dateOfRequest}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text('Admin Update on',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${parentRequestedDetailsForDriver[position].adminUpdatedOn}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 10),
                                    Visibility( visible: isVisibleapprove,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print('object');
                                          if(parentRequestedDetailsForDriver[position].isVerified=='True'){
                                          showSnackBar(context, 'Verified Completed');
                                          }else{
                                            showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    AlertDialog(
                                                      scrollable: true,
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
                                                        child: const Text('Verify Parent Request',style: TextStyle(color:Colors.white),),
                                                      ),
                                                      titleTextStyle:
                                                      const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20,),
                                                      actions: const [

                                                      ],
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                                    child: Image.network(
                                                                      '${parentRequestedDetailsForDriver[position].idProofImagePath}' ?? 'assets/images/ic_noimage.png',
                                                                    ),
                                                                  )
                                                              ),

                                                            ],

                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.all(10),
                                                                padding: const EdgeInsets.all(15),
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  border: Border.all(
                                                                      color: Colors.black45, // Set border color
                                                                      width: 2.0),   // Set border width
                                                                  borderRadius: const BorderRadius.all(
                                                                      Radius.circular(10.0)), // Set rounded corner radius
                                                                  // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))] // Make rounded corner of border
                                                                ),
                                                                child: Text('${parentRequestedDetailsForDriver[position].fatherMobileNo}'),
                                                              ),
                                                              const Spacer(),
                                                              InkWell(onTap: (){
                                                                _verifyMobileNumber(parentRequestedDetailsForDriver[position].fatherMobileNo);
                                                              },
                                                                child: Text(verify, style: const TextStyle(
                                                                  decoration: TextDecoration.underline,
                                                                  color: Colors.cyan,
                                                                ),),
                                                              ),
                                                              const Spacer(flex: 4,)
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Visibility( visible: isVisibleOtpfield,
                                                            child:TextFormField(
                                                              keyboardType: TextInputType.number,
                                                              controller: _contactEditingController,
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black45,
                                                              ),
                                                              decoration: InputDecoration(
                                                                hintText: 'Enter OTP',
                                                                hintStyle: const TextStyle(color: Colors.black45),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(color: Colors.black45),
                                                                    borderRadius: BorderRadius.circular(10)),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(color: Colors.black45),
                                                                    borderRadius: BorderRadius.circular(10)),
                                                                prefix: const Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                                                ),
                                                                // suffixIcon: const Icon(
                                                                //   Icons.check_circle,
                                                                //   color: Colors.white,
                                                                //   size: 32,
                                                                // ),
                                                              ),
                                                            ) ,),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              InkWell(onTap: (){
                                                                if(OTP==_contactEditingController.text.toString()){

                                                                  _driverhandoverperson(parentRequestedDetailsForDriver[position].parentRequestId);

                                                                }else{
                                                                  showSnackBar(context, 'Invalid OTP');
                                                                }

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
                                                                    builder: (BuildContext context) => const ParentRequestListVerifiedbyDriver(),
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
                                          }
                                        },
                                        style: ButtonStyle(
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromRGBO(
                                                  31, 194, 13,
                                                  1).withAlpha(95)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                            complete,
                                            style: const TextStyle(fontSize: 11.5),
                                          ),
                                        ),
                                      ),),
                                    Visibility(visible:isVisiblereject,child: ElevatedButton(
                                      onPressed: () {
                                        // clickOnParentRequest(context);
                                        // Navigator.of(context).push(
                                        //   // MaterialPageRoute(builder: (context) => Otp()),
                                        // );
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(
                                                236, 119, 131, 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child:  Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          pending,
                                          style: const TextStyle(fontSize: 11.5),
                                        ),
                                      ),
                                    ),)
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, ParentRequestedDetailsForDriverDataModelClass article) {
    // Navigator.of(context).push(MaterialPageRoute(
    // builder: (BuildContext context) => ChildrensProfileDetails(article)));
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
        appBar: AppBar(
            flexibleSpace: Container(
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
            ),
            // backgroundColor: Colors.cyan,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              iconSize: 20.0,
              onPressed: () {
                _goBack(context);
              },
            ),
            title: const Text('Parent Requested Details For Driver')),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? listViewWidget(snapshot.data as List<ParentRequestedDetailsForDriverDataModelClass>)
                  : const Center(child: CircularProgressIndicator());
            }),
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

}