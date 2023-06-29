import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/AddRouteDataModel.dart';
import 'package:schooltrackingsystem/datamodelclass/EmptyState.dart';
import 'package:schooltrackingsystem/datamodelclass/ViewAllRoutesEditDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/screens/UserForm.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';

class AddNewRoute extends StatefulWidget {
  final ViewAllRoutesEditDataModelClass article;
  const AddNewRoute(this.article, {super.key});

  @override
  _AddNewRouteState createState() => _AddNewRouteState(article);
}

class _AddNewRouteState extends State<AddNewRoute> {
  final ViewAllRoutesEditDataModelClass article;
  _AddNewRouteState(this.article);
  final _RouteNameEditingController = TextEditingController();
  final _StartpointnameEditingController = TextEditingController();
  final _StartpointAddressEditingController = TextEditingController();
  final _startpointLatitudeEditingController = TextEditingController();
  final _startpointLongitudeEditingController = TextEditingController();
  final _EndpointLongitudeEditingController = TextEditingController();
  final _EndpointLatitudeEditingController = TextEditingController();
  final _EndpointAddressEditingController = TextEditingController();
  final _EndpointnameEditingController = TextEditingController();
  String location = 'Null, Press Button';
  String Address = 'Fetching Location...';
  var currentLocationLatitude;
  var currentLocationLongitude;
  List<UserForm> users = [];
  bool startvalues = false;
  var RouteId;
  var RouteIds;
  bool submit=false;
  bool addstops=false;
  bool routenameenable=false;
  bool startpointnameenable=false;
  bool startpointaddressenable=false;
  bool startpointlatitudeenable=false;
  bool startpointlongitudeenable=false;
  bool endpointnameenable=false;
  bool endpointaddressenable=false;
  bool endpointlatitudeenable=false;
  bool endpointlongitudeenable=false;
  var Action;
  var listlatitude;
  var listlongitude;

  @override
  void initState() {
    super.initState();
    print('articlerouteId ${article.routeId}');
    if(article.routeId == null){
      submit=true;
      Action = 'save';
      RouteIds = '';
      routenameenable=true;
      startpointnameenable=true;
      startpointaddressenable=true;
      startpointlatitudeenable=true;
      startpointlongitudeenable=true;
      endpointnameenable=true;
      endpointaddressenable=true;
      endpointlatitudeenable=true;
      endpointlongitudeenable=true;
    }else{
      submit=false;
      addstops=true;
      Action = 'update';
      RouteIds = article.routeId;
      _RouteNameEditingController.text=article.routeName!;
      _StartpointnameEditingController.text=article.startPointName!;
      _StartpointAddressEditingController.text=article.startPointAddress!;
      _startpointLatitudeEditingController.text=article.startPointLatitude!;
      _startpointLongitudeEditingController.text=article.startPointLongitude!;
      _EndpointnameEditingController.text=article.endPointName!;
      _EndpointAddressEditingController.text=article.endPointAddress!;
      _EndpointLatitudeEditingController.text=article.endPointLatitude!;
      _EndpointLongitudeEditingController.text=article.endPointLongitude!;
      routenameenable=false;
      startpointnameenable=false;
      startpointaddressenable=false;
      startpointlatitudeenable=false;
      startpointlongitudeenable=false;
      endpointnameenable=false;
      endpointaddressenable=false;
      endpointlatitudeenable=false;
      endpointlongitudeenable=false;
      startvalues=true;
    }

    getcurrentlocation();
  }

