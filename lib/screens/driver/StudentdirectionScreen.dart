import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schooltrackingsystem/datamodelclass/GetRouteinformationDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/ViewRouteonMapsDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:location/location.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';

class StudentdirectionScreen extends StatefulWidget {
  static const id = "HOME_SCREEN";

  const StudentdirectionScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StudentdirectionScreen>
    with TickerProviderStateMixin {
  List<GetRouteinformationDataModelClass> routeinfolist = [];
  List<ViewRouteonMapsDataModelClass> viewroutelist = [];
  var RoleId;
  var EmployeeId;
  var Locations;
  var RouteId;
  List<LatLng> latLen = [];
  final Set<Polyline> _polyline = {};
  Location location = Location();
  LocationData? currentLcotion;
  List<LatLng> lastpointlat = [];
  List<LatLng> lastpointlng = [];
  bool isVisiblechildrenName = true;
  final _mapMarkerSC = StreamController<List<Marker>>();
  var tempvehicleLatitude=17.40041;
  var  tempvehicleLongitude=78.40594;
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  double StartPointLatitude=0.0;
  double StartPointLongitude=0.0;
  double EndPointLatitude =0.0;
  double EndPointLongitude=0.0 ;
  var StartPointAddress ;
  var EndPointAddress ;

  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  var icon;

  static const CameraPosition _UserLocation = CameraPosition(
    target: LatLng(17.40041,78.40594),
    //target: LatLng(26.0667, 50.5577),
    zoom: 12,
  );

  @override
  void initState() {
    getIcons();

    super.initState();
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/placeholder.png");
    setState(() {
      this.icon = icon;
    });
  }

  Future<List<GetRouteinformationDataModelClass>> _routeinfo(routeId) async {
    Map<String, dynamic> data;
    if (routeId == null) {
      data = {
        'RouteId': '',
      };
    } else {
      data = {'RouteId': routeId};
    }
    var res = await CallApi().postData(data, 'STS/GetRoutes');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);

    var rest = body["Data"] as List;
     StartPointLatitude = double.parse(rest[0]['StartPointLatitude']);
     StartPointLongitude = double.parse(rest[0]['StartPointLongitude']);
     EndPointLatitude = double.parse(rest[0]['EndPointLatitude']);
     EndPointLongitude = double.parse(rest[0]['EndPointLongitude']);
     StartPointAddress = rest[0]['StartPointAddress'];
     EndPointAddress = rest[0]['EndPointAddress'];

     print('StartPointLatitude $StartPointLatitude');
     print('StartPointLongitude $StartPointLongitude');
     print('EndPointLatitude $EndPointLatitude');
     print('EndPointLongitude $EndPointLongitude');

    print(rest);

      _getPolyline();

    routeinfolist = rest
        .map<GetRouteinformationDataModelClass>(
            (json) => GetRouteinformationDataModelClass.fromJson(json))
        .toList();

    return routeinfolist;
  }

  Future<List<ViewRouteonMapsDataModelClass>> getroutemasterData() async {
     var BranchId= await SaveSharedPreference.getBranchId();
    var data = {'ActionName': 'Type','BranchId':BranchId};
    var res = await CallApi().postData(data, 'STS/RouteMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);

    var rest = body["Data"] as List;
    print(rest);


    viewroutelist = rest
        .map<ViewRouteonMapsDataModelClass>(
            (json) => ViewRouteonMapsDataModelClass.fromJson(json))
        .toList();
    return viewroutelist;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocationCamera = CameraPosition(
      target: LatLng(tempvehicleLatitude, tempvehicleLongitude),
      zoom: 15.4,
    );

    final googleMap = StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _UserLocation,
              polylines: _polyline,
              markers: Set<Marker>.of(markers.values),
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                setState(() {});
              });

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
            title: const Text('View Route Maps')),
        body: Stack(
          children: [
            googleMap,
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    FutureBuilder(
                        future: getroutemasterData(),
                        builder: (context, snapshot) {
                          return snapshot.data != null
                              ? Visibility(
                                  visible: isVisiblechildrenName,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  13, 191, 194, 1)),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Routes',
                                      hintText: 'Select Route',
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        print("onchamged $newValue");
                                        _polyline.clear();
                                        markers.clear();
                                        _routeinfo(newValue);
                                        final split = newValue!.split(',');
                                        final Map<int, String> values = {
                                          for (int i = 0; i < split.length; i++)
                                            i: split[i]
                                        };
                                        print(values);
                                        RouteId = values[0];
                                        print('RouteListId $RouteId');
                                      });
                                    },
                                    items: viewroutelist.map(
                                        (ViewRouteonMapsDataModelClass map) {
                                      return DropdownMenuItem<String>(
                                        value: map.routeId.toString(),
                                        child: Text(
                                          "${map.routeName}",
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator());
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    /// add origin marker origin marker
    _addMarker(
      LatLng(StartPointLatitude, StartPointLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(EndPointLatitude, EndPointLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );


    latLen = [
      LatLng(StartPointLatitude, StartPointLongitude),
      LatLng(EndPointLatitude, EndPointLongitude),

    ];


    setState(() {

    });
    _polyline.add(
        Polyline(
          polylineId: const PolylineId('1'),
          points: latLen,
          color: Colors.green,
          width: 3,
        )
    );

  }

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

  _goBack(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const DashBoardScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

