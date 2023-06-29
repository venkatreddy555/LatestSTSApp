/// VehicleId : "4"
/// VehicleName : "Nanakramguda-II-TSO7UF6675"
/// Ignition : "Off"
/// livedate : "04-02-2023 12:30:58"
/// speed : "0"
/// Latitude : "17.4048"
/// Longitude : "78.3479"
/// Location : "Future Kids School Rd, Financial District, Nanakram Guda, Hyderabad, Telangana 500032, India"
/// fromStatus : "Stop"
/// statuscolor : "Red"
/// Direction : "w"
/// sincefrom : "04-02-2023 07:52:24"
/// DriverName : ""
/// MobileNo : ""

class LiveTrackingDataModelClass {
  LiveTrackingDataModelClass({
      String? vehicleId, 
      String? vehicleName, 
      String? ignition, 
      String? livedate, 
      String? speed, 
      String? latitude, 
      String? longitude, 
      String? location, 
      String? fromStatus, 
      String? statuscolor, 
      String? direction, 
      String? sincefrom, 
      String? driverName, 
      String? mobileNo,}){
    _vehicleId = vehicleId;
    _vehicleName = vehicleName;
    _ignition = ignition;
    _livedate = livedate;
    _speed = speed;
    _latitude = latitude;
    _longitude = longitude;
    _location = location;
    _fromStatus = fromStatus;
    _statuscolor = statuscolor;
    _direction = direction;
    _sincefrom = sincefrom;
    _driverName = driverName;
    _mobileNo = mobileNo;
}

  LiveTrackingDataModelClass.fromJson(dynamic json) {
    _vehicleId = json['VehicleId'];
    _vehicleName = json['VehicleName'];
    _ignition = json['Ignition'];
    _livedate = json['livedate'];
    _speed = json['speed'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
    _location = json['Location'];
    _fromStatus = json['fromStatus'];
    _statuscolor = json['statuscolor'];
    _direction = json['Direction'];
    _sincefrom = json['sincefrom'];
    _driverName = json['DriverName'];
    _mobileNo = json['MobileNo'];
  }
  String? _vehicleId;
  String? _vehicleName;
  String? _ignition;
  String? _livedate;
  String? _speed;
  String? _latitude;
  String? _longitude;
  String? _location;
  String? _fromStatus;
  String? _statuscolor;
  String? _direction;
  String? _sincefrom;
  String? _driverName;
  String? _mobileNo;
LiveTrackingDataModelClass copyWith({  String? vehicleId,
  String? vehicleName,
  String? ignition,
  String? livedate,
  String? speed,
  String? latitude,
  String? longitude,
  String? location,
  String? fromStatus,
  String? statuscolor,
  String? direction,
  String? sincefrom,
  String? driverName,
  String? mobileNo,
}) => LiveTrackingDataModelClass(  vehicleId: vehicleId ?? _vehicleId,
  vehicleName: vehicleName ?? _vehicleName,
  ignition: ignition ?? _ignition,
  livedate: livedate ?? _livedate,
  speed: speed ?? _speed,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  location: location ?? _location,
  fromStatus: fromStatus ?? _fromStatus,
  statuscolor: statuscolor ?? _statuscolor,
  direction: direction ?? _direction,
  sincefrom: sincefrom ?? _sincefrom,
  driverName: driverName ?? _driverName,
  mobileNo: mobileNo ?? _mobileNo,
);
  String? get vehicleId => _vehicleId;
  String? get vehicleName => _vehicleName;
  String? get ignition => _ignition;
  String? get livedate => _livedate;
  String? get speed => _speed;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get location => _location;
  String? get fromStatus => _fromStatus;
  String? get statuscolor => _statuscolor;
  String? get direction => _direction;
  String? get sincefrom => _sincefrom;
  String? get driverName => _driverName;
  String? get mobileNo => _mobileNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['VehicleId'] = _vehicleId;
    map['VehicleName'] = _vehicleName;
    map['Ignition'] = _ignition;
    map['livedate'] = _livedate;
    map['speed'] = _speed;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    map['Location'] = _location;
    map['fromStatus'] = _fromStatus;
    map['statuscolor'] = _statuscolor;
    map['Direction'] = _direction;
    map['sincefrom'] = _sincefrom;
    map['DriverName'] = _driverName;
    map['MobileNo'] = _mobileNo;
    return map;
  }

}