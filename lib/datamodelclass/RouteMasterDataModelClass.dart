/// RouteId : "66"
/// RouteName : "NR-Friends Colony"

class RouteMasterDataModelClass {
  RouteMasterDataModelClass({
      String? routeId, 
      String? routeName,}){
    _routeId = routeId;
    _routeName = routeName;
}

  RouteMasterDataModelClass.fromJson(dynamic json) {
    _routeId = json['RouteId'];
    _routeName = json['RouteName'];
  }
  String? _routeId;
  String? _routeName;
RouteMasterDataModelClass copyWith({  String? routeId,
  String? routeName,
}) => RouteMasterDataModelClass(  routeId: routeId ?? _routeId,
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