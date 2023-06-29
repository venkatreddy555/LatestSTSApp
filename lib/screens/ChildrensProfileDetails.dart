import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/screens/ChildrensProfileList.dart';
import 'package:schooltrackingsystem/webservices/API.dart';
import 'package:schooltrackingsystem/widgets/CardCustomPainter.dart';
import '../datamodelclass/ChildrensProfilesDataModel.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ChildrensProfileDetails extends StatefulWidget {
  final ChildrensProfilesDataModel article;

  const ChildrensProfileDetails(this.article, {super.key});

  @override
  _ChildrensProfileDetailsState createState() =>
      _ChildrensProfileDetailsState(article);
}

class _ChildrensProfileDetailsState extends State<ChildrensProfileDetails> {
  final ChildrensProfilesDataModel article;
  bool _isLoading = false;

  _ChildrensProfileDetailsState(this.article);

  var FirstName,
      SurName,
      ClassName,
      BranchName,
      GenderName,
      SectionName,
      DOB,
      FatherName,
      FatherMobileNo,
      OccupationName,
      Fatheremail,
      BloodGroupName,
      StudentEMailId,
      StudentImage;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _childrendetails();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
      // show the snackbar with some text
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('The System Back Button is Deactivated')));
      return false;
    },
    child:_isLoading
        ? const Center(child:CircularProgressIndicator()) // this will show when loading is true
        : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      child:ClipRRect(
          borderRadius: BorderRadius.circular(0),
        child: CustomPaint(
          size: Size(width, height),
          painter: CardCustomPainter(),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          AntDesign.arrowleft,
                          color: Colors.white,
                        ),
                        iconSize: 40.0,
                        onPressed: () {
                          _goBack(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 165,
                  ),
                  Center(
                    child:StudentImage==''?
                        Container(
                          width: 120,
                         // height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child:  Center(
                            child:Image.asset('assets/images/profile.png',
                            width: 120,
                            height: 120,),
                          ),
                        ):Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(StudentImage!!),
                            fit: BoxFit.fill),
                        shape: BoxShape.circle,
                        color: const Color(0xffD6D6D6)
                      ),
                    ),
                    ),
                    // child: Image.asset(
                    //   'assets/images/profile.png',
                    //   width: 120,
                    //   height: 120,
                    // ),
                  const SizedBox(
                    height: 10,
                  ),
                   Column(
                     children: [
                       Text(
                         '$SurName $FirstName',
                         style: const TextStyle(
                           color: Color.fromRGBO(39, 105, 171, 1),
                           fontSize: 16,
                         ),
                       ),
                       const SizedBox(
                         height: 5,
                       ),
                       Text(
                         '$BranchName',
                         style: const TextStyle(
                           color: Color.fromRGBO(39, 105, 171, 1),
                           fontSize: 16,
                         ),
                       ),
                       const SizedBox(
                         height: 5,
                       ),
                       Text(
                         '$ClassName $SectionName',
                         style: const TextStyle(
                           color: Color.fromRGBO(39, 105, 171, 1),
                           fontSize: 14,
                         ),
                       ),

                     ],
                   ),
                   Card(
                    elevation: 25,
                    shadowColor: Colors.black,
                    color: Colors.white.withAlpha(200),
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$SurName $FirstName',
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
                                            const Text('Gender',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$GenderName',
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
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$DOB',
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
                                            const Text('Blood Group',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$BloodGroupName',
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
                                            const Text('Student Email',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$StudentEMailId',
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
                                            const Text('Father Name',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$FatherName',
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
                                            const Text('Father MobileNumber',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$FatherMobileNo',
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
                                            const Text('Father Occupation',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$OccupationName',
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
                                            const Text('Father Email',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500)),
                                            const Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              '$Fatheremail',
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
                ],
              )
            ],
          ),
        ),
      ),
      ),
    ),
    );
  }

  _goBack(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const ChildrensProfileList()));
  }

  Future _childrendetails() async {
    var data = {
      'StudentId': article.studentId,
    };
    print("requestBody $data");
    var res = await CallApi().postData(data, 'STS/GetStudentProfile');
    var body = json.decode(res.body);
    var responsecode = body['Code'].toString();
    var responsemessage = body['Message'].toString();
    if (responsecode == "1") {
      setState(() {
        _isLoading = false;
        FirstName = body['FirstName'].toString();
        SurName = body['SurName'].toString();
        ClassName = body['ClassName'].toString();
        BranchName = body['BranchName'].toString();
        GenderName = body['GenderName'].toString();
        SectionName = body['SectionName'].toString();
        DOB = body['DOB'].toString();
        FatherName = body['FatherName'].toString();
        FatherMobileNo = body['FatherMobileNo'].toString();
        OccupationName = body['OccupationName'].toString();
        Fatheremail = body['FatherEmailId'].toString();
        BloodGroupName = body['BloodGroupName'].toString();
        StudentEMailId = body['StudentEMailId'].toString();
        StudentImage = body['StudentImage'].toString();
        print("StudentImage $StudentImage");
      });
    }
  }
}
