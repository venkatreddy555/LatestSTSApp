class RoutePointsMasterDataModelClass {
  RoutePointsMasterDataModelClass({
      String? routePointsId, 
      String? pointNo, 
      String? pointName, 
      String? pointAddress, 
      String? latitude, 
      String? longitude,}){
    _routePointsId = routePointsId;
    _pointNo = pointNo;
    _pointName = pointName;
    _pointAddress = pointAddress;
    _latitude = latitude;
    _longitude = longitude;
}

  RoutePointsMasterDataModelClass.fromJson(dynamic json) {
    _routePointsId = json['RoutePointsId'];
    _pointNo = json['PointNo'];
    _pointName = json['PointName'];
    _pointAddress = json['PointAddress'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
  }
  String? _routePointsId;
  String? _pointNo;
  String? _pointName;
  String? _pointAddress;
  String? _latitude;
  String? _longitude;
RoutePointsMasterDataModelClass copyWith({  String? routePointsId,
  String? pointNo,
  String? pointName,
  String? pointAddress,
  String? latitude,
  String? longitude,
}) => RoutePointsMasterDataModelClass(  routePointsId: routePointsId ?? _routePointsId,
  pointNo: pointNo ?? _pointNo,
  pointName: pointName ?? _pointName,
  pointAddress: pointAddress ?? _pointAddress,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
);
  String? get routePointsId => _routePointsId;
  String? get pointNo => _pointNo;
  String? get pointName => _pointName;
  String? get pointAddress => _pointAddress;
  String? get latitude => _latitude;
  String? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RoutePointsId'] = _routePointsId;
    map['PointNo'] = _pointNo;
    map['PointName'] = _pointName;
    map['PointAddress'] = _pointAddress;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    return map;
  }

}