

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:schooltrackingsystem/datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class AttendanceCalandarData extends StatefulWidget {
  const AttendanceCalandarData({super.key});


  @override
  _AttendanceCalandarDataState createState() => _AttendanceCalandarDataState();

}
class _AttendanceCalandarDataState extends State<AttendanceCalandarData> {
  String? _month, _year;
  List<ChildrensProfilesDataModel> childrenslist = [];
  String? ChildrenListId;
  String? ChildrenListName;
  var MobileNumber;
   List<Meeting> meetings = <Meeting>[];

  @override
  void initState() {
    super.initState();
  }

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
          title: const Text('Attendance Data')),

          body:Stack(
            children: [
              Padding(padding:const EdgeInsets.all(10),
              child:Column(
                children: [

                  FutureBuilder(
                      future: getchildrenData(),
                      builder: (context, snapshot) {
                        return snapshot.data != null
                            ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(13, 191, 194, 1)),
                                borderRadius:
                                BorderRadius.circular(4)),
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
                            : const Center(
                            child: CircularProgressIndicator());
                      }),
                  Expanded(
                   
                    child: SfCalendar(
                  
                      view: CalendarView.month,
                      dataSource: MeetingDataSource(_getDataSource()),
                      onViewChanged:viewChanged,
                      // by default the month appointment display mode set as Indicator, we can
                      // change the display mode as appointment using the appointment display
                      // mode property
                      monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                    ),
                  )
                ],
              ) ,)

            ],
          )

    ),
    );
  }

  _goBack(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      setState(() {
        _month = DateFormat('MM').format(viewChangedDetails
            .visibleDates[viewChangedDetails.visibleDates.length ~/ 2]).toString();
        _year = DateFormat('yyyy').format(viewChangedDetails
            .visibleDates[viewChangedDetails.visibleDates.length ~/ 2]).toString();
        print('year $_year');
        print('month $_month');
      });
    });
  }
}

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    // final DateTime startTime = DateTime(today.year, today.month, today.day,9,0,0);
    // final DateTime startTime1 = DateTime(today.year, today.month, today.day+1);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(Meeting(
    //     'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    // meetings.add(Meeting(
    //     'Conference', startTime1, endTime, const Color(0xFFFAB9C2), false));
    return meetings;
  }


class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}



