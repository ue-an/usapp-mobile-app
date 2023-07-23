import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/models/academic_year_dates.dart';
import 'package:usapp_mobile/2.0/models/request.dart';
import 'package:usapp_mobile/2.0/providers2/activity_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/auth_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/otp_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/request_provider.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';

class ProfileScreen2 extends StatefulWidget {
  const ProfileScreen2({Key? key}) : super(key: key);

  @override
  _ProfileScreen2State createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2>
    with AutomaticKeepAliveClientMixin<ProfileScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  FirestoreService2 firestoreService2 = FirestoreService2();
  RequestProvider2 requestProvider2 = RequestProvider2();
  late Stream<List<StudentNumber>> _streamStudent;
  late Stream<Request> _streamRequest;
  late Stream<List<AcademicYearDates>> _streamAYDates;
  late String _myFname = '';
  late String _myLname = '';
  late String _myEmail = '';
  late int _myYearLevel = 0;
  late int _myCompletionYear = 0;
  void _storeDetailsOnLocal() async {
    String? myFname =
        await context.read<LocalDataProvider2>().getLocalFirstName();
    String? myLname =
        await context.read<LocalDataProvider2>().getLocalLastName();
    String? myEmail = await context.read<LocalDataProvider2>().getLocalEmail();
    int? myYearLevel =
        await context.read<LocalDataProvider2>().getLocalYearLevel();
    int myCompletionYear =
        await context.read<LocalDataProvider2>().getLocalCompletionYear();

    setState(() {
      _myFname = myFname!;
      _myLname = myLname!;
      _myEmail = myEmail!;
      _myYearLevel = myYearLevel!;
      _myCompletionYear = myCompletionYear;
    });
  }

  @override
  void initState() {
    _storeDetailsOnLocal();
    _streamStudent = getCurrentStudent();
    waitCurrentStudent();
    (() async {
      String? email = await context.read<LocalDataProvider2>().getLocalEmail();
      _streamRequest = firestoreService2.getRequests(email!);
    }());
    initDetails();
    _streamAYDates = firestoreService2.getAcademicYearDates();
    setState(() {
      _isVisited = true;
    });

    super.initState();
  }

  Stream<List<StudentNumber>> getCurrentStudent() {
    return firestoreService2.getCurrentStudent();
  }

  Future<List<StudentNumber>> waitCurrentStudent() async {
    return await getCurrentStudent().first;
  }

