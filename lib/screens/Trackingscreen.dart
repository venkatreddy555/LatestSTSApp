import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schooltrackingsystem/datamodelclass/AdminvehicleIdListDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:schooltrackingsystem/datamodelclass/GetPointMasterDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/LiveTrackingDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:vector_math/vector_math.dart';
import 'package:location/location.dart';

class Trackingscreen extends StatefulWidget {
  static const id = "HOME_SCREEN";

  const Trackingscreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Trackingscreen> with TickerProviderStateMixin {
  final List<Marker> _markers = <Marker>[];
  Animation<double>? _animation;
  late GoogleMapController _controller;
  List<GetPointMasterDataModelClass> list = [];
  List<LiveTrackingDataModelClass> livetracklistdata = [];
  List<ChildrensProfilesDataModel> childrenlist = [];
  List<AdminvehicleIdListDataModelClass> vehicleIdlist = [];
  List<dynamic> FinalPointData = [{}];
  Map<String, dynamic> VehicleLoaction = {};
  Map<String, dynamic> VehicleTempData = {};
  var rest = [];
  var RoleId;
  var MobileNumber;
  var StudentId;
  var EmployeeId;
  var VehicleId;
  var Latitude;
  var Longitude;
  var tempvehicleLatitude=17.40041;
 var  tempvehicleLongitude=78.40594;
  var animatedLatitude=17.4053;
  var animatedLongitude=78.3493;
  var Locations;
  var RouteId;
  var BranchId;
   var pos = 0;
  bool isChecked = false;
  List<LatLng> latLen = [];
  final Set<Polyline> _polyline = {};
  Timer? _everySecond;
  Location location = Location();
  LocationData? currentLcotion;
  List <LatLng> lastpointlat = [];
  List <LatLng> lastpointlng = [];
  bool isVisiblechildrenName = false;
  bool isVisiblevehicleIds = false;
  var destinationicon;
  final _mapMarkerSC = StreamController<List<Marker>>();
  bool loading = true;
  AnimationController? _controller2;
  var Ignition = "Off";
   AnimationController? _controller3;
  bool _isPlaying = true;

  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  var icon;
  Completer<GoogleMapController> mapController = Completer();

  var childlist;
  var vehiclelist;

  @override
  void initState() {
    getIcons();
    getdestinationIcons();
    getretrivevalues();
    super.initState();

  }

  void onMapCreated(GoogleMapController controller) {
    if(!mapController.isCompleted){
      mapController.complete(controller);
      mapController = controller as Completer<GoogleMapController>;

    }
  }




  getretrivevalues() async{
    RoleId = await SaveSharedPreference.getRoleId();
    BranchId=await SaveSharedPreference.getBranchId();
    print('branchId $BranchId');
    if (RoleId == "8" || RoleId == "2") {
      getadminVehicleIdList(BranchId);
      isVisiblechildrenName=false;
      isVisiblevehicleIds=true;

    } else if (RoleId == "4" || RoleId == "5") {
      EmployeeId = await SaveSharedPreference.getEmployeeId();
      getEmployeevehicleData(EmployeeId);
      isVisiblechildrenName=false;
      isVisiblevehicleIds=false;
    } else if (RoleId == "6" || RoleId == "7") {
      isVisiblechildrenName=true;
      isVisiblevehicleIds=false;
      
    }

  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/placeholder.png");
    setState(() {
      this.icon = icon;
    });
  }

  getdestinationIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/ic_bustrackimage.png");
    setState(() {
      destinationicon = icon;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 8),
              child: const Text("Fetching Vehicle Location")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  double gettemplatlng(end,start) {
    var a = end;
    var b = start;
    if(a>b){
      var c  = a-b;
      // print(c.toStringAsFixed(3));
      return c;
    }else{
      var c  = b-a;
      //print(c.toStringAsFixed(3));
      return c;
    }

  }

  callanimation() async {
    if (Latitude != null && Longitude != null) {
      print('checkanimation');

      if(animatedLatitude != tempvehicleLatitude && animatedLongitude != tempvehicleLongitude ) {
        // _markers.removeWhere((m) => m.markerId.value == 'vehiclestop');
        // Future.delayed(const Duration(seconds: 10)).then((value) {

         // _controller2!.forward();
        // if(loading){
        //   Navigator.of(context, rootNavigator: true).pop('dialog');
        //   loading=false;
        //   dispose();
        // }

          animateCar(
            tempvehicleLatitude,
            tempvehicleLongitude,
            animatedLatitude,
            animatedLongitude,
            _mapMarkerSink,
            this,
            _controller,
          );

        // if(tempvehicleLatitude>animatedLatitude) {
        //   print("C1");
        //   animateCar(
        //     tempvehicleLatitude,
        //     tempvehicleLongitude,
        //     animatedLatitude,
        //     animatedLongitude,
        //     _mapMarkerSink,
        //     this,
        //     _controller,
        //   );
        // }else if(tempvehicleLatitude == animatedLatitude){
        //   print("C2");
        //   animateCar(
        //
        //     tempvehicleLatitude-0.0002,
        //     tempvehicleLongitude-0.0002,
        //     animatedLatitude,
        //     animatedLongitude,
        //     _mapMarkerSink,
        //     this,
        //     _controller,
        //   );
        // }else{
        //   print("C3");
        //   animateCar(
        //     animatedLatitude,
        //     animatedLongitude,
        //     tempvehicleLatitude,
        //     tempvehicleLongitude,
        //
        //     _mapMarkerSink,
        //     this,
        //     _controller,
        //   );
        // }
        // }
        //
        // );
      }else{
        if(loading){
          Navigator.of(context, rootNavigator: true).pop('dialog');
          loading=false;
        }
        // var templat = gettemplatlng(animatedLatitude.toDouble(),0.003.toDouble());
        // var templng = gettemplatlng(animatedLongitude.toDouble(),0.003.toDouble());
          var templat = animatedLatitude;
        var templng = animatedLongitude;
        print("Samelatlng");
        print('animatedLatitudes $animatedLatitude');
        print('animatedLongitudes $animatedLongitude');
        print('templat $templat');
        print('templng  $templng');
    

        //  _buildCircularContainer(200);
        //  _buildCircularContainer(250);
        //  _buildCircularContainer(300);
        //  _controller3!.repeat();         
         
         
          //          animateCar(

          //   tempvehicleLatitude-0.0002,
          //   tempvehicleLongitude-0.0002,
          //   animatedLatitude,
          //   animatedLongitude,
          //   _mapMarkerSink,
          //   this,
          //   _controller,
          // );
        // markerId: MarkerId("vehiclestop");
        // position: LatLng(
        //     animatedLatitude, animatedLongitude);
        // icon: BitmapDescriptor.fromBytes(
        //     await getBytesFromAsset('assets/images/ic_bustrackimage.png', 70));
        // _markers.add(Marker( //add second marker
        //   markerId: MarkerId('vehiclestop'),
        //   position: LatLng(animatedLatitude, animatedLongitude), //position of marker
        //   infoWindow: InfoWindow( //popup info
        //     title: 'My Custom Title ',
        //     snippet: 'My Custom Subtitle',
        //   ),
        //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        // ));
        // Future.delayed(const Duration(seconds: 10)).then((value) {
        // if(tempvehicleLatitude>animatedLatitude) {
        //   print("C1");
        //   animateCar(
        //     tempvehicleLatitude,
        //     tempvehicleLongitude,
        //     animatedLatitude,
        //     animatedLongitude,
        //     _mapMarkerSink,
        //     this,
        //     _controller,
        //   );
        // }else if(tempvehicleLatitude == animatedLatitude){
        //   print("C2");
        //   var t1 = tempvehicleLatitude-0.0002;
        //   var t2 =  tempvehicleLongitude-0.0002;
        //   animateCar(
        //       double.parse((t1).toStringAsFixed(4)),
        //   double.parse((t2).toStringAsFixed(4)),
        //     animatedLatitude,
        //     animatedLongitude,
        //
        //
        //     _mapMarkerSink,
        //     this,
        //     _controller,
        //   );
        // }else{
        //   print("C3");
        //   animateCar(
        //     animatedLatitude,
        //     animatedLongitude,
        //     tempvehicleLatitude,
        //     tempvehicleLongitude,
        //
        //     _mapMarkerSink,
        //     this,
        //     _controller,
        //   );
        // }
        // }
        // );
      }
    }

  }




  Future<List<GetPointMasterDataModelClass>> _pickpoints_Stops(pointId) async {
    Map<String, dynamic> data;
    if (pointId == null) {
      data = {
        'RouteID': '',
      };
    } else {
      data = {'RouteID': pointId};
    }
    var res = await CallApi().postData(data, 'STS/GetPointMaster');
    print("GetPointMaster requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    print("VehicleLocationData $VehicleTempData");
    FinalPointData.add(VehicleTempData);
    body["Data"].forEach((element) {
      FinalPointData.add(element);
    });

    rest = FinalPointData;
    print(rest);

    list = rest
        .map<GetPointMasterDataModelClass>(
            (json) => GetPointMasterDataModelClass.fromJson(json))
        .toList();

    return list;
  }
    Widget _buildCircularContainer(double radius) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller2!, curve: Curves.fastLinearToSlowEaseIn),
      builder: (context, child) {
        return Container(
          width: _controller3!.value * radius,
          height: _controller3!.value * radius,
          decoration: BoxDecoration(color:ui.Color.fromARGB(255, 85, 84, 84).withOpacity(1 - _controller3!.value), shape: BoxShape.circle),
        );
      },
    );
  }



