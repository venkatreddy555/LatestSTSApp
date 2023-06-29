class RemovePointfromRouteDataModel {
  RemovePointfromRouteDataModel({
      String? routeId, 
      String? routeName,}){
    _routeId = routeId;
    _routeName = routeName;
}

  RemovePointfromRouteDataModel.fromJson(dynamic json) {
    _routeId = json['RouteId'];
    _routeName = json['RouteName'];
  }
  String? _routeId;
  String? _routeName;
RemovePointfromRouteDataModel copyWith({  String? routeId,
  String? routeName,
}) => RemovePointfromRouteDataModel(  routeId: routeId ?? _routeId,
  routeName: routeName ?? _routeName,
);
  String? get routeId => _routeId;
  String? get routeName => _routeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RouteId'] = _routeId;
    map['RouteName'] = _routeName;
    return map;
  }

}