import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/datamodelclass/MastersDataModelClass.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/utils/utils.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schooltrackingsystem/webservices/SaveSharedPreference.dart';

class IDCardMissingRequest extends StatefulWidget {
  const IDCardMissingRequest({super.key});

  @override
  _IDCardMissingRequestState createState() => _IDCardMissingRequestState();
}

class _IDCardMissingRequestState extends State<IDCardMissingRequest> {
  var ClassListId;
  var CalssListName;
  var sectionListId;
  var sectionListName;
  var studentListId;
  var studentListName;
  var idcardlosttypeListId;
  var idcardlosttypeListName;
  List<MastersDataModelClass> list = [];
  List<MastersDataModelClass> sectionlist = [];
  List<MastersDataModelClass> studentslist = [];
  List<MastersDataModelClass> idcardlosttypelist = [];
  final imgPicker = ImagePicker();
  String? photoBase64;
  File? imgFile;

  @override
  void initState() {
    geClassData();
    super.initState();
  }

  Future<void> clickOnParentRequest(BuildContext context) async {
    if (imgFile == null) {
      showErrorDialog(context, 'Upload Your Id');
    } else if (ClassListId == null) {
      showErrorDialog(context, 'Select Class');
    } else if (sectionListId == null) {
      showErrorDialog(context, 'Select Section');
    } else if (studentListId == null) {
      showErrorDialog(context, 'Select Student');
    } else if (idcardlosttypeListId == null) {
      showErrorDialog(context, 'Select ID Card Lost Type');
    } else {
      _saveIdLosatdatadetails();
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

  Future<List<MastersDataModelClass>> geClassData() async {
    var data = {'Action': 'Class'};
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

  Future<List<MastersDataModelClass>> getsectionData() async {
    var data = {'Action': 'Section'};
    var res = await CallApi().postData(data, 'STS/GetMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    sectionlist = rest
        .map<MastersDataModelClass>(
            (json) => MastersDataModelClass.fromJson(json))
        .toList();
    return sectionlist;
  }

  Future<List<MastersDataModelClass>> gestudentsData(
      ClassListId, SectionListId) async {
    var data = {
      'Action': 'Student',
      'ClassId': ClassListId,
      'SectionID': SectionListId
    };
    var res = await CallApi().postData(data, 'STS/GetMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    studentslist = rest
        .map<MastersDataModelClass>(
            (json) => MastersDataModelClass.fromJson(json))
        .toList();
    return studentslist;
  }

  Future<List<MastersDataModelClass>> geIDcardlosttypeData() async {
    var data = {'Action': 'IdCardRequestFor'};
    var res = await CallApi().postData(data, 'STS/GetMaster');
    print("requestBody ${res.body}");
    // var finalData = res.body["Data"];
    var body = json.decode(res.body);
    var rest = body["Data"] as List;
    print(rest);
    idcardlosttypelist = rest
        .map<MastersDataModelClass>(
            (json) => MastersDataModelClass.fromJson(json))
        .toList();
    return idcardlosttypelist;
  }

  Widget CategoryList() {
    return WillPopScope(
      onWillPop: () async {
        // show the snackbar with some text
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: SingleChildScrollView(
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
                      labelText: 'Class',
                      hintText: 'Select Class',
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        print("onchamged $newValue");
                        final split = newValue!.split(',');
                        final Map<int, String> values = {
                          for (int i = 0; i < split.length; i++) i: split[i]
                        };
                        print(values);
                        ClassListId = values[0];
                        CalssListName = values[1];
                        print('CalssListName $CalssListName');
                        print('ClassListId $ClassListId');
                        FutureBuilder(
                            future: getsectionData(),
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
                        value: '${map.id},${map.name}',
                        child: Text(
                          map.name.toString(),
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
                      labelText: 'Section',
                      hintText: 'Select section',
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        print("onchamged $newValue");
                        final split = newValue!.split(',');
                        final Map<int, String> values = {
                          for (int i = 0; i < split.length; i++) i: split[i]
                        };
                        print(values);
                        sectionListId = values[0];
                        sectionListName = values[1];
                        print(sectionListId);
                        print('sectionListName $sectionListName');
                        print('sectionListId $sectionListId');
                        FutureBuilder(
                            future: gestudentsData(ClassListId, sectionListId),
                            builder: (context, snapshot) {
                              return snapshot.data != null
                                  ? CategoryList()
                                  : const Center(
                                      child: CircularProgressIndicator());
                            });
                        // dropdownValue = newValue!;
                      });
                    },
                    items: sectionlist.map((MastersDataModelClass map) {
                      return DropdownMenuItem<String>(
                        value: '${map.id},${map.name}',
                        child: Text(
                          map.name.toString(),
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
                      labelText: 'Students',
                      hintText: 'Select Student',
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        print("onchamged $newValue");
                        final split = newValue!.split(',');
                        final Map<int, String> values = {
                          for (int i = 0; i < split.length; i++) i: split[i]
                        };
                        print(values);
                        studentListId = values[0];
                        studentListName = values[1];
                        print('studentListName $studentListName');
                        print('studentListId $studentListId');
                        FutureBuilder(
                            future: geIDcardlosttypeData(),
                            builder: (context, snapshot) {
                              return snapshot.data != null
                                  ? CategoryList()
                                  : Center(
                                      child: Column(
                                        children: const [
                                          CircularProgressIndicator(),
                                          Text(
                                            'No Data Found',
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          ),
                                        ],
                                      ),
                                    );
                            });
                        // dropdownValue = newValue!;
                      });
                    },
                    items: studentslist.map((MastersDataModelClass map) {
                      return DropdownMenuItem<String>(
                        value: '${map.id},${map.name}',
                        child: Text(map.name.toString()),
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
                      labelText: 'ID Card Lost Status',
                      hintText: 'Select ID Card Lost Type',
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        print("onchamged $newValue");
                        final split = newValue!.split(',');
                        final Map<int, String> values = {
                          for (int i = 0; i < split.length; i++) i: split[i]
                        };
                        print(values);
                        idcardlosttypeListId = values[0];
                        idcardlosttypeListName = values[1];
                        print('idcardlosttypeListName $idcardlosttypeListName');
                        print('idcardlosttypeListId $idcardlosttypeListId');
                        // dropdownValue = newValue!;
                      });
                    },
                    items: idcardlosttypelist.map((MastersDataModelClass map) {
                      return DropdownMenuItem<String>(
                        value: '${map.id},${map.name}',
                        child: Text(
                          map.name.toString(),
                        ),
                      );
                    }).toList(),
                  )),
              Padding(
                padding: const EdgeInsets.all(5),
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
      ),
    );
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
          title: const Text('IDCard Missing Request')),
      body: FutureBuilder(
          future: geClassData(),
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

  Future _saveIdLosatdatadetails() async {
    var UserId = await SaveSharedPreference.getUserId();
    var data = {
      'ClassId': ClassListId,
      'SectionId': sectionListId,
      'StudentId': studentListId,
      'IdCardRequestTypeId': idcardlosttypeListId,
      'Base64StringImage': photoBase64,
      'UserId': UserId,
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/SaveStudentidCardRequest');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const DashBoardScreen()));
      showSnackBar(context, responsemessage);
    } else {
      showSnackBar(context, responsemessage);
    }
  }
}
