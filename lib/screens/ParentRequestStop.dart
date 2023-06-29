import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:schooltrackingsystem/datamodelclass/MastersDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/RouteMasterDataModelClass.dart';
import 'package:schooltrackingsystem/datamodelclass/RoutePointsMasterDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';
import 'package:location/location.dart';


class ParentRequestStop extends StatefulWidget {
  const ParentRequestStop({super.key});

  @override
  _ParentRequestStopState createState() => _ParentRequestStopState();
}

class _ParentRequestStopState extends State<ParentRequestStop> {
  bool isChecked = true;
  final _NameEditingController = TextEditingController();
  final _StartDateEditingController = TextEditingController();
  final _EndDateEditingController = TextEditingController();
  final _MobileNumberEditingController = TextEditingController();
  bool isVisibleName = false;
  bool isVisibleImage = false;
  var FromDateString;
  var EndDateString;
  var stringvalue;
  File? imgFile;
  final imgPicker = ImagePicker();
  String? photoBase64;
  List categoryItemlist = [];
  String? CategoryListId;
  String? CategoryListName;
  String? ChildrenListId;
  String? ChildrenListName;
  String? RouteListId;
  String? RouteListName;
  String? RoutePointListId;
  String? RoutePointListName;
  String? IsrequestedByPerson;
  String? RouteName;
  var UserId;
  LocationData? currentLcotion;
  RouteMasterDataModelClass? routeMasterDataModelClass;
  List<MastersDataModelClass> list = [];
  List<ChildrensProfilesDataModel> childrenslist = [];
  List<RouteMasterDataModelClass> routeslist = [];
  List<RoutePointsMasterDataModelClass> routepointslist = [];
  var MobileNumber;
  List catresult = [];
  @override
  void initState() {
    geCategorytData();
    isVisibleName = true;
    isVisibleImage = true;
    super.initState();
  }

