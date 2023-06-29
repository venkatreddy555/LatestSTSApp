/// RouteId : "66"
/// RouteName : "NR-Friends Colony"

class ViewRouteonMapsDataModelClass {
  ViewRouteonMapsDataModelClass({
      String? routeId, 
      String? routeName,}){
    _routeId = routeId;
    _routeName = routeName;
}

  ViewRouteonMapsDataModelClass.fromJson(dynamic json) {
    _routeId = json['RouteId'];
    _routeName = json['RouteName'];
  }
  String? _routeId;
  String? _routeName;
ViewRouteonMapsDataModelClass copyWith({  String? routeId,
  String? routeName,
}) => ViewRouteonMapsDataModelClass(  routeId: routeId ?? _routeId,
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