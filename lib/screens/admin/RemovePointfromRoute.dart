import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/RemovePointfromRouteDataModel.dart';
import 'package:schooltrackingsystem/datamodelclass/RoutePointsMasterDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';

class RemovePointfromRoute extends StatefulWidget {
  const RemovePointfromRoute({super.key});

  @override
  _RemovePointfromRouteState createState() => _RemovePointfromRouteState();
}

class _RemovePointfromRouteState extends State<RemovePointfromRoute> {
  var BranchId;
  String? RouteListId;
  bool ispointslistvisible = false;
  List<RemovePointfromRouteDataModel> list = [];
  List<RoutePointsMasterDataModelClass> routepointslist = [];

  @override
  void initState() {
    getAllroutesData();
    super.initState();
  }

  Future<List<RemovePointfromRouteDataModel>> getAllroutesData() async {
    var BranchId= await SaveSharedPreference.getBranchId();
    var data = {'ActionName': 'Type','BranchId':BranchId};
    var res = await CallApi().postData(data, 'STS/RouteMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    if(body['Data']!=null){
      var rest = body["Data"] as List;
      print(rest);
      list = rest
          .map<RemovePointfromRouteDataModel>(
              (json) => RemovePointfromRouteDataModel.fromJson(json))
          .toList();
    }else{
      list=[];
    }

    return list;
  }

  Future<List<RoutePointsMasterDataModelClass>> getAllroutePointsData(
      RouteListId) async {
    ispointslistvisible = true;
    var data = {'RouteId': RouteListId};
    print("RouteId $RouteListId");
    var res = await CallApi().postData(data, 'sts/GetRoutePoints');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    if(body["Data"]==null){
      routepointslist = [];
    }else{
      var rest = body["Data"] as List;
      print(rest);
      routepointslist = rest
          .map<RoutePointsMasterDataModelClass>(
              (json) => RoutePointsMasterDataModelClass.fromJson(json))
          .toList();
    }
    return routepointslist;
  }

 Future _removepointdatafromroute(routePointId) async {
   var  UserId = await SaveSharedPreference.getUserId();
    var data = {
      'Action': 'DeleteRoutePoint1',
      'RoutePointsId': routePointId,
      'UserId': UserId,

    };
    print('requestforremovedata {$data}');
    var res = await CallApi().postData(data, 'STS/DeleteRoutePoints');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const RemovePointfromRoute()), 
    (Route<dynamic> route) => false,);
    showSnackBar(context, responsemessage);

    }else{
      showSnackBar(context, responsemessage);


    }
  }


  Widget RoutePointsList() {
    print('pointlistdata');
    print('routepointslist $routepointslist');
    var datalength = routepointslist.length;
    print("data length");
    print(datalength);
    return datalength < 1 ? Container(child: const Center(child: Text("No Data Found"),),) : SingleChildScrollView(
        physics: const ScrollPhysics(),
        child:Column(
          children: [
             ListView.builder(
                itemCount: routepointslist.length,
                shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(2.0),
                itemBuilder: (context, position) {
                  return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(routepointslist[position].toString()),
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          // routepointslist.removeAt(position);
                          _removepointdatafromroute(routepointslist[position].routePointsId);
                        });
                      },
                      child: InkWell(
                        onTap: () => _onTapItem(context, routepointslist[position]),
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
                                                 width: MediaQuery.of(context).size.width/1.85,
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
                                                Container(
                                                   width: MediaQuery.of(context).size.width/1.85,
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
                                      ),
                                    ),
                                    // Expanded(
                                    //     flex: 1,
                                    //     child: Container(
                                    //       child: Column(
                                    //         crossAxisAlignment:
                                    //         CrossAxisAlignment.stretch,
                                    //         children: [
                                    //           SizedBox(height: 10),
                                    //           InkWell(
                                    //             onTap: () {},
                                    //             child: IconButton(
                                    //                 icon: const Icon(
                                    //                   Icons.delete_rounded,
                                    //                   color: Colors.white,
                                    //                 ),
                                    //                 onPressed: () {
                                    //                   setState(() {});
                                    //                 }),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                })
          ],
        )
      );
  }

  void _onTapItem(
      BuildContext context, RoutePointsMasterDataModelClass article) {
    // Navigator.of(context).push(MaterialPageRoute(
    // builder: (BuildContext context) => ChildrensProfileDetails(article)));
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
      child: Scaffold(
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
            title: const Text('Remove Point Stop',style: TextStyle(color: Colors.white70),)),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder(
                  future: getAllroutesData(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? RoutesList()
                        : const Center(child: CircularProgressIndicator());
                  }),
              Visibility(
                visible: ispointslistvisible,
                child: FutureBuilder(
                    future: getAllroutePointsData(RouteListId),
                    builder: (context, snapshot) {
                      return snapshot.data != null
                          ? RoutePointsList()
                          : const Center(child: CircularProgressIndicator());
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  _goBack(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }

  Widget RoutesList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        margin: const EdgeInsets.only(right: 15, left: 15),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Route Name',
                    hintText: 'Select Route',
                  ),
                  value: RouteListId,
                  onChanged: (newValue) {
                    RouteListId = newValue;
                    print("CategoryListId $RouteListId");
                    setState(() {
                      print("onchamged $newValue");
                      getAllroutePointsData(newValue);
                    });
                  },
                  items: list.map((RemovePointfromRouteDataModel map) {
                    return DropdownMenuItem<String>(
                      value: map.routeId.toString(),
                      child: Text(
                        map.routeName.toString(),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
