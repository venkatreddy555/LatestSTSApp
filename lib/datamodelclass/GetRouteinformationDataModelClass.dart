/// RouteId : "67"
/// BranchId : "39"
/// RouteName : "NSPG-Manikonda"
/// StartPointName : "Bhagyalaxmi Colony"
/// StartPointAddress : "Bhagyalaxmi colony,Madhapur"
/// StartPointLatitude : "17.460808134612318"
/// StartPointLongitude : "78.3976280116464"
/// EndPointName : "The future kids school"
/// EndPointAddress : "The future kids school Narsingi"
/// EndPointLatitude : "17.378558424111315"
/// EndPointLongitude : "78.36594971078335"
/// NoOfStops : "18"
/// RoutePointsId : "69"
/// PointNo : "1"
/// PointName : "Abinandana Exotic"
/// PointAddress : "Abinandana Exotic, A block 402, Behind Current Office, Manikonda"
/// Latitude : "17.406765463493233"
/// Longitude : "78.37871483887557"
/// CreatedBy : "1"

class GetRouteinformationDataModelClass {
  GetRouteinformationDataModelClass({
      String? routeId, 
      String? branchId, 
      String? routeName, 
      String? startPointName, 
      String? startPointAddress, 
      String? startPointLatitude, 
      String? startPointLongitude, 
      String? endPointName, 
      String? endPointAddress, 
      String? endPointLatitude, 
      String? endPointLongitude, 
      String? noOfStops, 
      String? routePointsId, 
      String? pointNo, 
      String? pointName, 
      String? pointAddress, 
      String? latitude, 
      String? longitude, 
      String? createdBy,}){
    _routeId = routeId;
    _branchId = branchId;
    _routeName = routeName;
    _startPointName = startPointName;
    _startPointAddress = startPointAddress;
    _startPointLatitude = startPointLatitude;
    _startPointLongitude = startPointLongitude;
    _endPointName = endPointName;
    _endPointAddress = endPointAddress;
    _endPointLatitude = endPointLatitude;
    _endPointLongitude = endPointLongitude;
    _noOfStops = noOfStops;
    _routePointsId = routePointsId;
    _pointNo = pointNo;
    _pointName = pointName;
    _pointAddress = pointAddress;
    _latitude = latitude;
    _longitude = longitude;
    _createdBy = createdBy;
}

  GetRouteinformationDataModelClass.fromJson(dynamic json) {
    _routeId = json['RouteId'];
    _branchId = json['BranchId'];
    _routeName = json['RouteName'];
    _startPointName = json['StartPointName'];
    _startPointAddress = json['StartPointAddress'];
    _startPointLatitude = json['StartPointLatitude'];
    _startPointLongitude = json['StartPointLongitude'];
    _endPointName = json['EndPointName'];
    _endPointAddress = json['EndPointAddress'];
    _endPointLatitude = json['EndPointLatitude'];
    _endPointLongitude = json['EndPointLongitude'];
    _noOfStops = json['NoOfStops'];
    _routePointsId = json['RoutePointsId'];
    _pointNo = json['PointNo'];
    _pointName = json['PointName'];
    _pointAddress = json['PointAddress'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
    _createdBy = json['CreatedBy'];
  }
  String? _routeId;
  String? _branchId;
  String? _routeName;
  String? _startPointName;
  String? _startPointAddress;
  String? _startPointLatitude;
  String? _startPointLongitude;
  String? _endPointName;
  String? _endPointAddress;
  String? _endPointLatitude;
  String? _endPointLongitude;
  String? _noOfStops;
  String? _routePointsId;
  String? _pointNo;
  String? _pointName;
  String? _pointAddress;
  String? _latitude;
  String? _longitude;
  String? _createdBy;
GetRouteinformationDataModelClass copyWith({  String? routeId,
  String? branchId,
  String? routeName,
  String? startPointName,
  String? startPointAddress,
  String? startPointLatitude,
  String? startPointLongitude,
  String? endPointName,
  String? endPointAddress,
  String? endPointLatitude,
  String? endPointLongitude,
  String? noOfStops,
  String? routePointsId,
  String? pointNo,
  String? pointName,
  String? pointAddress,
  String? latitude,
  String? longitude,
  String? createdBy,
}) => GetRouteinformationDataModelClass(  routeId: routeId ?? _routeId,
  branchId: branchId ?? _branchId,
  routeName: routeName ?? _routeName,
  startPointName: startPointName ?? _startPointName,
  startPointAddress: startPointAddress ?? _startPointAddress,
  startPointLatitude: startPointLatitude ?? _startPointLatitude,
  startPointLongitude: startPointLongitude ?? _startPointLongitude,
  endPointName: endPointName ?? _endPointName,
  endPointAddress: endPointAddress ?? _endPointAddress,
  endPointLatitude: endPointLatitude ?? _endPointLatitude,
  endPointLongitude: endPointLongitude ?? _endPointLongitude,
  noOfStops: noOfStops ?? _noOfStops,
  routePointsId: routePointsId ?? _routePointsId,
  pointNo: pointNo ?? _pointNo,
  pointName: pointName ?? _pointName,
  pointAddress: pointAddress ?? _pointAddress,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  createdBy: createdBy ?? _createdBy,
);
  String? get routeId => _routeId;
  String? get branchId => _branchId;
  String? get routeName => _routeName;
  String? get startPointName => _startPointName;
  String? get startPointAddress => _startPointAddress;
  String? get startPointLatitude => _startPointLatitude;
  String? get startPointLongitude => _startPointLongitude;
  String? get endPointName => _endPointName;
  String? get endPointAddress => _endPointAddress;
  String? get endPointLatitude => _endPointLatitude;
  String? get endPointLongitude => _endPointLongitude;
  String? get noOfStops => _noOfStops;
  String? get routePointsId => _routePointsId;
  String? get pointNo => _pointNo;
  String? get pointName => _pointName;
  String? get pointAddress => _pointAddress;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdBy => _createdBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RouteId'] = _routeId;
    map['BranchId'] = _branchId;
    map['RouteName'] = _routeName;
    map['StartPointName'] = _startPointName;
    map['StartPointAddress'] = _startPointAddress;
    map['StartPointLatitude'] = _startPointLatitude;
    map['StartPointLongitude'] = _startPointLongitude;
    map['EndPointName'] = _endPointName;
    map['EndPointAddress'] = _endPointAddress;
    map['EndPointLatitude'] = _endPointLatitude;
    map['EndPointLongitude'] = _endPointLongitude;
    map['NoOfStops'] = _noOfStops;
    map['RoutePointsId'] = _routePointsId;
    map['PointNo'] = _pointNo;
    map['PointName'] = _pointName;
    map['PointAddress'] = _pointAddress;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    map['CreatedBy'] = _createdBy;
    return map;
  }

}