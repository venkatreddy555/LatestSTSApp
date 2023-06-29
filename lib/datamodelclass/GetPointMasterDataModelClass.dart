class GetPointMasterDataModelClass {
  GetPointMasterDataModelClass({
      String? pointID, 
      String? pointNo, 
      String? pointName, 
      String? pointAddress, 
      String? latitude, 
      String? longitude,}){
    _pointID = pointID;
    _pointNo = pointNo;
    _pointName = pointName;
    _pointAddress = pointAddress;
    _latitude = latitude;
    _longitude = longitude;
}

  GetPointMasterDataModelClass.fromJson(dynamic json) {
    _pointID = json['PointID'];
    _pointNo = json['PointNo'];
    _pointName = json['PointName'];
    _pointAddress = json['PointAddress'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
  }
  String? _pointID;
  String? _pointNo;
  String? _pointName;
  String? _pointAddress;
  String? _latitude;
  String? _longitude;
GetPointMasterDataModelClass copyWith({  String? pointID,
  String? pointNo,
  String? pointName,
  String? pointAddress,
  String? latitude,
  String? longitude,
}) => GetPointMasterDataModelClass(  pointID: pointID ?? _pointID,
  pointNo: pointNo ?? _pointNo,
  pointName: pointName ?? _pointName,
  pointAddress: pointAddress ?? _pointAddress,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
);
  String? get pointID => _pointID;
  String? get pointNo => _pointNo;
  String? get pointName => _pointName;
  String? get pointAddress => _pointAddress;
  String? get latitude => _latitude;
  String? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PointID'] = _pointID;
    map['PointNo'] = _pointNo;
    map['PointName'] = _pointName;
    map['PointAddress'] = _pointAddress;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    return map;
  }

}