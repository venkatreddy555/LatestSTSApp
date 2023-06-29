import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/AdminApprovedRequestListDataModel.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';


class AdminApprovedRequestList extends StatefulWidget {
  const AdminApprovedRequestList({super.key});

  @override
  _AdminApprovedRequestListState createState() =>
      _AdminApprovedRequestListState();
}

class _AdminApprovedRequestListState extends State<AdminApprovedRequestList> {
  var UserId;

  @override
  void initState() {
    super.initState();
  }

  Future<List<AdminApprovedRequestListDataModel>> getData() async {
    List<AdminApprovedRequestListDataModel> list;
    UserId = await SaveSharedPreference.getUserId();
    print(UserId);
    var data = {'UserId': UserId};
    var res = await CallApi().postData(data, 'STS/GetParentRequestForParent');
    print("AdminApprovedRequestrequestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<AdminApprovedRequestListDataModel>(
            (json) => AdminApprovedRequestListDataModel.fromJson(json))
        .toList();
    return list;
  }

  Widget listViewWidget(List<
      AdminApprovedRequestListDataModel> adminApprovedRequestListDataModel) {
    return Container(
      child: ListView.builder(
          itemCount: adminApprovedRequestListDataModel.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return Card(
              elevation: 20,
              shadowColor: Colors.black,
              color: Colors.white.withAlpha(200),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('StudentName',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${adminApprovedRequestListDataModel[position]
                                            .studentName}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
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
                                        '${adminApprovedRequestListDataModel[position]
                                            .admissionNo}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('ParentName',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${adminApprovedRequestListDataModel[position]
                                            .fatherName}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('ParentRequestType',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${adminApprovedRequestListDataModel[position]
                                            .parentRequestType}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('RouteName',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${adminApprovedRequestListDataModel[position]
                                            .routeName}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
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
                                        '${adminApprovedRequestListDataModel[position]
                                            .requestRaisedDateAndTime}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('ParentRequestStatus',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        '${adminApprovedRequestListDataModel[position]
                                            .parentRequestStatus}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  // void _onTapItem(BuildContext context, AdminApprovedRequestListDataModel article) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) => Ad(article)));
  // }

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
          title: const Text('Admin Approved Request Stop List')),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(
                snapshot.data as List<AdminApprovedRequestListDataModel>)
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
