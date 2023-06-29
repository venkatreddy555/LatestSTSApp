import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/ViewAllRoutesEditDataModelClass.dart';
import 'package:schooltrackingsystem/screens/AddNewRoute.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';


class ViewAndEditRoutesList extends StatefulWidget {
  const ViewAndEditRoutesList({super.key});

  @override
  _ViewAndEditRoutesListState createState() => _ViewAndEditRoutesListState();
}

class _ViewAndEditRoutesListState extends State<ViewAndEditRoutesList> {
  var BranchId;

  @override
  void initState() {
    super.initState();
  }

  Future<List<ViewAllRoutesEditDataModelClass>> getData() async {
    List<ViewAllRoutesEditDataModelClass> list;

    BranchId = await SaveSharedPreference.getBranchId();
    print(BranchId);
    var data = {'RouteId': '','BranchId':BranchId};
    var res = await CallApi().postData(data, 'sts/GetRoute');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<ViewAllRoutesEditDataModelClass>(
            (json) => ViewAllRoutesEditDataModelClass.fromJson(json))
        .toList();
    return list;
  }

  Widget listViewWidget(
      List<ViewAllRoutesEditDataModelClass> viewAllRoutesEditDataModelClass) {

    return Container(
      child: ListView.builder(
          itemCount: viewAllRoutesEditDataModelClass.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () =>
                  _onTapItem(context, viewAllRoutesEditDataModelClass[position]),
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
                          Container(
                           width: MediaQuery.of(context).size.width/1.3,
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
                                        const Text('Route Name',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const Text(' : ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                          '${viewAllRoutesEditDataModelClass[position].routeName}',
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
                                        const Text('StartPoint Name',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const Text(' : ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            '${viewAllRoutesEditDataModelClass[position].startPointAddress}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200),
                                            maxLines: 2,
                                          ) ,

                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text('End Point Name',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const Text(' : ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 140,
                                          child:   Text(
                                            '${viewAllRoutesEditDataModelClass[position].endPointAddress}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200),
                                            maxLines: 2,
                                          ),
                                        ),

                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text('NoOfStops',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const Text(' : ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        InkWell(
                                          onTap: () async {
                                            await Navigator.pushNamed(context, '/RoutePoints',
                                                arguments: {'RouteListId':viewAllRoutesEditDataModelClass[position].routeId,'RouteName':viewAllRoutesEditDataModelClass[position].routeName});
                                          },
                                           child:Text(
                                              '${viewAllRoutesEditDataModelClass[position].noOfStops}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w200),
                                            )
                                        ),

                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )),
                          Expanded(
                            
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [

                                    // InkWell(
                                    //   child: IconButton(
                                    //     icon: Icon(
                                    //       Icons.edit,
                                    //       color: Colors.cyan,
                                    //     ),
                                    //     onPressed: () {
                                    //     },
                                    //   ),
                                    // ),
                                    CircleAvatar(
                                      backgroundColor: Colors.cyan,
                                      radius: 20,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.edit),
                                        color: Colors.white,
                                        onPressed: () {
                                          _onTapItem(context, viewAllRoutesEditDataModelClass[position]);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
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

  void _onTapItem(BuildContext context, ViewAllRoutesEditDataModelClass article) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AddNewRoute(article)));
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
            title: const Text('All Routes')),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? listViewWidget(
                  snapshot.data as List<ViewAllRoutesEditDataModelClass>)
                  : const Center(child: CircularProgressIndicator());
            }),
      ),);
  }
  _goBack(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }
}