  Future<List<LiveTrackingDataModelClass>> _vehicleservice(VehicleId) async {
    RoleId = await SaveSharedPreference.getRoleId();
    print('selectedvehicleId $VehicleId');

    Map<String, dynamic> data;
    if (RoleId == "4" || RoleId == "5") {
      // VehicleID=SaveSharedPreference.sessionData!!.getVehicleId()
    }
    // data = {'VehicleId': '118'};
    data = {'VehicleId': VehicleId};
    var res = await CallApi().postData(data, 'STS/LiveTracking');
    print("responseBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    rest = body["Data"] as List;
    Latitude = rest[0]['Latitude'];
    Longitude = rest[0]['Longitude'];
    Locations = rest[0]['Location'];
    Ignition = rest[0]['Ignition'];

    print('Latitude $Latitude');
    print('Longitude $Longitude');
    print('Location $Locations');
    print('dataload,$Latitude,$Longitude,$Locations');
    VehicleLoaction['PointID'] = '0';
    VehicleLoaction['PointNo'] = '0';
    VehicleLoaction['PointName'] = 'Vehicle Current Location';
    VehicleLoaction['PointAddress'] = Locations;
    VehicleLoaction['Latitude'] = Latitude;
    VehicleLoaction['Longitude'] = Longitude;
    VehicleTempData = VehicleLoaction;
    print(rest);

    animatedLatitude = double.parse(Latitude);
    animatedLongitude = double.parse(Longitude);


    if (mounted) {
      //setState(() => {});
        lastpointlng.add(LatLng(animatedLatitude, animatedLongitude));
        print('lastpointlng ${lastpointlng.length}');
       
        if(lastpointlng.length>1) {
         //  pos = lastpointlng.length - 2; 
            pos + 1;
        }else{
          pos + 1;
        }
          print('checking pos ${lastpointlng.length-1}');
        // print('lastminus1 ${lastpointlng[pos].latitude}');
        if(lastpointlng.length > 3){
       tempvehicleLatitude =   lastpointlng[lastpointlng.length-2].latitude.toDouble();
        tempvehicleLongitude =  lastpointlng[lastpointlng.length-2].longitude.toDouble();
        }else{
       tempvehicleLatitude =   lastpointlng[0].latitude.toDouble();
        tempvehicleLongitude =  lastpointlng[0].longitude.toDouble();
        }
        

    }

    print('tempvehicledatalat $tempvehicleLatitude');
    print('tempvehicledatalng $tempvehicleLongitude');
    print('animatedLatitudes $animatedLatitude');
    print('animatedLongitudes $animatedLongitude');
    print('tempvehicleLatitudelast $tempvehicleLatitude');
    print('tempvehicleLongitudelast $tempvehicleLongitude');

    livetracklistdata = rest
        .map<LiveTrackingDataModelClass>(
            (json) => LiveTrackingDataModelClass.fromJson(json))
        .toList();

    // var i=0;
    // while(i <list.length-1){
    //   i++;
    //   if(list[i].latitude!=null && list[i].longitude!=null){
    //     tempvehicleLatitude=double.parse(list[i-1].latitude!);
    //     tempvehicleLongitude=double.parse(list[i-1].longitude!);
    //     print('tempvehiclelatitude ${list[i-1].latitude}');
    //     print('tempvehiclelongitude ${list[i-1].longitude}');
    //   }else{
    //     tempvehicleLatitude=17.40041;
    //     tempvehicleLongitude=78.40594;
    //   }
    //
    //
    //
    // }
    if(Ignition == "Off"){
        print("Vehcile not running");
        var vehicleid= "Vehicle Not Runnind";
        // _markers.add(Marker(
        //     markerId:
        //     MarkerId(vehicleid),
        //     draggable: false,
        //     position: LatLng(
        //         double.parse(
        //            Latitude),
        //         double.parse(
        //             Longitude)),
        //     infoWindow: InfoWindow(
        //         title: Locations),
        //     icon:destinationicon));
        //Navigator.of(context, rootNavigator: true).pop('dialog');
        animateCar(
          tempvehicleLatitude-0.0002,
          tempvehicleLongitude-0.0002,
          animatedLatitude,
         animatedLongitude,
          _mapMarkerSink,
          this,
          _controller,
        );

    }else {
    //  callanimation();
    //_controller2!.forward;
     animateCar(
          tempvehicleLatitude-0.0002,
          tempvehicleLongitude-0.0002,
          animatedLatitude,
         animatedLongitude,
          _mapMarkerSink,
          this,
          _controller,
        );
    }
     // callanimation();

    return livetracklistdata;
  }

  Future<List<ChildrensProfilesDataModel>> getchildrenData() async {
    MobileNumber = await SaveSharedPreference.getMobileNumber();
    print(MobileNumber);
    var data = {'MobileNumber': MobileNumber};
    var res = await CallApi().postData(data, 'STS/GetChildrens');
    print("GetChildrens requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);

    if( body["Data"] != null) {
      childlist = body["Data"] as List;

    }else{
      childlist = [];
    }
    print(childlist);
    childrenlist = childlist
        .map<ChildrensProfilesDataModel>(
            (json) => ChildrensProfilesDataModel.fromJson(json))
        .toList();
    return childrenlist;
  }
  Future<List<AdminvehicleIdListDataModelClass>> getadminVehicleIdList(BranchId) async {
    var data = {'BranchId': BranchId};
    var res = await CallApi().postData(data, 'STS/GetVehicleByBranch');
    print("GetVehicleByBranch requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);

    if( body["Data"] != null) {
      vehiclelist = body["Data"] as List;

    }else{
      vehiclelist = [];
    }

    // var rest = body["Data"] as List;
    print(vehiclelist);

    vehicleIdlist = vehiclelist
        .map<AdminvehicleIdListDataModelClass>(
            (json) => AdminvehicleIdListDataModelClass.fromJson(json))
        .toList();
    return vehicleIdlist;
  }

  Future getEmployeevehicleData(StudentId) async {
    RoleId = await SaveSharedPreference.getRoleId();
    Map<String, dynamic>? data;
    EmployeeId = await SaveSharedPreference.getEmployeeId();
    print("EmployeeId $EmployeeId");
    print("StudentId $StudentId");
    if (RoleId == "4" || RoleId == "5") {
      data = {'Action': 'GetVehicleIdByEmpId', 'EmployeeId': EmployeeId};
    } else if (RoleId == "6" || RoleId == "7") {
      data = {'Action': 'GetVehicleIdByStuId', 'StudentId': StudentId};
    }
    var res = await CallApi().postData(data, 'STS/GetVehicleId');
    print("GetVehicleId requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    print(body);
    if (responsecode == "1") {
      VehicleId = body['VehicleId'].toString();
      print('vehicleId $VehicleId');
      RouteId = body['RouteId'].toString();
      // _vehicleservice(VehicleId);
      _pickpoints_Stops(RouteId);

      vehicleservice(VehicleId);
      // print(' tempvehicleLatitude $tempvehicleLatitude,tempvehicleLongitude $tempvehicleLongitude');
      // print(' Latitudeanimated $Latitude,Longitudeanimated $Longitude');

    } else {
      VehicleId = '';
      print('vehicleId $VehicleId');
      showSnackBar(context, "Vehicle Not assigned");
    }
  }
  Future vehicleservice(VehicleId) async{
    //showAlertDialog(context);
      _everySecond?.cancel();
    lastpointlng = [];
    _everySecond = Timer.periodic(const Duration(seconds: 15), (Timer t) {
      _vehicleservice(VehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocationCamera =  CameraPosition(
      target: LatLng(tempvehicleLatitude, tempvehicleLongitude),
      zoom: 15.4,
    );

    final googleMap = StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentLocationCamera,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: _polyline,
            onMapCreated: (GoogleMapController controller) async{

              if (!mapController.isCompleted) {
                mapController.complete(controller);
                _controller = await mapController.future;
              } else {
                _controller = controller;
              }
            },
            markers: Set<Marker>.of(snapshot.data ?? []),
            padding: const EdgeInsets.all(8),
          );
        });

    return WillPopScope(
        onWillPop: () async {
      // show the snackbar with some text
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('The System Back Button is Deactivated')));
      return false;
    },
      child: Scaffold(
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
                color: Color(0xFFFFFFFF),
              ),
              iconSize: 20.0,
              onPressed: () {
                _goBack(context);
              },
            ),
            title: const Text('Live Tracking')),
        body:  Stack(
          children: [
            googleMap,
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    Visibility(visible:isVisiblechildrenName,
                    child:FutureBuilder(
                        future: getchildrenData(),
                        builder: (context, snapshot) {
                          return snapshot.data != null
                              ? DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(13, 191, 194, 1)),
                                  borderRadius:
                                  BorderRadius.circular(4)),
                              border: const OutlineInputBorder(),
                              labelText: 'Children\'s',
                              hintText: 'Select Children',
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                print("onchamged $newValue");
                                getEmployeevehicleData(newValue);
                                final split = newValue!.split(',');
                                final Map<int, String> values = {
                                  for (int i = 0; i < split.length; i++)
                                    i: split[i]
                                };
                                print(values);
                                StudentId = values[0];
                                print('ChildrenListId $StudentId');
                              });
                            },
                            items: childrenlist
                                .map((ChildrensProfilesDataModel map) {
                              return DropdownMenuItem<String>(
                                value: map.studentId.toString(),
                                child: Text(
                                  "${map.surName} ${map.firstName}",
                                ),
                              );
                            }).toList(),
                          )
                              : const Center(
                              child: CircularProgressIndicator());
                        }) ,
                        ),
                    Visibility(visible: isVisiblevehicleIds,
                    child:FutureBuilder(
                        future: getadminVehicleIdList(BranchId),
                        builder: (context, snapshot) {
                          return snapshot.data != null
                              ? DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(13, 191, 194, 1)),
                                    borderRadius:
                                    BorderRadius.circular(4)),
                                border: const OutlineInputBorder(),
                                labelText: 'Vehicles',
                                hintText: 'Select Vehicle',
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  print("onchamged $newValue");
                                  vehicleservice(newValue);
                                  final split = newValue!.split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  print(values);
                                  StudentId = values[0];

                                  print('vehicleListId $StudentId');
                                });
                              },
                              items: vehicleIdlist
                                  .map((AdminvehicleIdListDataModelClass map) {
                                return DropdownMenuItem<String>(
                                  value: map.vehicleId.toString(),
                                  child: Text(
                                    "${map.vehicleName} ${map.vehicleNo}",
                                  ),
                                );
                              }).toList(),
                            )
                              : const Center(
                              child: CircularProgressIndicator());
                        }), ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Checkbox(
                          checkColor: const Color(0xFFFFFFFF),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                              if (value == true) {
                                print("1");
                                setState(() {
                                  for (int i = 0; i < list.length; i++) {
                                    try {
                                      setState(()  {
                                        if(list[i].pointID=='0' && list[i].pointName=='Vehicle Current Location'){
                                          print('position 0');
                                          _markers.add(Marker(
                                              markerId:
                                              MarkerId(list[i].pointID.toString()),
                                              draggable: false,
                                              position: LatLng(
                                                  double.parse(
                                                      list[i].latitude!),
                                                  double.parse(
                                                      list[i].longitude!)),
                                              infoWindow: InfoWindow(
                                                  title: list[i].pointName),
                                              icon:destinationicon));
                                          latLen.add(LatLng(
                                              double.parse(list[i].latitude!),
                                              double.parse(
                                                  list[i].longitude!)));
                                        }else{
                                        _markers.add(Marker(
                                            markerId:
                                            MarkerId(list[i].pointID.toString()),
                                            draggable: false,
                                            position: LatLng(
                                                double.parse(
                                                    list[i].latitude!),
                                                double.parse(
                                                    list[i].longitude!)),
                                            infoWindow: InfoWindow(
                                                title: list[i].pointName),
                                            icon:icon));
                                        latLen.add(LatLng(
                                            double.parse(list[i].latitude!),
                                            double.parse(
                                                list[i].longitude!)));
                                        }
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                  _polyline.add(Polyline(
                                    polylineId: const PolylineId('1'),
                                    points: latLen,
                                    color: const Color(0xFF37474F),
                                    width: 3,
                                  ));
                                });
                              } else {
                                print("0");
                                setState(() {
                                  _markers.clear();
                                  latLen.clear();
                                  _polyline.clear();
                                });
                              }
                            });
                          },
                        ),
                        const Text(
                          'Points',
                          style: TextStyle(
                            color: Color.fromRGBO(39, 105, 171, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
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

  setUpMarker() async {
    var currentLocationCamera = LatLng(animatedLatitude,animatedLongitude);

    final pickupMarker = Marker(
      markerId: MarkerId("${currentLocationCamera.latitude}"),
      position: LatLng(
          currentLocationCamera.latitude, currentLocationCamera.longitude),
      icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/ic_bustrackimage.png', 70)),
    );

    //Adding a delay and then showing the marker on screen
    await Future.delayed(const Duration(milliseconds: 500));

    _markers.add(pickupMarker);
    _mapMarkerSink.add(_markers);

  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  animateCar(
      double fromLat, //Starting latitude
      double fromLong, //Starting longitude
      double toLat, //Ending latitude
      double toLong, //Ending longitude
      StreamSink<List<Marker>>
      mapMarkerSink, //Stream build of map to update the UI
      TickerProvider
      provider, //Ticker provider of the widget. This is used for animation
      GoogleMapController controller, //Google map controller of our widget
      ) async {
    final double bearing =
    getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));
    print('fromlat $fromLat');
    print('fromLong $fromLong');
    print('toLat $toLat');
    print('toLong $toLong');

    _markers.removeWhere((m) => m.markerId.value == 'Vehicle Current Location');
      // _markers.clear();




    var carMarker = Marker(
        markerId: const MarkerId("Vehicle Current Location"),
        
        position: LatLng(fromLat, fromLong),
        icon: BitmapDescriptor.fromBytes(
            await getBytesFromAsset('assets/images/ic_bustrackimage.png', 60)),
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: bearing,
        draggable: false);

    //Adding initial marker to the start location.
    _markers.add(carMarker);
    mapMarkerSink.add(_markers);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 5), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(_controller2!)
      ..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation!.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        //Removing old marker if present in the marker array
        if (_markers.contains(carMarker)) _markers.remove(carMarker);

        //New marker location
        carMarker = Marker(
            markerId: const MarkerId("Vehicle Current Location"),
            position: newPos,
             infoWindow: InfoWindow( //popup info 
    title: Locations,
    // snippet: 'My Custom Subtitle',
  ),
            icon: BitmapDescriptor.fromBytes(
                await getBytesFromAsset('assets/images/ic_bustrackimage.png', 50)),
            anchor: const Offset(0.5, 0.5),
            flat: true,
            rotation: bearing,
            draggable: false);

        //Adding new marker to our list and updating the google map UI.
        _markers.add(carMarker);
        mapMarkerSink.add(_markers);



        //Moving the google camera to the new animated location.

        // controller.animateCamera(CameraUpdate.newCameraPosition(
        //     CameraPosition(target: newPos, zoom: 15.5, tilt: 30,
        //       bearing: 10,)));

        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newPos,zoom: 15.2)));
      });

    //Starting the animation
    _controller2?.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 270;
    }
    return -1;
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
  @override
  void dispose() {
    _everySecond?.cancel();
    _controller2?.stop();
    _controller2?.dispose();
    mapController = Completer();
    super.dispose();
  }

}
