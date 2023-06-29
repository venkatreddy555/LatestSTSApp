 import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';

import '../datamodelclass/ChildrensProfilesDataModel.dart';
import '../webservices/API.dart';

class LoginRepository extends ChangeNotifier{


 var MobileNumber;
 var demoList =[];
 Future<ChildrensProfilesDataModel?> fetchJobs() async {
 ChildrensProfilesDataModel childrensProfilesDataModel;
 MobileNumber = await SaveSharedPreference.getMobileNumber();
 var data = {'MobileNumber': MobileNumber};
 var res = await CallApi().postData(data, 'STS/GetChildrens');
 print("requestBody ${res.body}");
 // var finalData = res.body["Data"];
 var body = json.decode(res.body);
 demoList = body["Data"];
 notifyListeners();
 print(demoList.toString());
 return null;
 // childrensProfilesDataModel = ChildrensProfilesDataModel.fromJson(res.data);

 }


 }