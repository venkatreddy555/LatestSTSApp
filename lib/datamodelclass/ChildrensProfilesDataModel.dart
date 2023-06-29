
class ChildrensProfilesDataModel {
  ChildrensProfilesDataModel({
      String? studentId, 
      String? firstName, 
      String? surName, 
      String? admissionNo, 
      String? className, 
      String? rollNo, 
      String? dob, 
      String? routeId, 
      String? routeName,}){
    _studentId = studentId;
    _firstName = firstName;
    _surName = surName;
    _admissionNo = admissionNo;
    _className = className;
    _rollNo = rollNo;
    _dob = dob;
    _routeId = routeId;
    _routeName = routeName;
}

  ChildrensProfilesDataModel.fromJson(dynamic json) {
    _studentId = json['StudentId'];
    _firstName = json['FirstName'];
    _surName = json['SurName'];
    _admissionNo = json['AdmissionNo'];
    _className = json['ClassName'];
    _rollNo = json['RollNo'];
    _dob = json['DOB'];
    _routeId = json['RouteId'];
    _routeName = json['RouteName'];
  }
  String? _studentId;
  String? _firstName;
  String? _surName;
  String? _admissionNo;
  String? _className;
  String? _rollNo;
  String? _dob;
  String? _routeId;
  String? _routeName;
ChildrensProfilesDataModel copyWith({  String? studentId,
  String? firstName,
  String? surName,
  String? admissionNo,
  String? className,
  String? rollNo,
  String? dob,
  String? routeId,
  String? routeName,
}) => ChildrensProfilesDataModel(  studentId: studentId ?? _studentId,
  firstName: firstName ?? _firstName,
  surName: surName ?? _surName,
  admissionNo: admissionNo ?? _admissionNo,
  className: className ?? _className,
  rollNo: rollNo ?? _rollNo,
  dob: dob ?? _dob,
  routeId: routeId ?? _routeId,
  routeName: routeName ?? _routeName,
);
  String? get studentId => _studentId;
  String? get firstName => _firstName;
  String? get surName => _surName;
  String? get admissionNo => _admissionNo;
  String? get className => _className;
  String? get rollNo => _rollNo;
  String? get dob => _dob;
  String? get routeId => _routeId;
  String? get routeName => _routeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StudentId'] = _studentId;
    map['FirstName'] = _firstName;
    map['SurName'] = _surName;
    map['AdmissionNo'] = _admissionNo;
    map['ClassName'] = _className;
    map['RollNo'] = _rollNo;
    map['DOB'] = _dob;
    map['RouteId'] = _routeId;
    map['RouteName'] = _routeName;
    return map;
  }

}