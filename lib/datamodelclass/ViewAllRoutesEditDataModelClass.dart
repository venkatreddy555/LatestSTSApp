/// RouteId : "66"
/// RouteName : "NR-Friends Colony"
/// StartPointName : "The Future Kids School Main"
/// StartPointAddress : "Future Kids School Rd, Financial District, Nanakaramguda"
/// StartPointLatitude : "17.40492593362368"
/// StartPointLongitude : "78.34953112011192"
/// EndPointName : "The future kids school main"
/// EndPointAddress : "Future Kids School Rd, Financial District, Nanakaramguda"
/// EndPointLatitude : "17.40492593362368"
/// EndPointLongitude : "78.34953112011192"
/// NoOfStops : "12"

class ViewAllRoutesEditDataModelClass {
  ViewAllRoutesEditDataModelClass({
      String? routeId, 
      String? routeName, 
      String? startPointName, 
      String? startPointAddress, 
      String? startPointLatitude, 
      String? startPointLongitude, 
      String? endPointName, 
      String? endPointAddress, 
      String? endPointLatitude, 
      String? endPointLongitude, 
      String? noOfStops,}){
    _routeId = routeId;
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
}

  ViewAllRoutesEditDataModelClass.fromJson(dynamic json) {
    _routeId = json['RouteId'];
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
  }
  String? _routeId;
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
ViewAllRoutesEditDataModelClass copyWith({  String? routeId,
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
}) => ViewAllRoutesEditDataModelClass(  routeId: routeId ?? _routeId,
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
);
  String? get routeId => _routeId;
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RouteId'] = _routeId;
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
    return map;
  }

}