  getcurrentlocation() async {
    print("calling location->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    Position position = await _getGeoLocationPosition();
    
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    listlatitude=position.latitude;
    listlongitude=position.longitude;
    print("location lat");
    print(location);
    GetAddressFromLatLong(position);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocationLatitude = position.latitude.toString();
    currentLocationLongitude = position.longitude.toString();
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        '${place.name}, ${place.thoroughfare},${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode},${place.country}.';
    print('Address -  $Address');
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

  Future<void> clickOnParentRequest(BuildContext context) async {
    if (_RouteNameEditingController.text.isEmpty) {
      showErrorDialog(context, 'Route Name can\'t be empty.');
    } else if (_StartpointnameEditingController.text.isEmpty) {
      showErrorDialog(context, 'Start Point Name can\'t be empty.');
    } else if (_StartpointAddressEditingController.text.isEmpty) {
      showErrorDialog(context, 'StartPoint Address can\'t be empty.');
    }else if(_EndpointnameEditingController.text.isEmpty){
      showErrorDialog(context, 'EndPoint Name  can\'t be empty.');
    } else if (_EndpointAddressEditingController.text.isEmpty) {
      showErrorDialog(context, 'EndPoint Address  can\'t be empty.');
    }else{
      _saveRoutedata();
    }
    // } else if (_MobileNumberEditingController.text.toString().length < 10) {
    //   showErrorDialog(context, 'Enter valid 10 digit Mobile Number');
    // } else if (!regExp
    //     .hasMatch(_MobileNumberEditingController.text.toString())) {
    //   showErrorDialog(context, 'Enter valid Mobile Number');
    // } else if (imgFile == null) {
    //   showErrorDialog(context, 'Upload Your Id');
    // } else if (CategoryListId == null) {
    //   showErrorDialog(context, 'Select Category');
    // } else if (ChildrenListId == null) {
    //   showErrorDialog(context, 'Select Children');
    // } else if (RouteListId == null) {
    //   showErrorDialog(context, 'Select RouteName');
    // } else if (RoutePointListId == null) {
    //   showErrorDialog(context, 'Select PointName');
    // } else {
    //   _parentrequestdetails();
    // }
  }

  Widget CategoryList() {
    return WillPopScope(
      onWillPop: () async {
        // show the snackbar with some text
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          margin: const EdgeInsets.only(right: 15, left: 15),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  maxLines: 1,
                  controller: _RouteNameEditingController,
                  enabled: routenameenable,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Route Name',
                    hintText: 'Enter Route Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  maxLines: 1,
                  controller: _StartpointnameEditingController,
                  enabled: startpointnameenable,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Start Point Name',
                    hintText: 'Enter Start Point Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        width: 250,
                        child: Column(
                          children: [
                            TextField(
                              maxLines: 4,
                              readOnly: true,
                              controller: _StartpointAddressEditingController,
                              enabled: startpointaddressenable,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.cyan),
                                    borderRadius: BorderRadius.circular(4)),
                                border: const OutlineInputBorder(),
                                labelText: 'Start Point Address',
                                hintText: 'Select Start Point Address',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    maxLines: 1,
                                    readOnly: true,
                                    controller: _startpointLatitudeEditingController,
                                    enabled: startpointlatitudeenable,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.cyan),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Start Point Latitude',
                                      hintText: 'Latitude',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    maxLines: 1,
                                    readOnly: true,
                                    controller: _startpointLongitudeEditingController,
                                    enabled: startpointlongitudeenable,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.cyan),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Start Point Longitude',
                                      hintText: 'Longitude',
                                    ),
                                  ),
                                )
                              ],
                            )
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
                              // InkWell(
                              //   child: IconButton(
                              //     icon: Icon(
                              //       Icons.edit,
                              //       color: Colors.cyan,
                              //     ),
                              //     onPressed: () {
                              //     },
                              //   ),
                              // ),
                              CircleAvatar(
                                backgroundColor: Colors.cyan,
                                radius: 20,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.location_on_outlined),
                                  color: Colors.white,
                                  onPressed: () {
                                      setState(() {
                                        if(article.routeId==null){
                                          startvalues = true;
                                          _StartpointAddressEditingController
                                              .text =
                                              Address.toString();
                                          _startpointLatitudeEditingController
                                              .text =
                                              currentLocationLatitude.toString();
                                          _startpointLongitudeEditingController
                                              .text =
                                              currentLocationLongitude.toString();
                                        }else{
                                          showSnackBar(context, 'Start Point Address can\'t be changed');
                                        }

                                      });

                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: users.isEmpty
                    ? Center(
                        child: EmptyState(
                          title: 'Oops',
                          message: 'Add Start point first then add Stops form by tapping add button below',
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        addAutomaticKeepAlives: true,
                        itemCount: users.length,
                        itemBuilder: (_, i) => users[i],
                      ),
              ),
              FloatingActionButton(

                onPressed: startvalues ? onAddForm : null,
                foregroundColor: Colors.white,

                child: const Icon(Icons.add),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  maxLines: 1,
                  controller: _EndpointnameEditingController,
                  enabled: endpointnameenable,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'End Point Name',
                    hintText: 'Enter End Point Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        width: 250,
                        child: Column(
                          children: [
                            TextField(
                              maxLines: 4,
                              readOnly: true,
                              controller: _EndpointAddressEditingController,
                              enabled: endpointaddressenable,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.cyan),
                                    borderRadius: BorderRadius.circular(4)),
                                border: const OutlineInputBorder(),
                                labelText: 'End Point Address',
                                hintText: 'Select End Point Address',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    maxLines: 1,
                                    readOnly: true,
                                    controller:
                                        _EndpointLatitudeEditingController,
                                    enabled: endpointlatitudeenable,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.cyan),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      border: const OutlineInputBorder(),
                                      labelText: 'End Point Latitude',
                                      hintText: 'Latitude',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    maxLines: 1,
                                    readOnly: true,
                                    controller:
                                        _EndpointLongitudeEditingController,
                                    enabled: endpointlongitudeenable,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.cyan),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      border: const OutlineInputBorder(),
                                      labelText: 'End Point Longitude',
                                      hintText: 'Longitude',
                                    ),
                                  ),
                                )
                              ],
                            )
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
                              // InkWell(
                              //   child: IconButton(
                              //     icon: Icon(
                              //       Icons.edit,
                              //       color: Colors.cyan,
                              //     ),
                              //     onPressed: () {
                              //     },
                              //   ),
                              // ),
                              CircleAvatar(
                                backgroundColor: Colors.cyan,
                                radius: 20,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.location_on_outlined),
                                  color: Colors.white,
                                  onPressed: () {
                                    if(article.routeId==null){
                                      getcurrentlocation();
                                      setState(() {
                                        _EndpointLongitudeEditingController.text =
                                            currentLocationLongitude;
                                        _EndpointLatitudeEditingController.text =
                                            currentLocationLatitude;
                                        _EndpointAddressEditingController.text =
                                            Address;
                                      });
                                    }else{
                                      showSnackBar(context, 'End Point Address can\'t be changed');
                                    }

                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Visibility(visible:submit,
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            clickOnParentRequest(context);
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
                              'Submit',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )),
                  Visibility(visible:addstops,
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            // clickOnParentRequest(context);
                            print(users);
                            for(int i=0;i<users.length;i++){
                              var pointnumber=i+1;
                              print('pointnumber ${i+1}');
                              print('address ${users[i].state.dropaddress}');
                              print('latitude ${users[i].state.droplat}');
                              print('longitude ${users[i].state.droplng}');
                              print('pointname ${users[i].state.pointname}');
                              if(article.routeId==null){
                                _saveRoutestopsdata(pointnumber,users[i].state.pointname,users[i].state.dropaddress,users[i].state.droplat,users[i].state.droplng);
                              }else{
                                RouteId=article.routeId;
                                _saveRoutestopsdata(pointnumber,users[i].state.pointname,users[i].state.dropaddress,users[i].state.droplat,users[i].state.droplng);
                              }

                            }
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
                              'Add Stops',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )),
                ],
              )


            ],
          ),
        ),
      ),
    );
  }

  ///on form user deleted
  void onDelete(AddRouteDataModel user) {
    print("on delete data");
    print(users.first.user);
    setState(() {
      for(int i=0;i<users.length;i++){
 users.removeAt(users.indexOf(users[i]));
      }
      // var find = users.firstWhere(
      //   (it) => it.user == _user,
      //   orElse: () => null!,
      // );
      // if (find != null) users.removeAt(users.indexOf(find));
    });
  }

  void ononAddLocation(AddRouteDataModel user) async{
     await getcurrentlocation();
    setState(() {
     
      if (users.isNotEmpty) {
        var allValid = true;
        for (var form in users) {
          allValid = allValid && form.isValid();
        }
        if (allValid) {
          var data = users.map((it) => it.user).toList();
          ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) => const ListTile(
              leading: CircleAvatar(
                child: Text(""),
              ),
              title: Text(""),
              subtitle: Text(""),
            ),
          );
        }
      }
    });
    // setState(() {
    //   var find = users.firstWhere(
    //         (it) => it.user == _user,
    //     orElse: () => null!,
    //   );
    //   if (find != null) users.removeAt(users.indexOf(find));
    // });
  }

  ///on add form
  void onAddForm() async {
      getcurrentlocation();
    var droplocation = Address;
    print("drop ponints");
    print(droplocation);
      List<Map<String, dynamic>> addressval = [{
      "dropaddress":droplocation,
      "droplat":listlatitude,
      "droplng":listlongitude,
      "pointname":"test"
    }];
    setState(() async {
      var user = await AddRouteDataModel();
       users.add(UserForm(
        user:  addressval,
        onDelete: () => onDelete(user),
        onAddLocation:() => ononAddLocation(user) ,
      ));
    });
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
    return Scaffold(
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
            title: const Text('Add Route')),
        body: CategoryList());
  }

  _goBack(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }

