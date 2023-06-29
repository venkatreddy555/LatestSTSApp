class GetStudentattendanceForparent {
  GetStudentattendanceForparent({
      String? studentAttendanceId, 
      String? studentName, 
      String? vehicleNo, 
      String? attendanceDate, 
      String? latitude, 
      String? longitude, 
      String? location, 
      String? status,}){
    _studentAttendanceId = studentAttendanceId;
    _studentName = studentName;
    _vehicleNo = vehicleNo;
    _attendanceDate = attendanceDate;
    _latitude = latitude;
    _longitude = longitude;
    _location = location;
    _status = status;
}

  GetStudentattendanceForparent.fromJson(dynamic json) {
    _studentAttendanceId = json['StudentAttendanceId'];
    _studentName = json['StudentName'];
    _vehicleNo = json['VehicleNo'];
    _attendanceDate = json['AttendanceDate'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
    _location = json['Location'];
    _status = json['Status'];
  }
  String? _studentAttendanceId;
  String? _studentName;
  String? _vehicleNo;
  String? _attendanceDate;
  String? _latitude;
  String? _longitude;
  String? _location;
  String? _status;
GetStudentattendanceForparent copyWith({  String? studentAttendanceId,
  String? studentName,
  String? vehicleNo,
  String? attendanceDate,
  String? latitude,
  String? longitude,
  String? location,
  String? status,
}) => GetStudentattendanceForparent(  studentAttendanceId: studentAttendanceId ?? _studentAttendanceId,
  studentName: studentName ?? _studentName,
  vehicleNo: vehicleNo ?? _vehicleNo,
  attendanceDate: attendanceDate ?? _attendanceDate,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  location: location ?? _location,
  status: status ?? _status,
);
  String? get studentAttendanceId => _studentAttendanceId;
  String? get studentName => _studentName;
  String? get vehicleNo => _vehicleNo;
  String? get attendanceDate => _attendanceDate;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get location => _location;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StudentAttendanceId'] = _studentAttendanceId;
    map['StudentName'] = _studentName;
    map['VehicleNo'] = _vehicleNo;
    map['AttendanceDate'] = _attendanceDate;
    map['Latitude'] = _latitude;
    map['Longitude'] = _longitude;
    map['Location'] = _location;
    map['Status'] = _status;
    return map;
  }

}