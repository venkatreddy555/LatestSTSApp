import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/ParentRequestDataModel.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';

class ParentRequestList extends StatefulWidget {
  const ParentRequestList({super.key});

  @override
  _ParentRequestListState createState() => _ParentRequestListState();
}

class _ParentRequestListState extends State<ParentRequestList> {
  var BranchId;
  bool isVisibleapprove = false;
  bool isVisiblereject = false;
  var approve='Approve';
  var reject='Reject';


  @override
  void initState() {
    super.initState();
  }
  Future<List<ParentRequestDataModel>> getData() async {
    List<ParentRequestDataModel> list;

    BranchId = await SaveSharedPreference.getBranchId();
    print(BranchId);
    var data = {'BranchId': BranchId};
    var res = await CallApi().postData(data, 'STS/GetParentRequestForAdmin');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<ParentRequestDataModel>(
            (json) => ParentRequestDataModel.fromJson(json))
        .toList();
    return list;
  }

  Widget listViewWidget(List<ParentRequestDataModel> parentRequestDataModel) {
    return Container(
      child: ListView.builder(
          itemCount: parentRequestDataModel.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
              if(parentRequestDataModel[position].parentRequestStatus=='Approved'){
                isVisibleapprove = true;
                isVisiblereject = false;
                approve='Approved';
              }else if(parentRequestDataModel[position].parentRequestStatus=='In-process'){
                 isVisibleapprove = true;
                 isVisiblereject = true;
                  approve='Approve';
                  reject='Reject';
              }else if(parentRequestDataModel[position].parentRequestStatus=='Reject'){
                isVisibleapprove = false;
                isVisiblereject = true;
                reject='Rejected';
              }
            return InkWell(
              onTap: () =>
                  _onTapItem(context, parentRequestDataModel[position]),
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                color: Colors.white.withAlpha(200),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Container(
                              width: MediaQuery.of(context).size.width/1.36,
             
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Text('Student Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '${parentRequestDataModel[position].studentName}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Text('AdmissionNo',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '${parentRequestDataModel[position].admissionNo}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Text('Father Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '${parentRequestDataModel[position].fatherName}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Text('Parent Request Type',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '${parentRequestDataModel[position].parentRequestType}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                         Row(
                                          children: [
                                            const Text('Rquest Person Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '${parentRequestDataModel[position].personName}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Text('Route Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '${parentRequestDataModel[position].routeName}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width/1.7,
                                          child: Row(
                                          children: [
                                            const Text('Request Date & Time',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                                 
                                            Text(
                          
                                              '${parentRequestDataModel[position].requestRaisedDateAndTime}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                              
                                                  fontWeight: FontWeight.w200),
                                            )
                                          ],
                                        ),
                                        ),
                                       
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  
                            ),
                           Expanded(
                            child:Container(
                          
                                child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(height: 10),
                                          Visibility( visible: isVisibleapprove,
                                          child: ElevatedButton(
                                      
                                            onPressed: () {
                                              _approveparentrequestdata(parentRequestDataModel[position].parentRequestId);
                                              // clickOnParentRequest(context);
                                              // Navigator.of(context).push(
                                              //   // MaterialPageRoute(builder: (context) => Otp()),
                                              // );
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                              backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromRGBO(
                                                      31, 194, 13,
                                                      1).withAlpha(95)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Text(
                                                approve,
                                                style: const TextStyle(fontSize: 9),
                                              ),
                                            ),
                                          ),),
                                          Visibility(visible:isVisiblereject,child: ElevatedButton(
                                            onPressed: () {
                                              _rejectparentrequestdata(parentRequestDataModel[position].parentRequestId);
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                              backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromRGBO(
                                                      236, 119, 131, 1)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            child:  Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Text(
                                                reject,
                                                style: const TextStyle(fontSize: 9),
                                              ),
                                            ),
                                          ),)
                                        ],
                                      ),
                                    
                                    ),
                            ),
                        
                                    
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, ParentRequestDataModel article) {
    // Navigator.of(context).push(MaterialPageRoute(
    // builder: (BuildContext context) => ChildrensProfileDetails(article)));
  }

  Future _approveparentrequestdata(ParentRequestId) async {
    var  UserId = await SaveSharedPreference.getUserId();
    var  BranchId = await SaveSharedPreference.getBranchId();
    var data = {
      'ParentRequestId': ParentRequestId,
      'ParentRequestStatusId': '2',
      'UserId': UserId,

    };
    var res = await CallApi().postData(data, 'STS/AdminUpdateParentRequest');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      setState(() {
        isVisiblereject=false;
      });

    }else{
      showSnackBar(context, responsemessage);
    }
  }
  Future _rejectparentrequestdata(ParentRequestId) async {
    var  UserId = await SaveSharedPreference.getUserId();
    var  BranchId = await SaveSharedPreference.getBranchId();
    var data = {
      'ParentRequestId': ParentRequestId,
      'ParentRequestStatusId': '3',
      'UserId': UserId,

    };
    var res = await CallApi().postData(data, 'STS/AdminUpdateParentRequest');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      setState(() {
        isVisibleapprove=false;
      });

    }else{
      showSnackBar(context, responsemessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // show the snackbar with some text
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('The System Back Button is Deactivated')));
      return false;
    },
    child:Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(23, 171, 144, 1),
                Color.fromRGBO(13, 191, 194, 1),
                Color.fromRGBO(23, 171, 144, 0.4),
              ],
            )),
          ),
          // backgroundColor: Colors.cyan,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            iconSize: 20.0,
            onPressed: () {
              _goBack(context);
            },
          ),
          title: const Text('Parent Request List')),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data as List<ParentRequestDataModel>)
                : const Center(child: CircularProgressIndicator());
          }),
    ),
    );
  }

  _goBack(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }
}
