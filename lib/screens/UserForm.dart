import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

typedef OnDelete = Function();
typedef OnAddLocation = Function();

class UserForm extends StatefulWidget {
  List<Map<String, dynamic>>  user;
  final state = _UserFormState();
  final OnDelete onDelete;
  final OnAddLocation onAddLocation;

  UserForm({Key? key, required this.user, required this.onDelete,required this.onAddLocation}) : super(key: key);
  @override
  _UserFormState createState() => state;

  bool isValid() => state.validate();
}

class _UserFormState extends State<UserForm> {
  final form = GlobalKey<FormState>();
  final _pointnameController = TextEditingController();
  TextEditingController pointEditingController = TextEditingController();
  String location = 'Null, Press Button';
  String Address = 'Fetching Location...';
  String Addressval = 'Fetching Location...';
  var currentLocationLatitude;
  var currentLocationLongitude;
  String dropaddress = "";
  String droplat = "";
  String droplng = "";
  String pointname = "";
  @override
  void initState() {
    super.initState();
    print(widget.user[0]['dropaddress']);
    dropaddress = widget.user[0]['dropaddress'].toString();
    droplat = widget.user[0]['droplat'].toString();
    droplng = widget.user[0]['droplng'].toString();
    //pointname=_pointnameController.text.toString();
    getaddress();
  }

  String stopaddress() {
    print("stopadress");
    print(Addressval);
    return Addressval;
  }


  getaddress() async {
    Position position = await _getGeoLocationPositionforaddress();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    print("location lat");
    print(location);
    var addressval = GetAddressFromLatLongforaddress(position);
    return addressval;

  }

  Future<String> GetAddressFromLatLongforaddress(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocationLatitude = position.latitude.toString();
    currentLocationLongitude = position.longitude.toString();
    print(placemarks);
    Placemark place = placemarks[0];
    Addressval =
    '${place.name}, ${place.thoroughfare},${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode},${place.country}.';
    print('Address -  $Addressval');

    return Addressval;
  }

  Future<Position> _getGeoLocationPositionforaddress() async {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        color: Colors.cyan.shade50,
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
           children: [
             Align(
                 alignment: Alignment.centerRight,
                 child:  IconButton(
                   icon: const Icon(Icons.delete),
                   onPressed: widget.onDelete,
                   color: Colors.black54,
                 ),
             ),
             Padding(
               padding: const EdgeInsets.all(10),
               child: Row(
                 children: [
                   Expanded(
                     flex: 4,
                     child: SizedBox(
                       width: 250,
                       child: Column(
                         children: [
                           TextFormField(
                           // controller: pointEditingController,
                             initialValue: "",
                             onSaved: (val) =>  pointname,
                             decoration: InputDecoration(
                               enabledBorder: OutlineInputBorder(
                                   borderSide:
                                   const BorderSide(color: Colors.cyan),
                                   borderRadius: BorderRadius.circular(4)),
                               border: const OutlineInputBorder(),
                               labelText: 'Point Name',
                               hintText: 'Point Name',
                               isDense: true,

                             ),
                             onChanged: (value) => pointname = value,
                           ),

                           const SizedBox(
                             height: 10,
                           ),
                           TextFormField(
                             readOnly: true,
                             initialValue: dropaddress,
                             onSaved: (val) => dropaddress,
                             decoration: InputDecoration(
                               enabledBorder: OutlineInputBorder(
                                   borderSide:
                                   const BorderSide(color: Colors.cyan),
                                   borderRadius: BorderRadius.circular(4)),
                               border: const OutlineInputBorder(),
                               labelText: 'Location',
                               hintText: 'Location',
                               isDense: true,
                             ),
                           ),
                           const SizedBox(
                             height: 10,
                           ),
                           Row(
                             children: [

                               Expanded(
                                 flex: 2,
                                 child: TextFormField(
                                   readOnly: true,
                                   initialValue: droplat,
                                   onSaved: (val) =>droplat,
                                   decoration: InputDecoration(
                                     enabledBorder: OutlineInputBorder(
                                         borderSide:
                                         const BorderSide(color: Colors.cyan),
                                         borderRadius: BorderRadius.circular(4)),
                                     border: const OutlineInputBorder(),
                                     labelText: 'Latitude',
                                     hintText: 'Latitude',
                                     isDense: true,
                                   ),
                                 ),
                               ),
                               const SizedBox(
                                 width: 5,
                               ),
                               Expanded(
                                 flex: 2,
                                 child: TextFormField(
                                   readOnly: true,
                                   initialValue: droplng,
                                   onSaved: (val) => droplng,
                                   decoration: InputDecoration(
                                     enabledBorder: OutlineInputBorder(
                                         borderSide:
                                         const BorderSide(color: Colors.cyan),
                                         borderRadius: BorderRadius.circular(4)),
                                     border: const OutlineInputBorder(),
                                     labelText: 'Longitude',
                                     hintText: 'Longitude',
                                     isDense: true,
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
                             CircleAvatar(
                               backgroundColor: Colors.cyan,
                               radius: 20,
                               child: IconButton(
                                 padding: EdgeInsets.zero,
                                 icon: const Icon(Icons.location_on_outlined),
                                 color: Colors.white,
                                 onPressed: (){
                                   getcurrentlocation();

                                 },
                               ),
                             ),
                           ],
                         ),
                       )),
                 ],
               ),
             ),
           ],

        /*    children: <Widget>[
              AppBar(
                leading: Icon(Icons.verified_user),
                elevation: 0,
                title: Text('Stops'),
                backgroundColor: Theme.of(context).accentColor,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                    color: Colors.white,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextFormField(
                  initialValue: widget.user.Address,
                  onSaved: (val) => widget.user.Address = val!,
                  validator: (val) =>
                  val!.length > 3 ? null : 'Full name is invalid',
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    icon: Icon(Icons.person),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                child: TextFormField(
                  initialValue: widget.user.Latitude,
                  onSaved: (val) => widget.user.Latitude = val!,
                  validator: (val) =>
                  val!.contains('@') ? null : 'Email is invalid',
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    icon: Icon(Icons.email),
                    isDense: true,
                  ),
                ),
              )
            ],*/
          ),
        ),
      ),
    );
  }

  getcurrentlocation() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
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


  ///form validator
  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }
}