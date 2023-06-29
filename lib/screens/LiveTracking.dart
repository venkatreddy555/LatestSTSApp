import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schooltrackingsystem/datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:schooltrackingsystem/datamodelclass/GetPointMasterDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/LiveTrackingDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/Vehiclepoints.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:location/location.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  LiveTrackingState createState() => LiveTrackingState();
}

class LiveTrackingState extends State<LiveTracking> {
  final Completer<GoogleMapController> _controller = Completer();
  List<Vehiclepoints> viapoints = <Vehiclepoints>[];
  List<Vehiclepoints> viapoints_latlangs = <Vehiclepoints>[];
  var wayPoints = "";
  double lattitude = 0.0;
  double Lonitude = 0.0;
  double lat = 17.4053;
  double lng = 78.3493;
  var PointLatitude;
  var PointLongitude;
  final List<Marker> _markers = [];
  final List<Marker> _markersallpoints = [];
  final List<Marker> _markersdestinationpoint = [];
  var googleMap = GoogleMap;
  var PointName;
  List<Marker> CCtvMarkers = [];
  var currentLocationMarker_Source = Marker;
  var markerPlaces = [];
  List<GetPointMasterDataModelClass> list = [];
  List<LiveTrackingDataModelClass> livetracklistdata = [];
  List<ChildrensProfilesDataModel> childrenlist = [];
  List<LatLng> latLen = [];
  List<LatLng> latLen2 = [];
  var rest = [];
  var icon;
  var destinationicon;
  bool isChecked = false;
  var RoleId;
  var MobileNumber;
  var StudentId;
  var EmployeeId;
  var VehicleId;
  var RouteId;
  var Latitude;
  var Longitude;
  var Locations;
  final Set<Polyline> _polyline = {};
  Map<String, dynamic> VehicleLoaction = {};
  Map<String, dynamic> VehicleTempData = {};
  List<dynamic> FinalPointData = [{}];
  LocationData? currentLcotion;
  Timer? _everySecond;
  double pinPillPosition = -100;
  Location location = Location();
  int numDeltas = 50; //number of delta to devide total distance
  int delay = 50; //milliseconds of delay to pass each delta
  var i = 0;
  var position;
  Animation<double>? _animation;
  GoogleMapController? _controller1;

  @override
  void initState() {
    getIcons();
    getdestinationIcons();
    location.onLocationChanged.listen(
            (LocationData cLoc) {
          // cLoc contains the lat and long of the
          // current user's position in real time,
          // so we're holding on to it
              currentLcotion = cLoc;
          updatePinOnMap();
        });
    super.initState();
  }
  //
  // void getCurrentLocation() async {
  //
  //   Location location = new Location();
  //   location.getLocation().then((location) {
  //     currentLcotion = location;
  //     print('currentLocation ${currentLcotion!.latitude!}, ${currentLcotion!.longitude!}');
  //   });
  //   GoogleMapController googleMapController=await _controller.future;
  //   location.onLocationChanged.listen((newLoc) {
  //     currentLcotion=newLoc;
  //     if(Latitude!=null && Longitude!=null){
  //       googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 15.4,target: LatLng(double.parse(Latitude),double.parse(Longitude),))),);
  //       // var latLng=LatLng(double.parse(Latitude),double.parse(Longitude));
  //       // Marker marker = _markersallpoints[0];
  //       // AnimateMarker(onMarkerPosUpdate: (Marker marker) {
  //       //   setState(() {
  //       //     _markersallpoints[0] = marker;
  //       //   });
  //       // }).animaterMarker(marker.position, latLng, destinationicon);
  //     }else{
  //       googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 15.4,bearing: 30,target: LatLng(newLoc.latitude!,newLoc.longitude!,))),);
  //       setState(() {
  //         _markersallpoints.add(Marker(
  //             markerId: MarkerId('current Location'),
  //             draggable: false,
  //             position: LatLng(newLoc.latitude!, newLoc.longitude!),
  //             infoWindow:
  //             InfoWindow(title: Locations),
  //             icon: destinationicon));
  //
  //       });
  //     }
  //
  //
  //
  //   });
  // }



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

   updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
     if(Latitude!=null && Longitude!=null){
       CameraPosition cPosition = CameraPosition(
         zoom: 15.6,
         tilt: 80,
         bearing: 30,
         target: LatLng(double.parse(Latitude!),double.parse(Longitude)),
       );
       final GoogleMapController controller = await _controller.future;
       controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
     }else{
       CameraPosition cPosition = CameraPosition(
         zoom: 15.6,
         tilt: 80,
         bearing: 30,
         target: LatLng(lat,lng),
       );
       final GoogleMapController controller = await _controller.future;
       controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
     }