  initDetails() async {
    var data = await waitCurrentStudent();
    for (var datus in data) {
      requestProvider2.changeReqCollege = datus.college;
      requestProvider2.changeReqCourse = datus.course;
      requestProvider2.changeReqFname = datus.firstName;
      requestProvider2.changeReqMinitial = datus.mInitial;
      requestProvider2.changeReqLname = datus.lastName;
      requestProvider2.changeReqSec = datus.section;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      transform: Matrix4.translationValues(
          context.read<SwipeProvider2>().xOffset,
          context.read<SwipeProvider2>().yOffset,
          0)
        ..scale(context.read<SwipeProvider2>().scaleFactor)
        ..rotateY(context.read<SwipeProvider2>().isDrawerOpen ? -0.5 : 0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        // borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 21,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      child: Scaffold(
        body: StreamBuilder<List<AcademicYearDates>>(
            stream: _streamAYDates,
            builder: (context, acadSnap) {
              if (acadSnap.hasData) {
                AcademicYearDates acadDates = acadSnap.data![0];
                return Container(
                  child: StreamBuilder<List<StudentNumber>>(
                    stream: _streamStudent,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            StudentNumber thisStudent = snapshot.data![index];
                            String thisStudentYearSec =
                                thisStudent.yearLvl.toString() +
                                    '-' +
                                    thisStudent.section.toString();
                            return Column(
                              children: [
                                SafeArea(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            // left: 9,
                                            ),
                                        child: SafeArea(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 9),
                                            child: IconButton(
                                              onPressed:
                                                  _handleMenuButtonPressed,
                                              icon: ValueListenableBuilder<
                                                  AdvancedDrawerValue>(
                                                valueListenable: context
                                                    .watch<
                                                        AdvDrawerController>()
                                                    .advDrawerController,
                                                builder: (_, value, __) {
                                                  return AnimatedSwitcher(
                                                    duration: const Duration(
                                                        milliseconds: 250),
                                                    child: Icon(
                                                      value.visible
                                                          ? Icons.arrow_back_ios
                                                          : Icons.menu,
                                                      color: Colors.white,
                                                      key: ValueKey<bool>(
                                                          value.visible),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // It will cover 20% of our total height
                                  height: size.height / 3,
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(150),
                                      ),
                                    ),
                                    margin: const EdgeInsets.all(16.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Stack(
                                              children: [
                                                snapshot.data![index]
                                                                .photoUrl ==
                                                            null ||
                                                        snapshot.data![index]
                                                                .photoUrl ==
                                                            ''
                                                    ? Initicon(
                                                        text: _myFname +
                                                            ' ' +
                                                            _myLname,
                                                        size: 120,
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    60)),
                                                        child: Image.network(
                                                          snapshot.data![index]
                                                              .photoUrl,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: size.height * .09,
                                                    left: size.width * .13,
                                                  ),
                                                  child: GFButton(
                                                    onPressed: () async {
                                                      final results =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        allowMultiple: false,
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'png',
                                                          'jpg'
                                                        ],
                                                      );
                                                      if (results != null) {
                                                        //get the file path and filename (photo)
                                                        final path = results
                                                            .files.single.path;
                                                        final fileName = results
                                                            .files.single.name;
                                                        //store in firebase storage
                                                        String curuseremail =
                                                            thisStudent.email;
                                                        context
                                                                .read<
                                                                    UploadImageProvider>()
                                                                .changeStorageFilePath =
                                                            File(path!);
                                                        await context
                                                            .read<
                                                                UploadImageProvider>()
                                                            .uploadFileFromProfile(
                                                                path,
                                                                curuseremail)
                                                            .then((value) =>
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Image successfully updated'),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                  ),
                                                                ));
                                                        //create activity
                                                        await context
                                                            .read<
                                                                ActivityProvider2>()
                                                            .createActivity(
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              [],
                                                              'You updated your profile photo',
                                                              _myEmail,
                                                              '',
                                                            );
                                                        //get photourl from FBstorage after uploading it
                                                        final photoUrl = await context
                                                            .read<
                                                                UploadImageProvider>()
                                                            .getDownloadURLFromProfile(
                                                                curuseremail);
                                                        await context
                                                            .read<
                                                                UploadImageProvider>()
                                                            .setPhotoUrlFromProfile(
                                                                thisStudent
                                                                    .studentNumber,
                                                                photoUrl);
                                                        //store photo to local
                                                        await context
                                                            .read<
                                                                LocalDataProvider2>()
                                                            .storeLocalStudentPhoto(
                                                                photoUrl);
                                                      }
                                                    },
                                                    color: Colors.transparent,
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .cameraRetro,
                                                      color: context
                                                              .read<
                                                                  ThemeProvider2>()
                                                              .isDark
                                                          ? Colors.white
                                                          : kPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 9,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            width: size.width / 2,
                                            child: SingleChildScrollView(
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      GFCard(
                                                        content: Text(
                                                            thisStudent.about),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: size.width * .33,
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(20.0))),
                                                                content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    ListBody(
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: const [
                                                                            Icon(
                                                                              Icons.assignment,
                                                                              color: kPrimaryColor,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 12,
                                                                            ),
                                                                            Text('Edit Abouts'),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              21,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: TextFormField(
                                                                                minLines: 2,
                                                                                maxLines: 5,
                                                                                initialValue: thisStudent.about,
                                                                                onChanged: (value) => context.read<OtpProvider2>().changeDescription = value,
                                                                                // controller: firstnameCtrl,
                                                                                decoration: InputDecoration(
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(24.0),
                                                                                    borderSide: BorderSide(
                                                                                      color: context.read<ThemeProvider2>().isDark ? Colors.white : kMiddleColor,
                                                                                      width: 2,
                                                                                    ),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(24.0),
                                                                                    borderSide: BorderSide(
                                                                                      color: context.read<ThemeProvider2>().isDark ? kMiddleColor : kPrimaryColor,
                                                                                      width: 2,
                                                                                    ),
                                                                                  ),
                                                                                  labelStyle: TextStyle(
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                  ),
                                                                                ),
                                                                                cursorColor: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                style: TextStyle(color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          GFButton(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            child:
                                                                                const Text(
                                                                              "Close",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          GFButton(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            child:
                                                                                const Text(
                                                                              "Save",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              await context.read<OtpProvider2>().setAboutFromProfile(thisStudent.studentNumber);
                                                                              //create activity
                                                                              await context.read<ActivityProvider2>().createActivity(
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    [],
                                                                                    'You updated your profile description',
                                                                                    _myEmail,
                                                                                    '',
                                                                                  );
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons.edit,
                                                        color: context
                                                                .read<
                                                                    ThemeProvider2>()
                                                                .isDark
                                                            ? Colors.white
                                                            : kPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    ' \nProfile Details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.blue,
                                  indent: size.width / 6,
                                  endIndent: size.width / 6,
                                ),
                                const Center(
                                  child: Text(
                                    'Name: ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    thisStudent.firstName +
                                        ' ' +
                                        thisStudent.mInitial +
                                        '. ' +
                                        thisStudent.lastName +
                                        '\n',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.blueGrey,
                                  indent: size.width / 4,
                                  endIndent: size.width / 4,
                                ),
                                const Center(
                                  child: Text(
                                    'Email: ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    thisStudent.email + '\n',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.blueGrey,
                                  indent: size.width / 4,
                                  endIndent: size.width / 4,
                                ),
                                const Center(
                                  child: Text(
                                    'Student Number: ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    thisStudent.studentNumber + '\n',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.blueGrey,
                                  indent: size.width / 4,
                                  endIndent: size.width / 4,
                                ),
                                const Center(
                                  child: Text(
                                    'College Department: ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    thisStudent.college + '\n',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : Divider(
                                        thickness: 1,
                                        color: Colors.blueGrey,
                                        indent: size.width / 4,
                                        endIndent: size.width / 4,
                                      ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : const Center(
                                        child: Text(
                                          'Course: ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : const SizedBox(
                                        height: 3,
                                      ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : Center(
                                        child: Text(
                                          thisStudent.course + '\n',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : Divider(
                                        thickness: 1,
                                        color: Colors.blueGrey,
                                        indent: size.width / 4,
                                        endIndent: size.width / 4,
                                      ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : const Center(
                                        child: Text(
                                          'Year & Section: ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : const SizedBox(
                                        height: 3,
                                      ),
                                _myYearLevel > _myCompletionYear
                                    ? Container()
                                    : Center(
                                        child: Text(
                                          thisStudentYearSec + '\n',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.blue,
                                  indent: size.width / 6,
                                  endIndent: size.width / 6,
                                ),
                                StreamBuilder<Request>(
                                  stream: _streamRequest,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isSent == false) {
                                        //get acaddate 'date' only (w/o time)
                                        String acadDateOnly =
                                            DateFormat("yyyy-MM-dd").format(
                                                acadDates.enrollDate.toDate());
                                        //get date now (w/o time)
                                        String dateNowOnly =
                                            DateFormat("yyyy-MM-dd")
                                                .format(DateTime.now());
                                        //get and format next 7 days
                                        DateTime dateTime1,
                                            dateTime2,
                                            dateTime3,
                                            dateTime4,
                                            dateTime5,
                                            dateTime6,
                                            dateTime7;
                                        dateTime1 = DateTime.parse(acadDateOnly)
                                            .add(const Duration(days: 1));
                                        dateTime2 = DateTime.parse(acadDateOnly)
                                            .add(const Duration(days: 2));
                                        dateTime3 = DateTime.parse(acadDateOnly)
                                            .add(const Duration(days: 3));
                                        dateTime4 = DateTime.parse(acadDateOnly)
                                            .add(const Duration(days: 4));
                                        dateTime5 = DateTime.parse(acadDateOnly)
                                            .add(const Duration(days: 5));
                                        dateTime6 = DateTime.parse(acadDateOnly)
                                            .add(const Duration(days: 6));
                                        dateTime7 = DateTime.parse(acadDateOnly)
                                            .add(const Duration(days: 7));

                                        String firstDay =
                                            DateFormat("yyyy-MM-dd")
                                                .format(dateTime1);
                                        String secondDay =
                                            DateFormat("yyyy-MM-dd")
                                                .format(dateTime2);
                                        String thirdDay =
                                            DateFormat("yyyy-MM-dd")
                                                .format(dateTime3);
                                        String fourthDay =
                                            DateFormat("yyyy-MM-dd")
                                                .format(dateTime4);
                                        String fifthDay =
                                            DateFormat("yyyy-MM-dd")
                                                .format(dateTime5);
                                        String sixthDay =
                                            DateFormat("yyyy-MM-dd")
                                                .format(dateTime6);
                                        String seventhDay =
                                            DateFormat("yyyy-MM-dd")
                                                .format(dateTime7);

                                        // return Text('has data');
                                        return acadDateOnly == dateNowOnly
                                            ? GFButton(
                                                onPressed: () {
                                                  //send request to admin for validation
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20.0))),
                                                          title: Text(
                                                            '\nChange details to be updated',
                                                            style: TextStyle(
                                                              color: context
                                                                      .read<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? kMiddleColor
                                                                  : kPrimaryColor,
                                                            ),
                                                          ),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      21.0),
                                                              child: ListBody(
                                                                children: <
                                                                    Widget>[
                                                                  const SizedBox(),
                                                                  Text(
                                                                    'First Name',
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? kMiddleColor
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  TextFormField(
                                                                    initialValue:
                                                                        thisStudent
                                                                            .firstName,
                                                                    onChanged: (value) =>
                                                                        requestProvider2.changeReqFname =
                                                                            value,
                                                                    // controller: firstnameCtrl,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kMiddleColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? kMiddleColor
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                      ),
                                                                    ),
                                                                    cursorColor: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : kPrimaryColor,
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 18,
                                                                  ),
                                                                  Text(
                                                                    'Middle Initial',
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? kMiddleColor
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  TextFormField(
                                                                    initialValue:
                                                                        thisStudent
                                                                            .mInitial,
                                                                    onChanged: (value) =>
                                                                        requestProvider2.changeReqMinitial =
                                                                            value,
                                                                    // controller: minitialCtrl,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kMiddleColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? kMiddleColor
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                      ),
                                                                    ),
                                                                    cursorColor: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : kPrimaryColor,
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 18,
                                                                  ),
                                                                  Text(
                                                                    'Last Name',
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? kMiddleColor
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  TextFormField(
                                                                    initialValue:
                                                                        thisStudent
                                                                            .lastName,
                                                                    onChanged: (value) =>
                                                                        requestProvider2.changeReqLname =
                                                                            value,
                                                                    // controller: lastnameCtrl,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kMiddleColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? kMiddleColor
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                      ),
                                                                    ),
                                                                    cursorColor: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : kPrimaryColor,
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 18,
                                                                  ),
                                                                  Text(
                                                                    'Section',
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  TextFormField(
                                                                    initialValue:
                                                                        thisStudent
                                                                            .section
                                                                            .toString(),
                                                                    onChanged: (value) => requestProvider2
                                                                            .changeReqSec =
                                                                        int.parse(
                                                                            value),
                                                                    // controller: yearsecCtrl,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kMiddleColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? kMiddleColor
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                      ),
                                                                    ),
                                                                    cursorColor: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : kPrimaryColor,
                                                                    style: TextStyle(
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 18,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            GFButton(
                                                              onPressed: () {
                                                                if ((requestProvider2.reqCollege != '' && requestProvider2.reqCourse != '') &&
                                                                    (requestProvider2.reqFname !=
                                                                            '' &&
                                                                        requestProvider2.reqMinitial !=
                                                                            '') &&
                                                                    (requestProvider2.reqLname !=
                                                                            '' &&
                                                                        requestProvider2.reqSec !=
                                                                            '')) {
                                                                  if ((requestProvider2.reqCollege == thisStudent.college && requestProvider2.reqCourse == thisStudent.course) &&
                                                                      (requestProvider2.reqFname ==
                                                                              thisStudent
                                                                                  .firstName &&
                                                                          requestProvider2.reqMinitial ==
                                                                              thisStudent
                                                                                  .mInitial) &&
                                                                      (requestProvider2.reqLname ==
                                                                              thisStudent
                                                                                  .lastName &&
                                                                          requestProvider2.reqSec ==
                                                                              thisStudent.section)) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            shape:
                                                                                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                            content:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: ListBody(
                                                                                      children: <Widget>[
                                                                                        Row(
                                                                                          children: const [
                                                                                            Icon(
                                                                                              Icons.warning_rounded,
                                                                                              color: kPrimaryColor,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 12,
                                                                                            ),
                                                                                            Text('No updates found'),
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 21,
                                                                                        ),
                                                                                        Row(
                                                                                          children: const [
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                'No updates recognized. Unable to send update',
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: RaisedButton(
                                                                                            color: kPrimaryColor,
                                                                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                            child: const Text(
                                                                                              "Close",
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        });
                                                                  } else {
                                                                    (() async {
                                                                      showDialog(
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        },
                                                                      );
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 1000),
                                                                          () {
                                                                        requestProvider2
                                                                            .saveRequest();
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Update request sent!'),
                                                                          duration:
                                                                              Duration(milliseconds: 1000),
                                                                        ));
                                                                      });
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 1300),
                                                                          () {
                                                                        print(
                                                                            2);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 1350),
                                                                          () {
                                                                        requestProvider2.changeReqCollege =
                                                                            thisStudent.college;
                                                                        requestProvider2.changeReqFname =
                                                                            thisStudent.firstName;
                                                                        requestProvider2.changeReqMinitial =
                                                                            thisStudent.mInitial;
                                                                        requestProvider2.changeReqLname =
                                                                            thisStudent.lastName;
                                                                        requestProvider2.changeReqCourse =
                                                                            thisStudent.course;
                                                                        requestProvider2.changeReqSec =
                                                                            thisStudent.section;
                                                                        print(
                                                                            1);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    }());

                                                                    // requestProvider2
                                                                    //     .saveRequest();
                                                                  }
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          shape:
                                                                              const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                          content:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: ListBody(
                                                                                    children: <Widget>[
                                                                                      Row(
                                                                                        children: const [
                                                                                          Icon(
                                                                                            Icons.warning_rounded,
                                                                                            color: kPrimaryColor,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 12,
                                                                                          ),
                                                                                          Text('Empty Details'),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 21,
                                                                                      ),
                                                                                      Row(
                                                                                        children: const [
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                              'Please don\'t send empty details. Provide necessary fields.',
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: RaisedButton(
                                                                                          color: kPrimaryColor,
                                                                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                          child: const Text(
                                                                                            "Close",
                                                                                            style: TextStyle(
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                }
                                                              },
                                                              child: const Text(
                                                                'Send Request',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            GFButton(
                                                              onPressed: () {
                                                                requestProvider2
                                                                        .changeReqCollege =
                                                                    thisStudent
                                                                        .college;
                                                                requestProvider2
                                                                        .changeReqFname =
                                                                    thisStudent
                                                                        .firstName;
                                                                requestProvider2
                                                                        .changeReqMinitial =
                                                                    thisStudent
                                                                        .mInitial;
                                                                requestProvider2
                                                                        .changeReqLname =
                                                                    thisStudent
                                                                        .lastName;
                                                                requestProvider2
                                                                        .changeReqCourse =
                                                                    thisStudent
                                                                        .course;
                                                                requestProvider2
                                                                        .changeReqSec =
                                                                    thisStudent
                                                                        .section;
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              color: context
                                                                      .read<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? kPrimaryColor
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : kPrimaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                              child: const Text(
                                                                'Cancel',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                color: kPrimaryColor,
                                                text: 'Request Profile Update',
                                              )
                                            : firstDay == dateNowOnly ||
                                                    secondDay == dateNowOnly ||
                                                    thirdDay == dateNowOnly ||
                                                    fourthDay == dateNowOnly ||
                                                    fifthDay == dateNowOnly ||
                                                    sixthDay == dateNowOnly ||
                                                    seventhDay == dateNowOnly
                                                ? GFButton(
                                                    onPressed: () {
                                                      //send request to admin for validation
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20.0))),
                                                              title: Text(
                                                                '\nChange details to be updated',
                                                                style:
                                                                    TextStyle(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? kMiddleColor
                                                                      : kPrimaryColor,
                                                                ),
                                                              ),
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          21.0),
                                                                  child:
                                                                      ListBody(
                                                                    children: <
                                                                        Widget>[
                                                                      const SizedBox(),
                                                                      Text(
                                                                        'First Name',
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? kMiddleColor
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      TextFormField(
                                                                        initialValue:
                                                                            thisStudent.firstName,
                                                                        onChanged:
                                                                            (value) =>
                                                                                requestProvider2.changeReqFname = value,
                                                                        // controller: firstnameCtrl,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kMiddleColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? kMiddleColor : kPrimaryColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          labelStyle:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor,
                                                                          ),
                                                                        ),
                                                                        cursorColor: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            18,
                                                                      ),
                                                                      Text(
                                                                        'Middle Initial',
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? kMiddleColor
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      TextFormField(
                                                                        initialValue:
                                                                            thisStudent.mInitial,
                                                                        onChanged:
                                                                            (value) =>
                                                                                requestProvider2.changeReqMinitial = value,
                                                                        // controller: minitialCtrl,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kMiddleColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? kMiddleColor : kPrimaryColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          labelStyle:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor,
                                                                          ),
                                                                        ),
                                                                        cursorColor: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            18,
                                                                      ),
                                                                      Text(
                                                                        'Last Name',
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? kMiddleColor
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      TextFormField(
                                                                        initialValue:
                                                                            thisStudent.lastName,
                                                                        onChanged:
                                                                            (value) =>
                                                                                requestProvider2.changeReqLname = value,
                                                                        // controller: lastnameCtrl,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kMiddleColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? kMiddleColor : kPrimaryColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          labelStyle:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor,
                                                                          ),
                                                                        ),
                                                                        cursorColor: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            18,
                                                                      ),
                                                                      Text(
                                                                        'Section',
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      TextFormField(
                                                                        initialValue: thisStudent
                                                                            .section
                                                                            .toString(),
                                                                        onChanged:
                                                                            (value) =>
                                                                                requestProvider2.changeReqSec = int.parse(value),
                                                                        // controller: yearsecCtrl,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kMiddleColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: context.read<ThemeProvider2>().isDark ? kMiddleColor : kPrimaryColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          labelStyle:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor,
                                                                          ),
                                                                        ),
                                                                        cursorColor: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                        style: TextStyle(
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            18,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                GFButton(
                                                                  onPressed:
                                                                      () {
                                                                    if ((requestProvider2.reqCollege != '' && requestProvider2.reqCourse != '') &&
                                                                        (requestProvider2.reqFname !=
                                                                                '' &&
                                                                            requestProvider2.reqMinitial !=
                                                                                '') &&
                                                                        (requestProvider2.reqLname !=
                                                                                '' &&
                                                                            requestProvider2.reqSec !=
                                                                                '')) {
                                                                      if ((requestProvider2.reqCollege == thisStudent.college && requestProvider2.reqCourse == thisStudent.course) &&
                                                                          (requestProvider2.reqFname == thisStudent.firstName &&
                                                                              requestProvider2.reqMinitial == thisStudent.mInitial) &&
                                                                          (requestProvider2.reqLname == thisStudent.lastName && requestProvider2.reqSec == thisStudent.section)) {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                false,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                content: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: ListBody(
                                                                                          children: <Widget>[
                                                                                            Row(
                                                                                              children: const [
                                                                                                Icon(
                                                                                                  Icons.warning_rounded,
                                                                                                  color: kPrimaryColor,
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 12,
                                                                                                ),
                                                                                                Text('No updates found'),
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 21,
                                                                                            ),
                                                                                            Row(
                                                                                              children: const [
                                                                                                Expanded(
                                                                                                  child: Text(
                                                                                                    'No updates recognized. Unable to send update',
                                                                                                    textAlign: TextAlign.center,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: <Widget>[
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: RaisedButton(
                                                                                                color: kPrimaryColor,
                                                                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                                child: const Text(
                                                                                                  "Close",
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      } else {
                                                                        (() async {
                                                                          showDialog(
                                                                            barrierDismissible:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return const Center(
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                            },
                                                                          );
                                                                          Future.delayed(
                                                                              const Duration(milliseconds: 1000),
                                                                              () {
                                                                            requestProvider2.saveRequest();
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                              content: Text('Update request sent!'),
                                                                              duration: Duration(milliseconds: 1000),
                                                                            ));
                                                                          });
                                                                          Future.delayed(
                                                                              const Duration(milliseconds: 1300),
                                                                              () {
                                                                            print(2);
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                          Future.delayed(
                                                                              const Duration(milliseconds: 1350),
                                                                              () {
                                                                            requestProvider2.changeReqCollege =
                                                                                thisStudent.college;
                                                                            requestProvider2.changeReqFname =
                                                                                thisStudent.firstName;
                                                                            requestProvider2.changeReqMinitial =
                                                                                thisStudent.mInitial;
                                                                            requestProvider2.changeReqLname =
                                                                                thisStudent.lastName;
                                                                            requestProvider2.changeReqCourse =
                                                                                thisStudent.course;
                                                                            requestProvider2.changeReqSec =
                                                                                thisStudent.section;
                                                                            print(1);
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                        }());

                                                                        // requestProvider2
                                                                        //     .saveRequest();

                                                                      }
                                                                    } else {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              false,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                              content: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: <Widget>[
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: ListBody(
                                                                                        children: <Widget>[
                                                                                          Row(
                                                                                            children: const [
                                                                                              Icon(
                                                                                                Icons.warning_rounded,
                                                                                                color: kPrimaryColor,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 12,
                                                                                              ),
                                                                                              Text('Empty Details'),
                                                                                            ],
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 21,
                                                                                          ),
                                                                                          Row(
                                                                                            children: const [
                                                                                              Expanded(
                                                                                                child: Text(
                                                                                                  'Please don\'t send empty details. Provide necessary fields.',
                                                                                                  textAlign: TextAlign.center,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: <Widget>[
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: RaisedButton(
                                                                                              color: kPrimaryColor,
                                                                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                              child: const Text(
                                                                                                "Close",
                                                                                                style: TextStyle(
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Send Request',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                GFButton(
                                                                  onPressed:
                                                                      () {
                                                                    requestProvider2
                                                                            .changeReqCollege =
                                                                        thisStudent
                                                                            .college;
                                                                    requestProvider2
                                                                            .changeReqFname =
                                                                        thisStudent
                                                                            .firstName;
                                                                    requestProvider2
                                                                            .changeReqMinitial =
                                                                        thisStudent
                                                                            .mInitial;
                                                                    requestProvider2
                                                                            .changeReqLname =
                                                                        thisStudent
                                                                            .lastName;
                                                                    requestProvider2
                                                                            .changeReqCourse =
                                                                        thisStudent
                                                                            .course;
                                                                    requestProvider2
                                                                            .changeReqSec =
                                                                        thisStudent
                                                                            .section;
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? kPrimaryColor
                                                                          .withOpacity(
                                                                              0.5)
                                                                      : kPrimaryColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    color: kPrimaryColor,
                                                    text:
                                                        'Request Profile Update',
                                                  )
                                                : Container();
                                      } else {
                                        return GFButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .warning_rounded,
                                                                      color:
                                                                          kPrimaryColor,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 12,
                                                                    ),
                                                                    Text(
                                                                        'Already Requested'),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 21,
                                                                ),
                                                                Row(
                                                                  children: const [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'You already sent an update request of your details. Wait for the admin approval',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      RaisedButton(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(2.0))),
                                                                    child:
                                                                        const Text(
                                                                      "Close",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          text: 'Request Sent',
                                          color: Colors.grey,
                                        );
                                      }
                                      //
                                    } else {
                                      //No data
                                      //No request record yet
                                      return GFButton(
                                        onPressed: () {
                                          //send request to admin for validation
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                  title: Text(
                                                    '\nChange details to be updated',
                                                    style: TextStyle(
                                                      color: context
                                                              .read<
                                                                  ThemeProvider2>()
                                                              .isDark
                                                          ? kMiddleColor
                                                          : kPrimaryColor,
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              21.0),
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          const SizedBox(),
                                                          Text(
                                                            'First Name',
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? kMiddleColor
                                                                    : kPrimaryColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          TextFormField(
                                                            initialValue:
                                                                thisStudent
                                                                    .firstName,
                                                            onChanged: (value) =>
                                                                requestProvider2
                                                                        .changeReqFname =
                                                                    value,
                                                            // controller: firstnameCtrl,
                                                            decoration:
                                                                InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? Colors
                                                                          .white
                                                                      : kMiddleColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? kMiddleColor
                                                                      : kPrimaryColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor,
                                                              ),
                                                            ),
                                                            cursorColor: context
                                                                    .read<
                                                                        ThemeProvider2>()
                                                                    .isDark
                                                                ? Colors.white
                                                                : kPrimaryColor,
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 18,
                                                          ),
                                                          Text(
                                                            'Middle Initial',
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? kMiddleColor
                                                                    : kPrimaryColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          TextFormField(
                                                            initialValue:
                                                                thisStudent
                                                                    .mInitial,
                                                            onChanged: (value) =>
                                                                requestProvider2
                                                                        .changeReqMinitial =
                                                                    value,
                                                            // controller: minitialCtrl,
                                                            decoration:
                                                                InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? Colors
                                                                          .white
                                                                      : kMiddleColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? kMiddleColor
                                                                      : kPrimaryColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor,
                                                              ),
                                                            ),
                                                            cursorColor: context
                                                                    .read<
                                                                        ThemeProvider2>()
                                                                    .isDark
                                                                ? Colors.white
                                                                : kPrimaryColor,
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 18,
                                                          ),
                                                          Text(
                                                            'Last Name',
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? kMiddleColor
                                                                    : kPrimaryColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          TextFormField(
                                                            initialValue:
                                                                thisStudent
                                                                    .lastName,
                                                            onChanged: (value) =>
                                                                requestProvider2
                                                                        .changeReqLname =
                                                                    value,
                                                            // controller: lastnameCtrl,
                                                            decoration:
                                                                InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? Colors
                                                                          .white
                                                                      : kMiddleColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? kMiddleColor
                                                                      : kPrimaryColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor,
                                                              ),
                                                            ),
                                                            cursorColor: context
                                                                    .read<
                                                                        ThemeProvider2>()
                                                                    .isDark
                                                                ? Colors.white
                                                                : kPrimaryColor,
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 18,
                                                          ),
                                                          Text(
                                                            'Section',
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          TextFormField(
                                                            initialValue:
                                                                thisStudent
                                                                    .section
                                                                    .toString(),
                                                            onChanged: (value) =>
                                                                requestProvider2
                                                                        .changeReqSec =
                                                                    int.parse(
                                                                        value),
                                                            // controller: yearsecCtrl,
                                                            decoration:
                                                                InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? Colors
                                                                          .white
                                                                      : kMiddleColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? kMiddleColor
                                                                      : kPrimaryColor,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor,
                                                              ),
                                                            ),
                                                            cursorColor: context
                                                                    .read<
                                                                        ThemeProvider2>()
                                                                    .isDark
                                                                ? Colors.white
                                                                : kPrimaryColor,
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    GFButton(
                                                      onPressed: () {
                                                        if ((requestProvider2.reqCollege != '' && requestProvider2.reqCourse != '') &&
                                                            (requestProvider2
                                                                        .reqFname !=
                                                                    '' &&
                                                                requestProvider2
                                                                        .reqMinitial !=
                                                                    '') &&
                                                            (requestProvider2
                                                                        .reqLname !=
                                                                    '' &&
                                                                requestProvider2
                                                                        .reqSec !=
                                                                    '')) {
                                                          if ((requestProvider2.reqCollege == thisStudent.college && requestProvider2.reqCourse == thisStudent.course) &&
                                                              (requestProvider2
                                                                          .reqFname ==
                                                                      thisStudent
                                                                          .firstName &&
                                                                  requestProvider2
                                                                          .reqMinitial ==
                                                                      thisStudent
                                                                          .mInitial) &&
                                                              (requestProvider2
                                                                          .reqLname ==
                                                                      thisStudent
                                                                          .lastName &&
                                                                  requestProvider2
                                                                          .reqSec ==
                                                                      thisStudent
                                                                          .section)) {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(20.0))),
                                                                    content:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                ListBody(
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  children: const [
                                                                                    Icon(
                                                                                      Icons.warning_rounded,
                                                                                      color: kPrimaryColor,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 12,
                                                                                    ),
                                                                                    Text('No updates found'),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 21,
                                                                                ),
                                                                                Row(
                                                                                  children: const [
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        'No updates recognized. Unable to send update',
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: RaisedButton(
                                                                                    color: kPrimaryColor,
                                                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                    child: const Text(
                                                                                      "Close",
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          } else {
                                                            (() async {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  );
                                                                },
                                                              );
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          1000),
                                                                  () {
                                                                requestProvider2
                                                                    .saveRequest();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  content: Text(
                                                                      'Update request sent!'),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1000),
                                                                ));
                                                              });
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          1300),
                                                                  () {
                                                                print(2);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          1350),
                                                                  () {
                                                                requestProvider2
                                                                        .changeReqCollege =
                                                                    thisStudent
                                                                        .college;
                                                                requestProvider2
                                                                        .changeReqFname =
                                                                    thisStudent
                                                                        .firstName;
                                                                requestProvider2
                                                                        .changeReqMinitial =
                                                                    thisStudent
                                                                        .mInitial;
                                                                requestProvider2
                                                                        .changeReqLname =
                                                                    thisStudent
                                                                        .lastName;
                                                                requestProvider2
                                                                        .changeReqCourse =
                                                                    thisStudent
                                                                        .course;
                                                                requestProvider2
                                                                        .changeReqSec =
                                                                    thisStudent
                                                                        .section;
                                                                print(1);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                            }());

                                                            // requestProvider2
                                                            //     .saveRequest();

                                                          }
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20.0))),
                                                                  content:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              ListBody(
                                                                            children: <Widget>[
                                                                              Row(
                                                                                children: const [
                                                                                  Icon(
                                                                                    Icons.warning_rounded,
                                                                                    color: kPrimaryColor,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 12,
                                                                                  ),
                                                                                  Text('Empty Details'),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 21,
                                                                              ),
                                                                              Row(
                                                                                children: const [
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      'Please don\'t send empty details. Provide necessary fields.',
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: RaisedButton(
                                                                                  color: kPrimaryColor,
                                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                  child: const Text(
                                                                                    "Close",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Send Request',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    GFButton(
                                                      onPressed: () {
                                                        requestProvider2
                                                                .changeReqCollege =
                                                            thisStudent.college;
                                                        requestProvider2
                                                                .changeReqFname =
                                                            thisStudent
                                                                .firstName;
                                                        requestProvider2
                                                                .changeReqMinitial =
                                                            thisStudent
                                                                .mInitial;
                                                        requestProvider2
                                                                .changeReqLname =
                                                            thisStudent
                                                                .lastName;
                                                        requestProvider2
                                                                .changeReqCourse =
                                                            thisStudent.course;
                                                        requestProvider2
                                                                .changeReqSec =
                                                            thisStudent.section;
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      color: context
                                                              .read<
                                                                  ThemeProvider2>()
                                                              .isDark
                                                          ? kPrimaryColor
                                                              .withOpacity(0.5)
                                                          : kPrimaryColor
                                                              .withOpacity(0.5),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        color: kPrimaryColor,
                                        text: 'Request Profile Update',
                                      );
                                    }
                                  },
                                ),
                                GFButton(
                                  onPressed: () async {
                                    AuthProvider2 authProvider2 =
                                        AuthProvider2();
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0))),
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Row(
                                                          children: const [
                                                            Icon(
                                                              FontAwesomeIcons
                                                                  .lock,
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(
                                                                'Change Password'),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 21,
                                                        ),
                                                        Text(
                                                          'Old Password',
                                                          style: TextStyle(
                                                              color: context
                                                                      .read<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? Colors.white
                                                                  : kPrimaryColor),
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        TextFormField(
                                                          onChanged: (value) =>
                                                              authProvider2
                                                                      .oldPassword =
                                                                  value,
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kMiddleColor,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? kMiddleColor
                                                                    : kPrimaryColor,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            labelStyle:
                                                                TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: context
                                                                      .read<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? Colors.white
                                                                  : kPrimaryColor,
                                                            ),
                                                          ),
                                                          obscureText: true,
                                                          cursorColor: context
                                                                  .read<
                                                                      ThemeProvider2>()
                                                                  .isDark
                                                              ? Colors.white
                                                              : kPrimaryColor,
                                                          style: TextStyle(
                                                              color: context
                                                                      .read<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? Colors.white
                                                                  : kPrimaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: GFButton(
                                                            elevation: 2,
                                                            color:
                                                                kPrimaryColor,
                                                            child: const Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: GFButton(
                                                            elevation: 2,
                                                            color:
                                                                kPrimaryColor,
                                                            child: const Text(
                                                              "Proceed",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (authProvider2
                                                                      .oldPassword !=
                                                                  '') {
                                                                await authProvider2
                                                                    .validateOldPassword();
                                                                authProvider2
                                                                        .oldPassCorrect
                                                                    ? showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Row(
                                                                              children: const [
                                                                                Icon(Icons.lock),
                                                                                Text('Provide new password'),
                                                                              ],
                                                                            ),
                                                                            content:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: ListBody(
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          'New Password',
                                                                                          style: TextStyle(color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 6,
                                                                                        ),
                                                                                        TextFormField(
                                                                                          obscureText: true,
                                                                                          onChanged: (value) => authProvider2.newPassword = value,
                                                                                          decoration: InputDecoration(
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                                              borderSide: BorderSide(
                                                                                                color: context.read<ThemeProvider2>().isDark ? Colors.white : kMiddleColor,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                                              borderSide: BorderSide(
                                                                                                color: context.read<ThemeProvider2>().isDark ? kMiddleColor : kPrimaryColor,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                            labelStyle: TextStyle(
                                                                                              fontWeight: FontWeight.w400,
                                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                            ),
                                                                                          ),
                                                                                          cursorColor: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                          style: TextStyle(color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor),
                                                                                        ),
                                                                                        Text(
                                                                                          'Re-type New Password',
                                                                                          style: TextStyle(color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 6,
                                                                                        ),
                                                                                        TextFormField(
                                                                                          obscureText: true,
                                                                                          onChanged: (value) => authProvider2.reNewPass = value,
                                                                                          decoration: InputDecoration(
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                                              borderSide: BorderSide(
                                                                                                color: context.read<ThemeProvider2>().isDark ? Colors.white : kMiddleColor,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                                              borderSide: BorderSide(
                                                                                                color: context.read<ThemeProvider2>().isDark ? kMiddleColor : kPrimaryColor,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                            labelStyle: TextStyle(
                                                                                              fontWeight: FontWeight.w400,
                                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                            ),
                                                                                          ),
                                                                                          cursorColor: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                          style: TextStyle(color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      GFButton(
                                                                                        color: kPrimaryColor,
                                                                                        child: const Text(
                                                                                          "Back",
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 12,
                                                                                      ),
                                                                                      GFButton(
                                                                                        color: kPrimaryColor,
                                                                                        child: const Text(
                                                                                          "Confirm",
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                        onPressed: () async {
                                                                                          if (authProvider2.newPassword != '' && authProvider2.reNewPass != '') {
                                                                                            if (authProvider2.newPassword == authProvider2.reNewPass) {
                                                                                              if (authProvider2.reNewPass.length < 9) {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  barrierDismissible: false,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return AlertDialog(
                                                                                                      title: Row(
                                                                                                        children: [
                                                                                                          Icon(
                                                                                                            Icons.error,
                                                                                                            color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            width: 6,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            'Password Too Short',
                                                                                                            style: TextStyle(
                                                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      content: SingleChildScrollView(
                                                                                                        child: ListBody(
                                                                                                          children: const <Widget>[
                                                                                                            Text('Password is too short. Password must be at least 9 characters.'),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      actions: <Widget>[
                                                                                                        TextButton(
                                                                                                          child: const Text('Okay'),
                                                                                                          onPressed: () {
                                                                                                            context.read<OtpProvider2>().changeRepass = '';
                                                                                                            Navigator.of(context).pop();
                                                                                                          },
                                                                                                        ),
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              } else {
                                                                                                RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                                                                                if (regex.hasMatch(authProvider2.reNewPass)) {
                                                                                                  print('strong password');
                                                                                                  showDialog(
                                                                                                    barrierDismissible: false,
                                                                                                    context: context,
                                                                                                    builder: (context) {
                                                                                                      return const Center(
                                                                                                        child: CircularProgressIndicator(),
                                                                                                      );
                                                                                                    },
                                                                                                  );
                                                                                                  await Future.delayed(const Duration(milliseconds: 1000), () async {
                                                                                                    await authProvider2.changePassword();
                                                                                                    //create activity
                                                                                                    await context.read<ActivityProvider2>().createActivity(
                                                                                                          '',
                                                                                                          '',
                                                                                                          '',
                                                                                                          '',
                                                                                                          '',
                                                                                                          '',
                                                                                                          '',
                                                                                                          '',
                                                                                                          [],
                                                                                                          'You updated your password',
                                                                                                          _myEmail,
                                                                                                          '',
                                                                                                        );
                                                                                                  });

                                                                                                  Future.delayed(const Duration(milliseconds: 2000), () {
                                                                                                    Navigator.pushReplacementNamed(context, Routes2.startpage2);
                                                                                                  });
                                                                                                } else {
                                                                                                  showDialog(
                                                                                                    context: context,
                                                                                                    barrierDismissible: false,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return AlertDialog(
                                                                                                        title: Row(
                                                                                                          children: [
                                                                                                            Icon(
                                                                                                              Icons.error,
                                                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                            ),
                                                                                                            const SizedBox(
                                                                                                              width: 6,
                                                                                                            ),
                                                                                                            Text(
                                                                                                              'Weak Password',
                                                                                                              style: TextStyle(
                                                                                                                color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        content: SingleChildScrollView(
                                                                                                          child: ListBody(
                                                                                                            children: const <Widget>[
                                                                                                              Text('Your password must include: \n\t• Minimum 1 Upper case \n\t• Minimum 1 lowercase\n\t• Minimum 1 Numeric Number\n\t• Minimum 1 Special Character\n• Common Allow Character ( ! @ # \$ & * ~ )'),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        actions: <Widget>[
                                                                                                          TextButton(
                                                                                                            child: const Text('Okay'),
                                                                                                            onPressed: () {
                                                                                                              authProvider2.reNewPass = '';
                                                                                                              Navigator.of(context).pop();
                                                                                                            },
                                                                                                          ),
                                                                                                        ],
                                                                                                      );
                                                                                                    },
                                                                                                  );
                                                                                                }
                                                                                              }
                                                                                            } else {
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                barrierDismissible: false,
                                                                                                builder: (BuildContext context) {
                                                                                                  return AlertDialog(
                                                                                                    title: Row(
                                                                                                      children: [
                                                                                                        Icon(
                                                                                                          Icons.error,
                                                                                                          color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                        ),
                                                                                                        const SizedBox(
                                                                                                          width: 6,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          'Error',
                                                                                                          style: TextStyle(
                                                                                                            color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    content: SingleChildScrollView(
                                                                                                      child: ListBody(
                                                                                                        children: const <Widget>[
                                                                                                          Text('Passwords need to match'),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    actions: <Widget>[
                                                                                                      TextButton(
                                                                                                        child: const Text('Okay'),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            }
                                                                                          } else {
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              barrierDismissible: false,
                                                                                              builder: (BuildContext context) {
                                                                                                return AlertDialog(
                                                                                                  title: Row(
                                                                                                    children: [
                                                                                                      Icon(
                                                                                                        Icons.error,
                                                                                                        color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                      ),
                                                                                                      const SizedBox(
                                                                                                        width: 6,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        'Empty Fields',
                                                                                                        style: TextStyle(
                                                                                                          color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  content: SingleChildScrollView(
                                                                                                    child: ListBody(
                                                                                                      children: const <Widget>[
                                                                                                        Text('Please provide necessary fields'),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  actions: <Widget>[
                                                                                                    TextButton(
                                                                                                      child: const Text('Okay'),
                                                                                                      onPressed: () {
                                                                                                        context.read<OtpProvider2>().changePassword = '';
                                                                                                        context.read<OtpProvider2>().changeRepass = '';
                                                                                                        Navigator.of(context).pop();
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          }
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        })
                                                                    : showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.error,
                                                                                  color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 6,
                                                                                ),
                                                                                Text(
                                                                                  'Error',
                                                                                  style: TextStyle(
                                                                                    color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            content:
                                                                                SingleChildScrollView(
                                                                              child: ListBody(
                                                                                children: const <Widget>[
                                                                                  Text('Does not match your own password.'),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: const Text('Close'),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.error,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                6,
                                                                          ),
                                                                          Text(
                                                                            'Error',
                                                                            style:
                                                                                TextStyle(
                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            ListBody(
                                                                          children: const <
                                                                              Widget>[
                                                                            Text('Please provide your old password.'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          child:
                                                                              const Text('Close'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  color: kPrimaryColor,
                                  text: 'Change password',
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
      // ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    context.read<AdvDrawerController>().advDrawerController.showDrawer();
  }
}
