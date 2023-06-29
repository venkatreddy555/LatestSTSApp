import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
// ignore: depend_on_referenced_packages
import 'package:flutter_calendar_carousel/classes/event.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:schooltrackingsystem/datamodelclass/AttendanceAbsentListDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  _CalendarPage2State createState() => _CalendarPage2State();
}

// List<DateTime> presentDates = [
//   DateTime(2023, 02, 1),
//   DateTime(2023, 02, 3),
//   DateTime(2023, 02, 4),
//   DateTime(2023, 02, 5),
//   DateTime(2023, 02, 6),
//   DateTime(2023, 02, 9),
//   DateTime(2023, 02, 10),
//   DateTime(2023, 02, 11),
//   DateTime(2023, 02, 15),
//   DateTime(2023, 02, 22),
//   DateTime(2023, 02, 23),
// ];
// List<DateTime> absentDates = [
//   DateTime(2023, 02, 2),
//   DateTime(2023, 02, 7),
//   DateTime(2023, 02, 8),
//   DateTime(2023, 02, 12),
//   DateTime(2023, 02, 13),
//   DateTime(2023, 02, 14),
//   DateTime(2023, 02, 16),
//   DateTime(2023, 02, 17),
//   DateTime(2023, 02, 18),
//   DateTime(2023, 02, 19),
//   DateTime(2023, 02, 20),
// ];
List<DateTime> absentDates = [];
List<DateTime> presentDates = [];

class _CalendarPage2State extends State<Attendance> {
  List<ChildrensProfilesDataModel> childrenslist = [];
  List<AttendanceAbsentListDataModelClass> absentlist = [];
  List<AttendanceAbsentListDataModelClass> presentlist = [];
  String? ChildrenListId;
  String? ChildrenListName;
  var MobileNumber;
  var year;
  var Month;
  var outputDate;

  Future<List<ChildrensProfilesDataModel>> getchildrenData() async {
    MobileNumber = await SaveSharedPreference.getMobileNumber();
    print(MobileNumber);
    var data = {'MobileNumber': MobileNumber};
    var res = await CallApi().postData(data, 'STS/GetChildrens');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);

    var rest = body["Data"] as List;
    print(rest);

    childrenslist = rest
        .map<ChildrensProfilesDataModel>(
            (json) => ChildrensProfilesDataModel.fromJson(json))
        .toList();

    return childrenslist;
  }

  Future<List<AttendanceAbsentListDataModelClass>> getaddendancedata(
      year, Month, StudentlistId) async {
    print('year $year,Month $Month,studentlistId $StudentlistId');
    // need to change the student Id
    var data = {'Year': year, 'Month': Month, 'StudentId': StudentlistId};
    print('requestdata $data');
    var res = await CallApi().postData(data, 'STS/GetStudentAttendanceDayWise');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    if (body["Absent"] == null && body['Present'] == null) {
      showSnackBar(context, 'No Data Found');
    } else {
      var rest = body["Absent"] as List;
      var rest1 = body['Present'] as List;
      print(rest);

      absentlist = rest
          .map<AttendanceAbsentListDataModelClass>(
              (json) => AttendanceAbsentListDataModelClass.fromJson(json))
          .toList();
      presentlist = rest1
          .map<AttendanceAbsentListDataModelClass>(
              (json) => AttendanceAbsentListDataModelClass.fromJson(json))
          .toList();
    }

    for (int i = 0; i < absentlist.length; i++) {
      var year = int.parse(absentlist[i].year!);
      var month = int.parse(absentlist[i].month!);
      var day = int.parse(absentlist[i].day!);
      absentDates.add(DateTime(year, month, day));
      print(
          'absentDatesarraylist ${absentDates[i].year},${absentDates[i].month},${absentDates[i].day}');
    }
    for (int i = 0; i < presentlist.length; i++) {
      var year = int.parse(presentlist[i].year!);
      var month = int.parse(presentlist[i].month!);
      var day = int.parse(presentlist[i].day!);
      presentDates.add(DateTime(year, month, day));
      print(
          'presentDatesarraylist ${presentDates[i].year},${presentDates[i].month},${presentDates[i].day}');
    }
    setState(() {
      for (int i = 0; i < presentDates.length; i++) {
        print(
            'presentDateslist2 ${presentDates[i].year},${presentDates[i].month},${presentDates[i].day}');
        _markedDateMap.add(
          presentDates[i],
          Event(
            date: presentDates[i],
            title: 'Present',
            icon: _presentIcon(
              presentDates[i].day.toString(),
            ),
          ),
        );
      }
      for (int i = 0; i < absentDates.length; i++) {
        print(
            'absentDateslist2 ${absentDates[i].year},${absentDates[i].month},${absentDates[i].day}');
        _markedDateMap.add(
          absentDates[i],
          Event(
            date: absentDates[i],
            title: 'Absent',
            icon: _absentIcon(
              absentDates[i].day.toString(),
            ),
          ),
        );
      }
    });

    return absentlist;
  }

  @override
  void initState() {
    DateTime currentDate = DateTime.now();
    Month = currentDate.month;
    year = currentDate.year;
    print('currentyear $year');
    print('currentmonth $Month');

    super.initState();
  }

  static Widget _presentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.green.withAlpha(150),
        child: Text(
          day,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      );

  static Widget _absentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.red.withAlpha(150),
        child: Text(
          day,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      );

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
  );

  CalendarCarousel? _calendarCarouselNoHeader;

  var len = min(absentDates.length, presentDates.length);
  double? cHeight;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: cHeight! * 0.50,
      weekendTextStyle: const TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.cyan.withAlpha(600),

      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null,
      onCalendarChanged: (DateTime date) {
        setState(() {
          year = date.year;
          Month = date.month;
          print('selectedyear $year');
          print('selectedmonth $Month');
          getaddendancedata(year, Month, ChildrenListId);
        });
      },
      // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return event.icon;
      },
    );

    return Scaffold(
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
          title: const Text('Attendance Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: getchildrenData(),
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(13, 191, 194, 1)),
                                borderRadius: BorderRadius.circular(4)),
                            border: const OutlineInputBorder(),
                            labelText: 'Children\'s',
                            hintText: 'Select Children',
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              print("onchamged $newValue");

                              final split = newValue!.split(',');
                              final Map<int, String> values = {
                                for (int i = 0; i < split.length; i++)
                                  i: split[i]
                              };
                              print(values);
                              ChildrenListId = values[0];
                              print('ChildrenListId $ChildrenListId');
                              if (ChildrenListId != null) {
                                getaddendancedata(year, Month, ChildrenListId);
                              }
                            });
                          },
                          items: childrenslist
                              .map((ChildrensProfilesDataModel map) {
                            return DropdownMenuItem<String>(
                              value: map.studentId.toString(),
                              child: Text(
                                "${map.surName} ${map.firstName}",
                              ),
                            );
                          }).toList(),
                        )
                      : const Center(child: CircularProgressIndicator());
                }),
            const SizedBox(
              height: 20,
            ),
            _calendarCarouselNoHeader!,
            markerRepresent(Colors.red.withAlpha(150), "Absent"),
            markerRepresent(Colors.green.withAlpha(150), "Present"),
          ],
        ),
      ),
    );
  }

  Widget markerRepresent(Color color, String data) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        radius: cHeight! * 0.022,
      ),
      title: Text(
        data,
      ),
    );
  }

  _goBack(BuildContext context) {
    absentDates.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }
}
