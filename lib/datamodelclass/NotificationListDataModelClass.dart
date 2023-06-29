/// NotificationSentdetails_Id : "45"
/// StudentName : "mahesh"
/// NotificationType : "Attendance"
/// NotificationMessage : "Dear parent, we have picked your child(mahesh) from Abinandana Exotic and have taken bus attendance.Thanks,Giri."
/// DateOfnotificationSent : "27-Feb-2023 14:54"
/// IsNotificationReaded : "False"

class NotificationListDataModelClass {
  NotificationListDataModelClass({
      String? notificationSentdetailsId, 
      String? studentName, 
      String? notificationType, 
      String? notificationMessage, 
      String? dateOfnotificationSent, 
      String? isNotificationReaded,}){
    _notificationSentdetailsId = notificationSentdetailsId;
    _studentName = studentName;
    _notificationType = notificationType;
    _notificationMessage = notificationMessage;
    _dateOfnotificationSent = dateOfnotificationSent;
    _isNotificationReaded = isNotificationReaded;
}

  NotificationListDataModelClass.fromJson(dynamic json) {
    _notificationSentdetailsId = json['NotificationSentdetails_Id'];
    _studentName = json['StudentName'];
    _notificationType = json['NotificationType'];
    _notificationMessage = json['NotificationMessage'];
    _dateOfnotificationSent = json['DateOfnotificationSent'];
    _isNotificationReaded = json['IsNotificationReaded'];
  }
  String? _notificationSentdetailsId;
  String? _studentName;
  String? _notificationType;
  String? _notificationMessage;
  String? _dateOfnotificationSent;
  String? _isNotificationReaded;
NotificationListDataModelClass copyWith({  String? notificationSentdetailsId,
  String? studentName,
  String? notificationType,
  String? notificationMessage,
  String? dateOfnotificationSent,
  String? isNotificationReaded,
}) => NotificationListDataModelClass(  notificationSentdetailsId: notificationSentdetailsId ?? _notificationSentdetailsId,
  studentName: studentName ?? _studentName,
  notificationType: notificationType ?? _notificationType,
  notificationMessage: notificationMessage ?? _notificationMessage,
  dateOfnotificationSent: dateOfnotificationSent ?? _dateOfnotificationSent,
  isNotificationReaded: isNotificationReaded ?? _isNotificationReaded,
);
  String? get notificationSentdetailsId => _notificationSentdetailsId;
  String? get studentName => _studentName;
  String? get notificationType => _notificationType;
  String? get notificationMessage => _notificationMessage;
  String? get dateOfnotificationSent => _dateOfnotificationSent;
  String? get isNotificationReaded => _isNotificationReaded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['NotificationSentdetails_Id'] = _notificationSentdetailsId;
    map['StudentName'] = _studentName;
    map['NotificationType'] = _notificationType;
    map['NotificationMessage'] = _notificationMessage;
    map['DateOfnotificationSent'] = _dateOfnotificationSent;
    map['IsNotificationReaded'] = _isNotificationReaded;
    return map;
  }

}