/// StudentId : "4"
/// BranchId : "39"
/// BranchName : "Nanakramguda"
/// AdmissionNo : "5151515"
/// RollNo : "5888000"
/// SurName : "uppuluri"
/// FirstName : "mahesh"
/// GenderId : "1"
/// GenderName : "Male"
/// DOB : "28-05-2016 00:00:00"
/// ClassId : "1"
/// ClassName : "First"
/// SectionId : "1"
/// SectionName : "A"
/// BloodGroupId : "3"
/// BloodGroupName : "B+"
/// StudentEMailId : "mahesh@hotmail.com"
/// StudentImage : "5151515Logo_2022-10-27-13-57-33.PNG"
/// FatherName : "Eshwar rao"
/// FatherOccupationId : "2"
/// FatherOccupation : "Engineer"
/// FatherEmailId : "eshwarrao@gmail.com"
/// FatherMobileNo : "9133824042"
/// MotherName : "satyavathi"
/// MotherOccupationId : "2"
/// MotherOccupation : "Engineer"
/// MotherEmailId : "satya@gmail.com"
/// MotherMobileNo : "9696969696"
/// EmergencyMobileNo : null
/// PickupStopId : "59"
/// PickupPointName : "Gayathri plaza"
/// DropStopId : "0"
/// DropPointName : ""
/// QRCodePath : "E:/STSImages/5151515"
/// CreatedBy : "1"
/// CreatedOn : null
/// ModifiedBy : null
/// ModifiedOn : null
/// IsActive : null
/// VehicleId : ""
/// VehicleNo : ""
/// RouteName : "NR-Friends Colony"

class StudentDetailsDataModelClass {
  StudentDetailsDataModelClass({
      String? studentId, 
      String? branchId, 
      String? branchName, 
      String? admissionNo, 
      String? rollNo, 
      String? surName, 
      String? firstName, 
      String? genderId, 
      String? genderName, 
      String? dob, 
      String? classId, 
      String? className, 
      String? sectionId, 
      String? sectionName, 
      String? bloodGroupId, 
      String? bloodGroupName, 
      String? studentEMailId, 
      String? studentImage, 
      String? fatherName, 
      String? fatherOccupationId, 
      String? fatherOccupation, 
      String? fatherEmailId, 
      String? fatherMobileNo, 
      String? motherName, 
      String? motherOccupationId, 
      String? motherOccupation, 
      String? motherEmailId, 
      String? motherMobileNo, 
      dynamic emergencyMobileNo, 
      String? pickupStopId, 
      String? pickupPointName, 
      String? dropStopId, 
      String? dropPointName, 
      String? qRCodePath, 
      String? createdBy, 
      dynamic createdOn, 
      dynamic modifiedBy, 
      dynamic modifiedOn, 
      dynamic isActive, 
      String? vehicleId, 
      String? vehicleNo, 
      String? routeName,}){
    _studentId = studentId;
    _branchId = branchId;
    _branchName = branchName;
    _admissionNo = admissionNo;
    _rollNo = rollNo;
    _surName = surName;
    _firstName = firstName;
    _genderId = genderId;
    _genderName = genderName;
    _dob = dob;
    _classId = classId;
    _className = className;
    _sectionId = sectionId;
    _sectionName = sectionName;
    _bloodGroupId = bloodGroupId;
    _bloodGroupName = bloodGroupName;
    _studentEMailId = studentEMailId;
    _studentImage = studentImage;
    _fatherName = fatherName;
    _fatherOccupationId = fatherOccupationId;
    _fatherOccupation = fatherOccupation;
    _fatherEmailId = fatherEmailId;
    _fatherMobileNo = fatherMobileNo;
    _motherName = motherName;
    _motherOccupationId = motherOccupationId;
    _motherOccupation = motherOccupation;
    _motherEmailId = motherEmailId;
    _motherMobileNo = motherMobileNo;
    _emergencyMobileNo = emergencyMobileNo;
    _pickupStopId = pickupStopId;
    _pickupPointName = pickupPointName;
    _dropStopId = dropStopId;
    _dropPointName = dropPointName;
    _qRCodePath = qRCodePath;
    _createdBy = createdBy;
    _createdOn = createdOn;
    _modifiedBy = modifiedBy;
    _modifiedOn = modifiedOn;
    _isActive = isActive;
    _vehicleId = vehicleId;
    _vehicleNo = vehicleNo;
    _routeName = routeName;
}

