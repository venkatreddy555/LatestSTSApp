import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:schooltrackingsystem/datamodelclass/RoutePointsMasterDataModelClass.dart';
import 'package:schooltrackingsystem/screens/admin/ViewAndEditRoutesList.dart';
import 'package:schooltrackingsystem/webservices/API.dart';


class RouteAllPoints extends StatefulWidget {
  const RouteAllPoints({super.key});

  @override
  _RouteAllPointsListState createState() => _RouteAllPointsListState();
}

class _RouteAllPointsListState extends State<RouteAllPoints> {
  var MobileNumber;
  var RouteListId;
  var RouteName;
  List<RoutePointsMasterDataModelClass> routepointslist = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List<RoutePointsMasterDataModelClass>> getAllroutePointsData(
      RouteListId) async {
    var data = {'RouteId': RouteListId};
    print("RouteId $RouteListId");
    var res = await CallApi().postData(data, 'sts/GetRoutePoints');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    routepointslist = rest
        .map<RoutePointsMasterDataModelClass>(
            (json) => RoutePointsMasterDataModelClass.fromJson(json))
        .toList();
    return routepointslist;
  }
  Widget listViewWidget(
      List<RoutePointsMasterDataModelClass> routePointsMasterDataModelClass) {

    return Container(
      child: ListView.builder(
          itemCount: routePointsMasterDataModelClass.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return InkWell(
              // onTap: () =>
              //     _onTapItem(context, routePointsMasterDataModelClass[position]),
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
                  child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Point No',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          const Text(' : ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          Text(
                            '${routepointslist[position].pointNo}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w200),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Point Name',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          const Text(' : ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          SizedBox(
                            width: 250,
                            child: Text(
                              '${routepointslist[position].pointName}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w200),
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Latitude',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          const Text(' : ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          Text(
                            '${routepointslist[position].latitude}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w200),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Longitude',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          const Text(' : ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          Text(
                            '${routepointslist[position].longitude}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w200),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('point Address',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          const Text(' : ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w500)),
                          SizedBox(
                            width: 250,
                            child: Text(
                              '${routepointslist[position].pointAddress}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w200),
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),),
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
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) => ChildrensProfileDetails(article)));
  }

  @override
  Widget build(BuildContext context) {
    final routeData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    RouteListId = routeData['RouteListId'].toString();
    RouteName = routeData['RouteName'].toString();
    print(RouteListId);
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
            title:Text(RouteName)),
        body: FutureBuilder(
            future: getAllroutePointsData(RouteListId),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? listViewWidget(
                  snapshot.data as List<RoutePointsMasterDataModelClass>)
                  : const Center(child: CircularProgressIndicator());
            }),
      ),);
  }
  _goBack(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ViewAndEditRoutesList()));
  }
}