Future _saveRoutedata() async {
  var  UserId = await SaveSharedPreference.getUserId();
  var  BranchId = await SaveSharedPreference.getBranchId();
  var data = {
    'Action': Action,
    'BranchId': BranchId,
    'RouteName': _RouteNameEditingController.text.toString(),
    'StartPointName': _StartpointnameEditingController.text.toString(),
    'StartPointAddress': _StartpointAddressEditingController.text.toString(),
    'StartPointLatitude': _startpointLatitudeEditingController.text.toString(),
    'StartPointLongitude': _startpointLongitudeEditingController.text.toString(),
    'EndPointName': _EndpointnameEditingController.text.toString(),
    'EndPointAddress': _EndpointAddressEditingController.text.toString(),
    'EndPointLatitude': _EndpointLatitudeEditingController.text.toString(),
    'EndPointLongitude': _EndpointLongitudeEditingController.text.toString(),
    'NoOfStops': '',
    'CreatedBy': UserId,
    'RouteId': RouteIds,
  };
  var res = await CallApi().postData(data, 'STS/RoutesSave');
  var body = json.decode(res.body);
  var responsecode = body['Code'].toString();
  var responsemessage = body['Message'].toString();
  if (responsecode == "1") {
    RouteId=body['RouteId'].toString();
    if(RouteId!=null){
      print('RouteId $RouteId');
      setState(() {
        submit=false;
        addstops=true;
      });


    }else{
      showSnackBar(context, 'RouteId null');
    }


    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
    // showSnackBar(context, responsemessage);
  }else{
    showSnackBar(context, responsemessage);
  }
}

  Future _saveRoutestopsdata(PointNumber,Pointname,pointaddress,pointlat,pointlng) async {
    var  UserId = await SaveSharedPreference.getUserId();
    var  BranchId = await SaveSharedPreference.getBranchId();
    var data = {
      'Action': 'save',
      'RoutePointsId': '',
      'RouteId': RouteId,
      'PointNo': PointNumber,
      'PointName': Pointname,
      'PointAddress': pointaddress,
      'Latitude': pointlat,
      'Longitude': pointlng,
      'CreatedBy': UserId,
    };
    var res = await CallApi().postData(data, 'STS/RoutePointsSave');
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
}
