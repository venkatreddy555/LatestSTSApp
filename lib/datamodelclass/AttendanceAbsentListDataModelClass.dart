/// Id : "14"
/// MonthDate : "2022-08-14"
/// Attendance : "Present"
/// Year : "2022"
/// Month : "08"
/// Day : "14"

class AttendanceAbsentListDataModelClass {
  AttendanceAbsentListDataModelClass({
      String? id, 
      String? monthDate, 
      String? attendance, 
      String? year, 
      String? month, 
      String? day,}){
    _id = id;
    _monthDate = monthDate;
    _attendance = attendance;
    _year = year;
    _month = month;
    _day = day;
}

  AttendanceAbsentListDataModelClass.fromJson(dynamic json) {
    _id = json['Id'];
    _monthDate = json['MonthDate'];
    _attendance = json['Attendance'];
    _year = json['Year'];
    _month = json['Month'];
    _day = json['Day'];
  }
  String? _id;
  String? _monthDate;
  String? _attendance;
  String? _year;
  String? _month;
  String? _day;
AttendanceAbsentListDataModelClass copyWith({  String? id,
  String? monthDate,
  String? attendance,
  String? year,
  String? month,
  String? day,
}) => AttendanceAbsentListDataModelClass(  id: id ?? _id,
  monthDate: monthDate ?? _monthDate,
  attendance: attendance ?? _attendance,
  year: year ?? _year,
  month: month ?? _month,
  day: day ?? _day,
);
  String? get id => _id;
  String? get monthDate => _monthDate;
  String? get attendance => _attendance;
  String? get year => _year;
  String? get month => _month;
  String? get day => _day;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['MonthDate'] = _monthDate;
    map['Attendance'] = _attendance;
    map['Year'] = _year;
    map['Month'] = _month;
    map['Day'] = _day;
    return map;
  }

}