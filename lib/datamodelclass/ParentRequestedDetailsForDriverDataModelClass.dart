/// ParentRequestId : "46"
/// StudentName : "gita"
/// FatherName : "venkatrao"
/// FatherMobileNo : "7032568999"
/// ParentRequestType : "Pickup"
/// DateOfRequest : "24-Jan-2023"
/// PersonName : "ravali"
/// MobileNo : "9133824042"
/// RouteName : "NR-Friends Colony"
/// AdminUpdatedOn : "24-Jan-2023 15:02"
/// IdProofImagePath : "https://tecdatum.org/STSImages/2023_Jan_24_15_01_48_DOC_3.JPEG"
/// IsVerified : "False"

class ParentRequestedDetailsForDriverDataModelClass {
  ParentRequestedDetailsForDriverDataModelClass({
      String? parentRequestId, 
      String? studentName, 
      String? fatherName, 
      String? fatherMobileNo, 
      String? parentRequestType, 
      String? dateOfRequest, 
      String? personName, 
      String? mobileNo, 
      String? routeName, 
      String? adminUpdatedOn, 
      String? idProofImagePath, 
      String? isVerified,}){
    _parentRequestId = parentRequestId;
    _studentName = studentName;
    _fatherName = fatherName;
    _fatherMobileNo = fatherMobileNo;
    _parentRequestType = parentRequestType;
    _dateOfRequest = dateOfRequest;
    _personName = personName;
    _mobileNo = mobileNo;
    _routeName = routeName;
    _adminUpdatedOn = adminUpdatedOn;
    _idProofImagePath = idProofImagePath;
    _isVerified = isVerified;
}

  ParentRequestedDetailsForDriverDataModelClass.fromJson(dynamic json) {
    _parentRequestId = json['ParentRequestId'];
    _studentName = json['StudentName'];
    _fatherName = json['FatherName'];
    _fatherMobileNo = json['FatherMobileNo'];
    _parentRequestType = json['ParentRequestType'];
    _dateOfRequest = json['DateOfRequest'];
    _personName = json['PersonName'];
    _mobileNo = json['MobileNo'];
    _routeName = json['RouteName'];
    _adminUpdatedOn = json['AdminUpdatedOn'];
    _idProofImagePath = json['IdProofImagePath'];
    _isVerified = json['IsVerified'];
  }
  String? _parentRequestId;
  String? _studentName;
  String? _fatherName;
  String? _fatherMobileNo;
  String? _parentRequestType;
  String? _dateOfRequest;
  String? _personName;
  String? _mobileNo;
  String? _routeName;
  String? _adminUpdatedOn;
  String? _idProofImagePath;
  String? _isVerified;
ParentRequestedDetailsForDriverDataModelClass copyWith({  String? parentRequestId,
  String? studentName,
  String? fatherName,
  String? fatherMobileNo,
  String? parentRequestType,
  String? dateOfRequest,
  String? personName,
  String? mobileNo,
  String? routeName,
  String? adminUpdatedOn,
  String? idProofImagePath,
  String? isVerified,
}) => ParentRequestedDetailsForDriverDataModelClass(  parentRequestId: parentRequestId ?? _parentRequestId,
  studentName: studentName ?? _studentName,
  fatherName: fatherName ?? _fatherName,
  fatherMobileNo: fatherMobileNo ?? _fatherMobileNo,
  parentRequestType: parentRequestType ?? _parentRequestType,
  dateOfRequest: dateOfRequest ?? _dateOfRequest,
  personName: personName ?? _personName,
  mobileNo: mobileNo ?? _mobileNo,
  routeName: routeName ?? _routeName,
  adminUpdatedOn: adminUpdatedOn ?? _adminUpdatedOn,
  idProofImagePath: idProofImagePath ?? _idProofImagePath,
  isVerified: isVerified ?? _isVerified,
);
  String? get parentRequestId => _parentRequestId;
  String? get studentName => _studentName;
  String? get fatherName => _fatherName;
  String? get fatherMobileNo => _fatherMobileNo;
  String? get parentRequestType => _parentRequestType;
  String? get dateOfRequest => _dateOfRequest;
  String? get personName => _personName;
  String? get mobileNo => _mobileNo;
  String? get routeName => _routeName;
  String? get adminUpdatedOn => _adminUpdatedOn;
  String? get idProofImagePath => _idProofImagePath;
  String? get isVerified => _isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ParentRequestId'] = _parentRequestId;
    map['StudentName'] = _studentName;
    map['FatherName'] = _fatherName;
    map['FatherMobileNo'] = _fatherMobileNo;
    map['ParentRequestType'] = _parentRequestType;
    map['DateOfRequest'] = _dateOfRequest;
    map['PersonName'] = _personName;
    map['MobileNo'] = _mobileNo;
    map['RouteName'] = _routeName;
    map['AdminUpdatedOn'] = _adminUpdatedOn;
    map['IdProofImagePath'] = _idProofImagePath;
    map['IsVerified'] = _isVerified;
    return map;
  }

}