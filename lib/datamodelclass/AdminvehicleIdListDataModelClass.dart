/// VehicleId : "3"
/// VehicleNo : "AP28TE5778"
/// VehicleName : "Manikonda-I"

class AdminvehicleIdListDataModelClass {
  AdminvehicleIdListDataModelClass({
      String? vehicleId, 
      String? vehicleNo, 
      String? vehicleName,}){
    _vehicleId = vehicleId;
    _vehicleNo = vehicleNo;
    _vehicleName = vehicleName;
}

  AdminvehicleIdListDataModelClass.fromJson(dynamic json) {
    _vehicleId = json['VehicleId'];
    _vehicleNo = json['VehicleNo'];
    _vehicleName = json['VehicleName'];
  }
  String? _vehicleId;
  String? _vehicleNo;
  String? _vehicleName;
AdminvehicleIdListDataModelClass copyWith({  String? vehicleId,
  String? vehicleNo,
  String? vehicleName,
}) => AdminvehicleIdListDataModelClass(  vehicleId: vehicleId ?? _vehicleId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  vehicleName: vehicleName ?? _vehicleName,
);
  String? get vehicleId => _vehicleId;
  String? get vehicleNo => _vehicleNo;
  String? get vehicleName => _vehicleName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['VehicleId'] = _vehicleId;
    map['VehicleNo'] = _vehicleNo;
    map['VehicleName'] = _vehicleName;
    return map;
  }

}