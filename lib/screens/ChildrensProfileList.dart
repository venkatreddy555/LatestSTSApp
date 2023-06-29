import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:schooltrackingsystem/screens/ChildrensProfileDetails.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';


class ChildrensProfileList extends StatefulWidget {
  const ChildrensProfileList({super.key});

  @override
  _ChildrensProfileListState createState() => _ChildrensProfileListState();
}

class _ChildrensProfileListState extends State<ChildrensProfileList> {
  var MobileNumber;

  @override
  void initState() {
    super.initState();
  }

  Future<List<ChildrensProfilesDataModel>> getData() async {
    List<ChildrensProfilesDataModel> list;

    MobileNumber = await SaveSharedPreference.getMobileNumber();
    print(MobileNumber);
    var data = {'MobileNumber': MobileNumber};
    var res = await CallApi().postData(data, 'STS/GetChildrens');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<ChildrensProfilesDataModel>(
            (json) => ChildrensProfilesDataModel.fromJson(json))
        .toList();
    return list;
  }

  Widget listViewWidget(
      List<ChildrensProfilesDataModel> childrensProfilesDataModel) {

    return Container(
      child: ListView.builder(
          itemCount: childrensProfilesDataModel.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () =>
                  _onTapItem(context, childrensProfilesDataModel[position]),
              child: Card(
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
                                    const Text('Name',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const Text(' : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                      '${childrensProfilesDataModel[position].surName} ${childrensProfilesDataModel[position].firstName}',
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
                                      '${childrensProfilesDataModel[position].admissionNo}',
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
                                    const Text('ClassName',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const Text(' : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                      '${childrensProfilesDataModel[position].className}',
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
                                    const Text('RollNo',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const Text(' : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                      '${childrensProfilesDataModel[position].rollNo}',
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
                                    const Text('DOB',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const Text(' : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                      '${childrensProfilesDataModel[position].dob}',
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
              ),
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, ChildrensProfilesDataModel article) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ChildrensProfileDetails(article)));
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
          title: const Text('Children\'s Profiles')),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(
                    snapshot.data as List<ChildrensProfilesDataModel>)
                : const Center(child: CircularProgressIndicator());
          }),
    ),);
  }
  _goBack(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }
}
