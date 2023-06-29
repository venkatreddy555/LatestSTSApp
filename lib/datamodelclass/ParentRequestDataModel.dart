class ParentRequestDataModel {
  ParentRequestDataModel({
      String? parentRequestId, 
      String? dateOfRequest, 
      String? personName, 
      String? mobileNo, 
      String? idProofImagePath, 
      String? parentRequestType, 
      String? studentName, 
      String? admissionNo, 
      String? parentRequestStatus, 
      String? requestRaisedDateAndTime, 
      String? routeName, 
      String? oLDPointName, 
      String? newPointName, 
      String? fatherName, 
      String? fatherMobileNo,}){
    _parentRequestId = parentRequestId;
    _dateOfRequest = dateOfRequest;
    _personName = personName;
    _mobileNo = mobileNo;
    _idProofImagePath = idProofImagePath;
    _parentRequestType = parentRequestType;
    _studentName = studentName;
    _admissionNo = admissionNo;
    _parentRequestStatus = parentRequestStatus;
    _requestRaisedDateAndTime = requestRaisedDateAndTime;
    _routeName = routeName;
    _oLDPointName = oLDPointName;
    _newPointName = newPointName;
    _fatherName = fatherName;
    _fatherMobileNo = fatherMobileNo;
}

  ParentRequestDataModel.fromJson(dynamic json) {
    _parentRequestId = json['ParentRequestId'];
    _dateOfRequest = json['DateOfRequest'];
    _personName = json['PersonName'];
    _mobileNo = json['MobileNo'];
    _idProofImagePath = json['IdProofImagePath'];
    _parentRequestType = json['ParentRequestType'];
    _studentName = json['StudentName'];
    _admissionNo = json['AdmissionNo'];
    _parentRequestStatus = json['ParentRequestStatus'];
    _requestRaisedDateAndTime = json['RequestRaisedDateAndTime'];
    _routeName = json['RouteName'];
    _oLDPointName = json['OLDPointName'];
    _newPointName = json['NewPointName'];
    _fatherName = json['FatherName'];
    _fatherMobileNo = json['FatherMobileNo'];
  }
  String? _parentRequestId;
  String? _dateOfRequest;
  String? _personName;
  String? _mobileNo;
  String? _idProofImagePath;
  String? _parentRequestType;
  String? _studentName;
  String? _admissionNo;
  String? _parentRequestStatus;
  String? _requestRaisedDateAndTime;
  String? _routeName;
  String? _oLDPointName;
  String? _newPointName;
  String? _fatherName;
  String? _fatherMobileNo;
ParentRequestDataModel copyWith({  String? parentRequestId,
  String? dateOfRequest,
  String? personName,
  String? mobileNo,
  String? idProofImagePath,
  String? parentRequestType,
  String? studentName,
  String? admissionNo,
  String? parentRequestStatus,
  String? requestRaisedDateAndTime,
  String? routeName,
  String? oLDPointName,
  String? newPointName,
  String? fatherName,
  String? fatherMobileNo,
}) => ParentRequestDataModel(  parentRequestId: parentRequestId ?? _parentRequestId,
  dateOfRequest: dateOfRequest ?? _dateOfRequest,
  personName: personName ?? _personName,
  mobileNo: mobileNo ?? _mobileNo,
  idProofImagePath: idProofImagePath ?? _idProofImagePath,
  parentRequestType: parentRequestType ?? _parentRequestType,
  studentName: studentName ?? _studentName,
  admissionNo: admissionNo ?? _admissionNo,
  parentRequestStatus: parentRequestStatus ?? _parentRequestStatus,
  requestRaisedDateAndTime: requestRaisedDateAndTime ?? _requestRaisedDateAndTime,
  routeName: routeName ?? _routeName,
  oLDPointName: oLDPointName ?? _oLDPointName,
  newPointName: newPointName ?? _newPointName,
  fatherName: fatherName ?? _fatherName,
  fatherMobileNo: fatherMobileNo ?? _fatherMobileNo,
);
  String? get parentRequestId => _parentRequestId;
  String? get dateOfRequest => _dateOfRequest;
  String? get personName => _personName;
  String? get mobileNo => _mobileNo;
  String? get idProofImagePath => _idProofImagePath;
  String? get parentRequestType => _parentRequestType;
  String? get studentName => _studentName;
  String? get admissionNo => _admissionNo;
  String? get parentRequestStatus => _parentRequestStatus;
  String? get requestRaisedDateAndTime => _requestRaisedDateAndTime;
  String? get routeName => _routeName;
  String? get oLDPointName => _oLDPointName;
  String? get newPointName => _newPointName;
  String? get fatherName => _fatherName;
  String? get fatherMobileNo => _fatherMobileNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ParentRequestId'] = _parentRequestId;
    map['DateOfRequest'] = _dateOfRequest;
    map['PersonName'] = _personName;
    map['MobileNo'] = _mobileNo;
    map['IdProofImagePath'] = _idProofImagePath;
    map['ParentRequestType'] = _parentRequestType;
    map['StudentName'] = _studentName;
    map['AdmissionNo'] = _admissionNo;
    map['ParentRequestStatus'] = _parentRequestStatus;
    map['RequestRaisedDateAndTime'] = _requestRaisedDateAndTime;
    map['RouteName'] = _routeName;
    map['OLDPointName'] = _oLDPointName;
    map['NewPointName'] = _newPointName;
    map['FatherName'] = _fatherName;
    map['FatherMobileNo'] = _fatherMobileNo;
    return map;
  }

}