  StudentDetailsDataModelClass.fromJson(dynamic json) {
    _studentId = json['StudentId'];
    _branchId = json['BranchId'];
    _branchName = json['BranchName'];
    _admissionNo = json['AdmissionNo'];
    _rollNo = json['RollNo'];
    _surName = json['SurName'];
    _firstName = json['FirstName'];
    _genderId = json['GenderId'];
    _genderName = json['GenderName'];
    _dob = json['DOB'];
    _classId = json['ClassId'];
    _className = json['ClassName'];
    _sectionId = json['SectionId'];
    _sectionName = json['SectionName'];
    _bloodGroupId = json['BloodGroupId'];
    _bloodGroupName = json['BloodGroupName'];
    _studentEMailId = json['StudentEMailId'];
    _studentImage = json['StudentImage'];
    _fatherName = json['FatherName'];
    _fatherOccupationId = json['FatherOccupationId'];
    _fatherOccupation = json['FatherOccupation'];
    _fatherEmailId = json['FatherEmailId'];
    _fatherMobileNo = json['FatherMobileNo'];
    _motherName = json['MotherName'];
    _motherOccupationId = json['MotherOccupationId'];
    _motherOccupation = json['MotherOccupation'];
    _motherEmailId = json['MotherEmailId'];
    _motherMobileNo = json['MotherMobileNo'];
    _emergencyMobileNo = json['EmergencyMobileNo'];
    _pickupStopId = json['PickupStopId'];
    _pickupPointName = json['PickupPointName'];
    _dropStopId = json['DropStopId'];
    _dropPointName = json['DropPointName'];
    _qRCodePath = json['QRCodePath'];
    _createdBy = json['CreatedBy'];
    _createdOn = json['CreatedOn'];
    _modifiedBy = json['ModifiedBy'];
    _modifiedOn = json['ModifiedOn'];
    _isActive = json['IsActive'];
    _vehicleId = json['VehicleId'];
    _vehicleNo = json['VehicleNo'];
    _routeName = json['RouteName'];
  }
  String? _studentId;
  String? _branchId;
  String? _branchName;
  String? _admissionNo;
  String? _rollNo;
  String? _surName;
  String? _firstName;
  String? _genderId;
  String? _genderName;
  String? _dob;
  String? _classId;
  String? _className;
  String? _sectionId;
  String? _sectionName;
  String? _bloodGroupId;
  String? _bloodGroupName;
  String? _studentEMailId;
  String? _studentImage;
  String? _fatherName;
  String? _fatherOccupationId;
  String? _fatherOccupation;
  String? _fatherEmailId;
  String? _fatherMobileNo;
  String? _motherName;
  String? _motherOccupationId;
  String? _motherOccupation;
  String? _motherEmailId;
  String? _motherMobileNo;
  dynamic _emergencyMobileNo;
  String? _pickupStopId;
  String? _pickupPointName;
  String? _dropStopId;
  String? _dropPointName;
  String? _qRCodePath;
  String? _createdBy;
  dynamic _createdOn;
  dynamic _modifiedBy;
  dynamic _modifiedOn;
  dynamic _isActive;
  String? _vehicleId;
  String? _vehicleNo;
  String? _routeName;
StudentDetailsDataModelClass copyWith({  String? studentId,
  String? branchId,
  String? branchName,
  String? admissionNo,
  String? rollNo,
  String? surName,
  String? firstName,
  String? genderId,
  String? genderName,
  String? dob,
  String? classId,
  String? className,
  String? sectionId,
  String? sectionName,
  String? bloodGroupId,
  String? bloodGroupName,
  String? studentEMailId,
  String? studentImage,
  String? fatherName,
  String? fatherOccupationId,
  String? fatherOccupation,
  String? fatherEmailId,
  String? fatherMobileNo,
  String? motherName,
  String? motherOccupationId,
  String? motherOccupation,
  String? motherEmailId,
  String? motherMobileNo,
  dynamic emergencyMobileNo,
  String? pickupStopId,
  String? pickupPointName,
  String? dropStopId,
  String? dropPointName,
  String? qRCodePath,
  String? createdBy,
  dynamic createdOn,
  dynamic modifiedBy,
  dynamic modifiedOn,
  dynamic isActive,
  String? vehicleId,
  String? vehicleNo,
  String? routeName,
}) => StudentDetailsDataModelClass(  studentId: studentId ?? _studentId,
  branchId: branchId ?? _branchId,
  branchName: branchName ?? _branchName,
  admissionNo: admissionNo ?? _admissionNo,
  rollNo: rollNo ?? _rollNo,
  surName: surName ?? _surName,
  firstName: firstName ?? _firstName,
  genderId: genderId ?? _genderId,
  genderName: genderName ?? _genderName,
  dob: dob ?? _dob,
  classId: classId ?? _classId,
  className: className ?? _className,
  sectionId: sectionId ?? _sectionId,
  sectionName: sectionName ?? _sectionName,
  bloodGroupId: bloodGroupId ?? _bloodGroupId,
  bloodGroupName: bloodGroupName ?? _bloodGroupName,
  studentEMailId: studentEMailId ?? _studentEMailId,
  studentImage: studentImage ?? _studentImage,
  fatherName: fatherName ?? _fatherName,
  fatherOccupationId: fatherOccupationId ?? _fatherOccupationId,
  fatherOccupation: fatherOccupation ?? _fatherOccupation,
  fatherEmailId: fatherEmailId ?? _fatherEmailId,
  fatherMobileNo: fatherMobileNo ?? _fatherMobileNo,
  motherName: motherName ?? _motherName,
  motherOccupationId: motherOccupationId ?? _motherOccupationId,
  motherOccupation: motherOccupation ?? _motherOccupation,
  motherEmailId: motherEmailId ?? _motherEmailId,
  motherMobileNo: motherMobileNo ?? _motherMobileNo,
  emergencyMobileNo: emergencyMobileNo ?? _emergencyMobileNo,
  pickupStopId: pickupStopId ?? _pickupStopId,
  pickupPointName: pickupPointName ?? _pickupPointName,
  dropStopId: dropStopId ?? _dropStopId,
  dropPointName: dropPointName ?? _dropPointName,
  qRCodePath: qRCodePath ?? _qRCodePath,
  createdBy: createdBy ?? _createdBy,
  createdOn: createdOn ?? _createdOn,
  modifiedBy: modifiedBy ?? _modifiedBy,
  modifiedOn: modifiedOn ?? _modifiedOn,
  isActive: isActive ?? _isActive,
  vehicleId: vehicleId ?? _vehicleId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  routeName: routeName ?? _routeName,
);
  String? get studentId => _studentId;
  String? get branchId => _branchId;
  String? get branchName => _branchName;
  String? get admissionNo => _admissionNo;
  String? get rollNo => _rollNo;
  String? get surName => _surName;
  String? get firstName => _firstName;
  String? get genderId => _genderId;
  String? get genderName => _genderName;
  String? get dob => _dob;
  String? get classId => _classId;
  String? get className => _className;
  String? get sectionId => _sectionId;
  String? get sectionName => _sectionName;
  String? get bloodGroupId => _bloodGroupId;
  String? get bloodGroupName => _bloodGroupName;
  String? get studentEMailId => _studentEMailId;
  String? get studentImage => _studentImage;
  String? get fatherName => _fatherName;
  String? get fatherOccupationId => _fatherOccupationId;
  String? get fatherOccupation => _fatherOccupation;
  String? get fatherEmailId => _fatherEmailId;
  String? get fatherMobileNo => _fatherMobileNo;
  String? get motherName => _motherName;
  String? get motherOccupationId => _motherOccupationId;
  String? get motherOccupation => _motherOccupation;
  String? get motherEmailId => _motherEmailId;
  String? get motherMobileNo => _motherMobileNo;
  dynamic get emergencyMobileNo => _emergencyMobileNo;
  String? get pickupStopId => _pickupStopId;
  String? get pickupPointName => _pickupPointName;
  String? get dropStopId => _dropStopId;
  String? get dropPointName => _dropPointName;
  String? get qRCodePath => _qRCodePath;
  String? get createdBy => _createdBy;
  dynamic get createdOn => _createdOn;
  dynamic get modifiedBy => _modifiedBy;
  dynamic get modifiedOn => _modifiedOn;
  dynamic get isActive => _isActive;
  String? get vehicleId => _vehicleId;
  String? get vehicleNo => _vehicleNo;
  String? get routeName => _routeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StudentId'] = _studentId;
    map['BranchId'] = _branchId;
    map['BranchName'] = _branchName;
    map['AdmissionNo'] = _admissionNo;
    map['RollNo'] = _rollNo;
    map['SurName'] = _surName;
    map['FirstName'] = _firstName;
    map['GenderId'] = _genderId;
    map['GenderName'] = _genderName;
    map['DOB'] = _dob;
    map['ClassId'] = _classId;
    map['ClassName'] = _className;
    map['SectionId'] = _sectionId;
    map['SectionName'] = _sectionName;
    map['BloodGroupId'] = _bloodGroupId;
    map['BloodGroupName'] = _bloodGroupName;
    map['StudentEMailId'] = _studentEMailId;
    map['StudentImage'] = _studentImage;
    map['FatherName'] = _fatherName;
    map['FatherOccupationId'] = _fatherOccupationId;
    map['FatherOccupation'] = _fatherOccupation;
    map['FatherEmailId'] = _fatherEmailId;
    map['FatherMobileNo'] = _fatherMobileNo;
    map['MotherName'] = _motherName;
    map['MotherOccupationId'] = _motherOccupationId;
    map['MotherOccupation'] = _motherOccupation;
    map['MotherEmailId'] = _motherEmailId;
    map['MotherMobileNo'] = _motherMobileNo;
    map['EmergencyMobileNo'] = _emergencyMobileNo;
    map['PickupStopId'] = _pickupStopId;
    map['PickupPointName'] = _pickupPointName;
    map['DropStopId'] = _dropStopId;
    map['DropPointName'] = _dropPointName;
    map['QRCodePath'] = _qRCodePath;
    map['CreatedBy'] = _createdBy;
    map['CreatedOn'] = _createdOn;
    map['ModifiedBy'] = _modifiedBy;
    map['ModifiedOn'] = _modifiedOn;
    map['IsActive'] = _isActive;
    map['VehicleId'] = _vehicleId;
    map['VehicleNo'] = _vehicleNo;
    map['RouteName'] = _routeName;
    return map;
  }

}