    // // do this inside the setState() so Flutter gets notified
    // // that a widget update is due
    setState(() {
      _markersallpoints.removeWhere((m) => m.markerId.value == 'Vehicle Current Location');
      _markersallpoints.add(Marker(
          markerId: const MarkerId('Vehicle Current Location'),
          onTap: () {
            setState(() {
              // currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: LatLng(lat,lng), // updated position
          icon: destinationicon));
    });
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
    print("requestBody ${res.body}");
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

    print('viapointslengthpoints ${viapoints.length}');
    return list;
  }


  Future<List<LiveTrackingDataModelClass>> _vehicleservice(VehicleId) async {
    RoleId = await SaveSharedPreference.getRoleId();
    Map<String, String> data;
    if (RoleId == "4" || RoleId == "5") {
      // VehicleID=SaveSharedPreference.sessionData!!.getVehicleId()
    }
    data = {'VehicleId': '3'};
    var res = await CallApi().postData(data, 'STS/LiveTracking');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    rest = body["Data"] as List;
    Latitude = rest[0]['Latitude'];
    Longitude = rest[0]['Longitude'];
    Locations = rest[0]['Location'];
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
    setState(() {
      // getCurrentLocation();
      _pickpoints_Stops(RouteId);
    });


    livetracklistdata = rest
        .map<LiveTrackingDataModelClass>(
            (json) => LiveTrackingDataModelClass.fromJson(json))
        .toList();
    print('viapointslength ${viapoints.length}');
    return livetracklistdata;
  }

  Future<List<ChildrensProfilesDataModel>> getchildrenData() async {
    MobileNumber = await SaveSharedPreference.getMobileNumber();
    print(MobileNumber);
    var data = {'MobileNumber': MobileNumber};
    var res = await CallApi().postData(data, 'STS/GetChildrens');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);

    var rest = body["Data"] as List;
    print(rest);


    childrenlist = rest
        .map<ChildrensProfilesDataModel>(
            (json) => ChildrensProfilesDataModel.fromJson(json))
        .toList();


    return childrenlist;
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
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    print(body);
    if (responsecode == "1") {
      VehicleId = body['VehicleId'].toString();
      print('vehicleId $VehicleId');
      RouteId = body['RouteId'].toString();
      _everySecond = Timer.periodic(const Duration(seconds: 10), (Timer t) {
          _vehicleservice(VehicleId);
      });




    } else {
      VehicleId = '';
      print('vehicleId $VehicleId');
      showSnackBar(context, "Vehicle Not assigned");
    }
  }

  transition(result){
    i = 0;
    Latitude = (result[0] - position[0])/numDeltas;
    Longitude = (result[1] - position[1])/numDeltas;
    moveMarker();
  }

  moveMarker(){
    position[0] += Latitude;
    position[1] += Longitude;
    var latlng = LatLng(position[0], position[1]);

    _markersallpoints.add(Marker(
        markerId: const MarkerId('Vehicle Current Location'),
        position: latlng, // updated position
        icon: destinationicon));
    setState(() {
      //refresh UI
    });

    if(i!=numDeltas){
      i++;
      Future.delayed(Duration(milliseconds: delay), (){
        moveMarker();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // on below line we are specifying our camera position

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
                  color: Colors.white,
                ),
                iconSize: 20.0,
                onPressed: () {
                  _goBack(context);
                },
              ),
              title: const Text('Live Tracking')),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 15.4,
                ),
                mapType: MapType.normal,
                myLocationEnabled: false,
                compassEnabled: true,
                polylines: _polyline,
                markers: Set<Marker>.of(_markersallpoints),
                onMapCreated: (GoogleMapController mapController) {
                  _controller.complete(mapController);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: getchildrenData(),
                          builder: (context, snapshot) {
                            return snapshot.data != null
                                ? DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.cyan),
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
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Checkbox(
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                                if (value == true) {
                                  print("1");
                                  setState(() {
                                    for (int i = 0; i < list.length; i++) {
                                      try {
                                        setState(() {
                                          if(list[i].pointID=='0' && list[i].pointName=='Vehicle Current Location'){
                                            print('position 0');
                                            _markersallpoints.add(Marker(
                                                markerId:
                                                MarkerId(list[i].pointID!),
                                                draggable: false,
                                                position: LatLng(
                                                    double.parse(
                                                        list[i].latitude!),
                                                    double.parse(
                                                        list[i].longitude!)),
                                                infoWindow: InfoWindow(
                                                    title: list[i].pointName!),
                                                icon: destinationicon));
                                            latLen.add(LatLng(
                                                double.parse(list[i].latitude!),
                                                double.parse(
                                                    list[i].longitude!)));
                                          }else{
                                            _markersallpoints.add(Marker(
                                                markerId:
                                                MarkerId(list[i].pointID!),
                                                draggable: false,
                                                position: LatLng(
                                                    double.parse(
                                                        list[i].latitude!),
                                                    double.parse(
                                                        list[i].longitude!)),
                                                infoWindow: InfoWindow(
                                                    title: list[i].pointName!),
                                                icon: icon));
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
                                      color: Colors.black.withAlpha(500),
                                      width: 3,
                                    ));
                                  });
                                } else {
                                  print("0");
                                  setState(() {
                                    _markersallpoints.clear();
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
          )),
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