  Future<void> clickOnParentRequest(BuildContext context) async {
    String patttern = "(0/91)?[6-9][0-9]{9}";
    RegExp regExp = RegExp(patttern);
    if (isChecked == true) {
      if (_StartDateEditingController.text.isEmpty) {
        showErrorDialog(context, 'From Date can\'t be empty.');
      } else if (_EndDateEditingController.text.isEmpty) {
        showErrorDialog(context, 'End Date can\'t be empty.');
      } else if (_NameEditingController.text.isEmpty) {
        showErrorDialog(context, 'Requested Person Name can\'t be empty.');
      } else if (_MobileNumberEditingController.text.isEmpty) {
        showErrorDialog(context, 'Mobile Number can\'t be empty.');
      } else if (_MobileNumberEditingController.text.toString().length < 10) {
        showErrorDialog(context, 'Enter valid 10 digit Mobile Number');
      } else if (!regExp
          .hasMatch(_MobileNumberEditingController.text.toString())) {
        showErrorDialog(context, 'Enter valid Mobile Number');
      } else if (imgFile == null) {
        showErrorDialog(context, 'Upload Your Id');
      } else if (CategoryListId == null) {
        showErrorDialog(context, 'Select Category');
      } else if (ChildrenListId == null) {
        showErrorDialog(context, 'Select Children');
      } else if (RouteListId == null) {
        showErrorDialog(context, 'Select RouteName');
      } else if (RoutePointListId == null) {
        showErrorDialog(context, 'Select PointName');
      } else {
        _parentrequestdetails();
      }
    } else if (isChecked == false) {
      if (_StartDateEditingController.text.isEmpty) {
        showErrorDialog(context, 'From Date can\'t be empty.');
      } else if (_EndDateEditingController.text.isEmpty) {
        showErrorDialog(context, 'End Date can\'t be empty.');
      } else if (CategoryListId == null) {
        showErrorDialog(context, 'Select Category');
      } else if (ChildrenListId == null) {
        showErrorDialog(context, 'Select Children');
      } else if (RouteListId == null) {
        showErrorDialog(context, 'Select RouteName');
      } else if (RoutePointListId == null) {
        showErrorDialog(context, 'Select PointName');
      } else {
        _parentrequestdetails();
      }
    }
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Options"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text("Capture Image From Camera"),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: const Text("Take Image From Gallery"),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      print("CameraPath $imgFile");
      List<int> imageBytes = imgFile!.readAsBytesSync();
      photoBase64 = base64Encode(imageBytes);
      print(photoBase64);
      // File file = File(imgGallery!.path);
      // Uint8List bytes = file.readAsBytesSync();
      // String base64Image = base64Encode(bytes);
      // print(base64Image);
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      print("GalleryPath $imgFile");
      List<int> imageBytes = imgFile!.readAsBytesSync();
      photoBase64 = base64Encode(imageBytes);
      print(photoBase64);
      // File file = File(imgGallery!.path);
      // Uint8List bytes = file.readAsBytesSync();
      // String base64Image = base64Encode(bytes);
      // print(base64Image);
    });
    Navigator.of(context).pop();
  }

  Widget displayImage() {
    if (imgFile == null) {
      return const Text("No Image Selected!");
    } else {
      return Image.file(imgFile!, width: 150, height: 150);
    }
  }

  Future<List<MastersDataModelClass>> geCategorytData() async {
    var data = {'Action': 'ParentRequestType'};
    var res = await CallApi().postData(data, 'STS/GetMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    list = rest
        .map<MastersDataModelClass>(
            (json) => MastersDataModelClass.fromJson(json))
        .toList();
    return list;
  }

  Future<List<RouteMasterDataModelClass>> getRoutesData() async {
     var BranchId= await SaveSharedPreference.getBranchId();
    var data = {'ActionName': 'Type','BranchId':BranchId};
    var res = await CallApi().postData(data, 'STS/RouteMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    routeslist = rest
        .map<RouteMasterDataModelClass>(
            (json) => RouteMasterDataModelClass.fromJson(json))
        .toList();
    return routeslist;
  }

  Future<List<RoutePointsMasterDataModelClass>> geRoutePointsData(
      RouteId) async {
    var data = {'RouteId': RouteId};
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

  Future<List<ChildrensProfilesDataModel>> gechildrensData(
      CategoryListId) async {
    MobileNumber = await SaveSharedPreference.getMobileNumber();
    var data = {
      'MobileNumber': MobileNumber,
      'ParentRequestTypeId': CategoryListId
    };
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

  Widget CategoryList() {
    return WillPopScope(
        onWillPop: () async {
      // show the snackbar with some text
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('The System Back Button is Deactivated')));
      return false;
    },
    child :SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        margin: const EdgeInsets.only(right: 15, left: 15),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Checkbox(
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                      if (value == true) {
                        print("1");
                        IsrequestedByPerson = "1";
                        isVisibleName = true;
                        isVisibleImage = true;
                      } else {
                        print("0");
                        IsrequestedByPerson = "0";
                        isVisibleName = false;
                        isVisibleImage = false;
                      }
                    });
                  },
                ),
                const Text(
                  'Requested By Person',
                  style: TextStyle(
                    color: Color.fromRGBO(39, 105, 171, 1),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                child: TextField(
                  cursorHeight: 20,
                  showCursor: false,
                  keyboardType: TextInputType.none,
                  controller: _StartDateEditingController,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.bottom,
                  cursorColor: Colors.blueGrey,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    suffixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.blueGrey,
                      size: 25,
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'From Date',
                    hintText: 'Select From Date',
                  ),
                  onTap: () async {
                    DateTime? startPickedDate = await showDatePicker(
                        context: context,
                        fieldLabelText: "Start Date",
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (startPickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(startPickedDate);
                      setState(() {
                        _StartDateEditingController.text =
                            formattedDate; //set output date to TextField value.
                        FromDateString =
                            DateFormat('yyyy-MM-dd').format(startPickedDate);
                        print("FromDateString $FromDateString");
                      });
                    }
                  },
                  // decoration: const InputDecoration(
                  //
                  //   border: OutlineInputBorder(
                  //     borderSide: BorderSide.none,),
                  //   prefixIcon: Icon(Icons.date_range,
                  //       color: Colors.blueGrey, size: 25),
                  //   hintText: "Enter date",
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                child: TextField(
                  cursorHeight: 20,
                  showCursor: false,
                  keyboardType: TextInputType.none,
                  controller: _EndDateEditingController,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.bottom,
                  cursorColor: Colors.blueGrey,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    suffixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.blueGrey,
                      size: 25,
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'To Date',
                    hintText: 'Select To Date',
                  ),
                  onTap: () async {
                    DateTime? startPickedDate = await showDatePicker(
                        context: context,
                        fieldLabelText: "End Date",
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (startPickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(startPickedDate);
                      setState(() {
                        _EndDateEditingController.text =
                            formattedDate; //set output date to TextField value.
                        EndDateString =
                            DateFormat('yyyy-MM-dd').format(startPickedDate);
                        print("FromDateString $EndDateString");
                      });
                    }
                  },
                  // decoration: const InputDecoration(
                  //
                  //   border: OutlineInputBorder(
                  //     borderSide: BorderSide.none,),
                  //   prefixIcon: Icon(Icons.date_range,
                  //       color: Colors.blueGrey, size: 25),
                  //   hintText: "Enter date",
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Visibility(
                visible: isVisibleName,
                child: TextField(
                  maxLines: 1,
                  controller: _NameEditingController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Requested Person Name',
                    hintText: 'Enter Person Name',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Visibility(
                visible: isVisibleName,
                child: TextField(
                  maxLines: 1,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: _MobileNumberEditingController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Mobile Number',
                    hintText: 'Enter Mobile Number',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Visibility(
                visible: isVisibleImage,
                child: Column(
                  children: <Widget>[
                    displayImage(),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showOptionsDialog(context);
                        },
                        icon: const Icon(Icons.camera),
                        //icon data for elevated button
                        label: const Text("Choose File"),
                        //label text
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(13, 191, 194,
                                1) //elevated btton background color
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Category',
                    hintText: 'Select Category',
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
                      CategoryListId = values[0];
                       CategoryListName= values[1];
                      print('CategoryListName $CategoryListName');
                      print('CategoryListId $CategoryListId');
                      FutureBuilder(
                          future: gechildrensData(CategoryListId),
                          builder: (context, snapshot) {
                            return snapshot.data != null
                                ? CategoryList()
                                : const Center(
                                    child: CircularProgressIndicator());
                          });
                    });
                  },
                  items: list.map((MastersDataModelClass map) {
                    print(map.name.toString());
                    return DropdownMenuItem<String>(
                      value:'${map.id},${map.name}',
                      child: Text(
                        map.name.toString(),
                      ),

                    );
                  }).toList(),
                )
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Children\'s',
                    hintText: 'Select children',
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
                      ChildrenListName= values[1];
                      print(ChildrenListId);
                      print('StudentListName $ChildrenListName');
                      print('StudentListId $ChildrenListId');
                      FutureBuilder(
                          future: getRoutesData(),
                          builder: (context, snapshot) {
                            return snapshot.data != null
                                ? CategoryList()
                                : const Center(
                                    child: CircularProgressIndicator());
                          });
                      // dropdownValue = newValue!;
                    });
                  },
                  items: childrenslist.map((ChildrensProfilesDataModel map) {
                    return DropdownMenuItem<String>(
                      value: '${map.studentId},${map.firstName}',
                      child: Text(
                        map.surName.toString() + map.firstName.toString(),
                      ),
                    );
                  }).toList(),
                )),
            Padding(
                padding: const EdgeInsets.all(5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Route Name',
                    hintText: 'Select RouteName',
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
                      RouteListId = values[0];
                      RouteListName= values[1];
                      print('RouteListName $RouteListName');
                      print('RouteListId $RouteListId');
                      FutureBuilder(
                          future: geRoutePointsData(RouteListId),
                          builder: (context, snapshot) {
                            return snapshot.data != null
                                ? CategoryList()
                                : Center(
                                    child: Column(
                                      children: const [
                                        CircularProgressIndicator(),
                                        Text('No Data Found',style: TextStyle(color: Colors.deepOrange),),
                                      ],
                                    ),
                                  );
                          });
                      // dropdownValue = newValue!;
                    });
                  },
                  items: routeslist.map((RouteMasterDataModelClass map) {
                    return DropdownMenuItem<String>(
                      value: '${map.routeId},${map.routeName}',
                      child: Text(map.routeName.toString()),
                    );
                  }).toList(),
                )),
            // new Text("selected user name is ${RouteListId.name} : and Id is : ${RouteListId.id}"),
            Padding(
                padding: const EdgeInsets.all(5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(4)),
                    border: const OutlineInputBorder(),
                    labelText: 'Point Name',
                    hintText: 'Select PointName',
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
                      RoutePointListId = values[0];
                      RoutePointListName= values[1];
                      print('RoutepointListName $RoutePointListName');
                      print('RoutepointListId $RoutePointListId');
                      // dropdownValue = newValue!;
                    });
                  },
                  items: routepointslist
                      .map((RoutePointsMasterDataModelClass map) {
                    return DropdownMenuItem<String>(
                      value: '${map.routePointsId},${map.pointName}',
                      child: Text(
                        map.pointName.toString(),
                      ),
                    );

                  }).toList(),

                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  clickOnParentRequest(context);
                  // Navigator.of(context).push(
                  //   // MaterialPageRoute(builder: (context) => Otp()),
                  // );
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(13, 191, 194, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),);
  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Request Stop')),
      body: FutureBuilder(
          future: geCategorytData(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? CategoryList()
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }

  _goBack(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
  }

  Future _parentrequestdetails() async {
  var  UserId = await SaveSharedPreference.getUserId();
    var data = {
      'DateOfRequest': _StartDateEditingController.text.toString(),
      'ToDateOfRequest': _EndDateEditingController.text.toString(),
      'IsrequestedByPerson': IsrequestedByPerson,
      'PersonName': _NameEditingController.text.toString(),
      'MobileNo': _MobileNumberEditingController.text.toString(),
      'Base64StringImage': photoBase64,
      'ParentRequestTypeId': CategoryListId,
      'StudentId': ChildrenListId,
      'ParentRequestStatusId': '',
      'RouteId': RouteListId,
      'RouteName': RouteListName,
      'RoutePointName': RoutePointListName,
      'StudentName': ChildrenListName,
      'RoutePointId': RoutePointListId,
      'UserId': UserId,
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/ParentRequestForPickupDropBoth');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
    showSnackBar(context, responsemessage);
    }else{
      showSnackBar(context, responsemessage);
    }
  }
}
