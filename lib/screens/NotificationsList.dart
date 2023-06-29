import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/NotificationListDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:readmore/readmore.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({super.key});

  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  var MobileNumber;

  @override
  void initState() {
    super.initState();
  }

  Future<List<NotificationListDataModelClass>> getData() async {
    List<NotificationListDataModelClass> list;
    MobileNumber = await SaveSharedPreference.getMobileNumber();
    print(MobileNumber);
    var data = {'MobileNumber': MobileNumber};
    var res =
        await CallApi().postData(data, 'STS/GetNotificationDetailsForParent');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<NotificationListDataModelClass>(
            (json) => NotificationListDataModelClass.fromJson(json))
        .toList();
    return list;
  }

  Widget listViewWidget(
      List<NotificationListDataModelClass> notificationListDataModelClass) {
    return Container(
      child: ListView.builder(
          itemCount: notificationListDataModelClass.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () =>{
                if(notificationListDataModelClass[position].isNotificationReaded=="False"){
                  _onTapItem(context, notificationListDataModelClass[position]),
                }
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                color: notificationListDataModelClass[position]
                            .isNotificationReaded =="False"
                    ? Colors.grey.withAlpha(70)
                    :Colors.white.withAlpha(200),
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
                                      '${notificationListDataModelClass[position].studentName}',
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
                                    const Text('NotificationType',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const Text(' : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                      '${notificationListDataModelClass[position].notificationType}',
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
                                    const Text('NotificationMessage',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const Text(' : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/2.15,
                                      child: ReadMoreText(
                                        '${notificationListDataModelClass[position].notificationMessage}',
                                        trimLines: 2,
                                        colorClickableText: Colors.red,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: 'Show less',
                                        moreStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),

                                    // Text(
                                    //   '${notificationListDataModelClass[position].notificationMessage}',
                                    //   style: const TextStyle(
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.w200),
                                    // )
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text('DateOfnotificationReceived',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const Text(' : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                      '${notificationListDataModelClass[position].dateOfnotificationSent}',
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

  void _onTapItem(
      BuildContext context, NotificationListDataModelClass article) {
    _notificationreadunreadstatusData(article.notificationSentdetailsId);

  }

  Future _notificationreadunreadstatusData(notificationsentdetailsId) async {
    var data = {'NotificationSentdetails_Id': notificationsentdetailsId};
    var res = await CallApi().postData(data, 'STS/UpdateNotificationRead');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    print(body);
    if (responsecode == "1") {
      showSnackBar(context, responsemessage);
    } else {
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
            title: const Text('Notifications')),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? listViewWidget(
                      snapshot.data as List<NotificationListDataModelClass>)
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
