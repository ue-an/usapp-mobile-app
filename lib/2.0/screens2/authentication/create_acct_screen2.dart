import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/models/course.dart';
import 'package:usapp_mobile/2.0/models/push_notification.dart';
import 'package:usapp_mobile/2.0/providers2/firstread_provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/otp_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';

class CreateAcctScreen2 extends StatefulWidget {
  const CreateAcctScreen2({Key? key}) : super(key: key);

  @override
  _CreateAcctScreen2State createState() => _CreateAcctScreen2State();
}

class _CreateAcctScreen2State extends State<CreateAcctScreen2>
    with AutomaticKeepAliveClientMixin<CreateAcctScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  FirestoreService2 firestoreService2 = FirestoreService2();
  // late String _myEmail = '';
  late final FirebaseMessaging _firebaseMessaging;
  int _increment = 0;
  late Stream<List<Course>> _streamCourse;

  initFBMessaging() async {
    await Firebase.initializeApp();
    setState(() {
      _firebaseMessaging = FirebaseMessaging.instance;
    });
  }

  @override
  void initState() {
    _streamCourse = firestoreService2.getCourses();
    initFBMessaging();
    setState(() {
      _isVisited = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<List<Course>>(
          stream: _streamCourse,
          builder: (context, courseSnap) {
            if (courseSnap.hasData) {
              late int myCourseCompletionYear;
              courseSnap.data!.forEach((course) async {
                if (course.courseName ==
                    await context.read<LocalDataProvider2>().getLocalCourse()) {
                  myCourseCompletionYear = course.years;
                  print('my completion year: ' + course.years.toString());
                }
              });
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: ListView(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/UsAppLogoWelcome.png',
                        height: 120,
                        // width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            context
                                        .watch<UploadImageProvider>()
                                        .pickedImageUrl ==
                                    ''
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(60)),
                                    child: Image.asset(
                                      'assets/images/user-no-image.png',
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(60)),
                                    child: Image.network(
                                      context
                                          .read<UploadImageProvider>()
                                          .pickedImageUrl!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 90,
                                left: 60,
                              ),
                              child: GFButton(
                                onPressed: () async {
                                  final results =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type: FileType.custom,
                                    allowedExtensions: ['png', 'jpg'],
                                  );

                                  if (results != null) {
                                    //get the file path and filename (photo)
                                    final path = results.files.single.path;
                                    final fileName = results.files.single.name;
                                    //store in firebase storage
                                    String curuseremail =
                                        context.read<OtpProvider2>().email;
                                    context
                                        .read<UploadImageProvider>()
                                        .changeStorageFilePath = File(path!);
                                    await context
                                        .read<UploadImageProvider>()
                                        .uploadFileFirstTime(path, curuseremail)
                                        .then((value) =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Image successfully updated'),
                                                duration: Duration(
                                                    milliseconds: 1000),
                                              ),
                                            ));
                                    //get photourl from FBstorage after uploading it
                                    final photoUrl = await context
                                        .read<UploadImageProvider>()
                                        .getDownloadURL(curuseremail);
                                    await context
                                        .read<OtpProvider2>()
                                        .setPhotoUrlFirstTime(photoUrl);
                                    //store photo to local
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalStudentPhoto(photoUrl);
                                  } else {
                                    List<String> listOfImage = [
                                      // 'assets/images/avatar.png',
                                      // 'assets/images/background.png',
                                      // 'assets/images/glap.png',
                                      // 'assets/images/loader.png',
                                      // 'assets/images/logo-dark.png',
                                      'assets/images/user-no-image.png',
                                    ];
                                    listOfImage.forEach(
                                      (img) async {
                                        String imageName = img
                                            .substring(img.lastIndexOf("/"),
                                                img.lastIndexOf("."))
                                            .replaceAll("/", "");
                                        String path = img.substring(
                                            img.indexOf("/") + 1,
                                            img.lastIndexOf("/"));
                                        final Directory systemTempDir =
                                            Directory.systemTemp;
                                        final byteData =
                                            await rootBundle.load(img);
                                        final file = File(
                                            '${systemTempDir.path}/$imageName.png');
                                        await file.writeAsBytes(byteData.buffer
                                            .asUint8List(byteData.offsetInBytes,
                                                byteData.lengthInBytes));
                                        //
                                        String curuseremail =
                                            context.read<OtpProvider2>().email;
                                        context
                                            .read<UploadImageProvider>()
                                            .changeStorageFilePath = file;

                                        await context
                                            .read<UploadImageProvider>()
                                            .uploadFileFirstTime(
                                                '${systemTempDir.path}/$imageName.png',
                                                curuseremail)
                                            .then((value) => print('Done'));
                                        //get photourl from FBstorage after uploading it
                                        final photoUrl = await context
                                            .read<UploadImageProvider>()
                                            .getDownloadURL(curuseremail);
                                        context
                                            .read<UploadImageProvider>()
                                            .changePickedImageUrl = photoUrl;
                                        await context
                                            .read<OtpProvider2>()
                                            .setPhotoUrlFirstTime(photoUrl);
                                        //store photo to local
                                        await context
                                            .read<LocalDataProvider2>()
                                            .storeLocalStudentPhoto(photoUrl);

                                        // //store local course completion years
                                        // await context
                                        //     .read<LocalDataProvider2>()
                                        //     .storeCourseCompletionYear(
                                        //         myCourseCompletionYear);
                                        // //store local update status
                                        // await context
                                        //     .read<LocalDataProvider2>()
                                        //     .storeUpdatedStatus(false);
                                      },
                                    );

                                    print('has image');
                                    //-----------------
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No image selected'),
                                        duration: Duration(milliseconds: 900),
                                      ),
                                    );
                                  }
                                },
                                color: Colors.transparent,
                                child: const Icon(
                                  FontAwesomeIcons.cameraRetro,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextFormField(
                      onChanged: (value) => context
                          .read<OtpProvider2>()
                          .changeDescription = value,
                      minLines: 2,
                      maxLines: 5,
                      maxLength: 300,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: const BorderSide(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: const BorderSide(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        labelText: 'About',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.assignment,
                          color: kPrimaryColor,
                        ),
                      ),
                      cursorColor: kPrimaryColor,
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: true,
                      onChanged: (value) =>
                          context.read<OtpProvider2>().changePassword = value,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: const BorderSide(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: const BorderSide(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        labelText: 'Password*',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          color: kPrimaryColor,
                        ),
                      ),
                      cursorColor: kPrimaryColor,
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: true,
                      onChanged: (value) =>
                          context.read<OtpProvider2>().changeRepass = value,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: const BorderSide(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: const BorderSide(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        labelText: 'Re-type Password*',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          color: kPrimaryColor,
                        ),
                      ),
                      cursorColor: kPrimaryColor,
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                        "*You can still change your photo and edit 'About' details in your profile."),
                    const SizedBox(
                      height: 12,
                    ),
                    GFButton(
                      onPressed: () async {
                        if (context.read<OtpProvider2>().password != '' &&
                            context.read<OtpProvider2>().repass != '') {
                          if (context.read<OtpProvider2>().password ==
                              context.read<OtpProvider2>().repass) {
                            print('matched');
                            if (context.read<OtpProvider2>().repass.length <
                                9) {
                              print('password too short');
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: context
                                                  .read<ThemeProvider2>()
                                                  .isDark
                                              ? Colors.white
                                              : kPrimaryColor,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          'Password Too Short',
                                          style: TextStyle(
                                            color: context
                                                    .read<ThemeProvider2>()
                                                    .isDark
                                                ? Colors.white
                                                : kPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text(
                                              'Password is too short. Password must be at least 9 characters.'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          context
                                              .read<OtpProvider2>()
                                              .changeRepass = '';
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (regex.hasMatch(
                                  context.read<OtpProvider2>().repass)) {
                                print('strong password');
                                //---------------------------------------------------------
                                if (context
                                        .read<UploadImageProvider>()
                                        .pickedImageUrl ==
                                    '') {
                                  List<String> listOfImage = [
                                    // 'assets/images/avatar.png',
                                    // 'assets/images/background.png',
                                    // 'assets/images/glap.png',
                                    // 'assets/images/loader.png',
                                    // 'assets/images/logo-dark.png',
                                    'assets/images/user-no-image.png',
                                  ];
                                  listOfImage.forEach(
                                    (img) async {
                                      String imageName = img
                                          .substring(img.lastIndexOf("/"),
                                              img.lastIndexOf("."))
                                          .replaceAll("/", "");
                                      String path = img.substring(
                                          img.indexOf("/") + 1,
                                          img.lastIndexOf("/"));
                                      final Directory systemTempDir =
                                          Directory.systemTemp;
                                      final byteData =
                                          await rootBundle.load(img);
                                      final file = File(
                                          '${systemTempDir.path}/$imageName.png');
                                      await file.writeAsBytes(byteData.buffer
                                          .asUint8List(byteData.offsetInBytes,
                                              byteData.lengthInBytes));
                                      //
                                      String curuseremail =
                                          context.read<OtpProvider2>().email;
                                      context
                                          .read<UploadImageProvider>()
                                          .changeStorageFilePath = file;
                                      await context
                                          .read<UploadImageProvider>()
                                          .uploadFileFirstTime(
                                              '${systemTempDir.path}/$imageName.png',
                                              curuseremail)
                                          .then((value) => print('Done'));
                                      //get photourl from FBstorage after uploading it
                                      final photoUrl = await context
                                          .read<UploadImageProvider>()
                                          .getDownloadURL(curuseremail);
                                      context
                                          .read<UploadImageProvider>()
                                          .changePickedImageUrl = photoUrl;
                                      await context
                                          .read<OtpProvider2>()
                                          .setPhotoUrlFirstTime(photoUrl);
                                      //store photo to local
                                      await context
                                          .read<LocalDataProvider2>()
                                          .storeLocalStudentPhoto(photoUrl);
                                      //store local course completion years
                                      await context
                                          .read<LocalDataProvider2>()
                                          .storeCourseCompletionYear(
                                              myCourseCompletionYear);
                                      //store local update status
                                      await context
                                          .read<LocalDataProvider2>()
                                          .storeUpdatedStatus(false);
                                      //==================
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      await context
                                          .read<OtpProvider2>()
                                          .setAboutFirstTime();
                                      await context
                                          .read<OtpProvider2>()
                                          .saveAccount();
                                      if (context
                                              .read<OtpProvider2>()
                                              .acctSaved ==
                                          true) {
                                        await context
                                            .read<OtpProvider2>()
                                            .useStudentNumber();
                                        await context
                                            .read<OtpProvider2>()
                                            .accountToCollection();
                                        //get device token
                                        await _firebaseMessaging
                                            .getToken()
                                            .then((val) async {
                                          FirestoreService2 firestoreService2 =
                                              FirestoreService2();
                                          print('Token: ' + val!);
                                          //local save token
                                          await context
                                              .read<LocalDataProvider2>()
                                              .storeDeviceToken(val);
                                          //token to firebase
                                          await firestoreService2
                                              .updateDeviceToken(
                                                  studnum: context
                                                      .read<
                                                          StudentNumberProvider2>()
                                                      .studentNumber,
                                                  deviceToken: val);

                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 3000), () {
                                            Navigator.maybePop(context);
                                          });
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 3500), () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    Routes2.splashscreen2);
                                          });
                                          // }
                                        });
                                      }
                                    },
                                  );
                                  context
                                      .read<FirstReadProvider>()
                                      .firstStudent
                                      .college;
                                  (() async {
                                    String? s = await context
                                        .read<LocalDataProvider2>()
                                        .getLocalCollege();
                                    print(s);
                                    print('from first provider: ' +
                                        context
                                            .read<FirstReadProvider>()
                                            .firstStudent
                                            .college);
                                  }());
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  await context
                                      .read<OtpProvider2>()
                                      .setAboutFirstTime();
                                  await context
                                      .read<OtpProvider2>()
                                      .saveAccount();
                                  if (context.read<OtpProvider2>().acctSaved ==
                                      true) {
                                    await context
                                        .read<OtpProvider2>()
                                        .useStudentNumber();
                                    await context
                                        .read<OtpProvider2>()
                                        .accountToCollection();
                                    //get device token
                                    await _firebaseMessaging
                                        .getToken()
                                        .then((val) async {
                                      FirestoreService2 firestoreService2 =
                                          FirestoreService2();
                                      print('Token: ' + val!);
                                      //local save token
                                      await context
                                          .read<LocalDataProvider2>()
                                          .storeDeviceToken(val);
                                      //token to firebase
                                      await firestoreService2.updateDeviceToken(
                                          studnum: context
                                              .read<StudentNumberProvider2>()
                                              .studentNumber,
                                          deviceToken: val);
                                      //store local course completion years
                                      await context
                                          .read<LocalDataProvider2>()
                                          .storeCourseCompletionYear(
                                              myCourseCompletionYear);
                                      //store local update status
                                      await context
                                          .read<LocalDataProvider2>()
                                          .storeUpdatedStatus(false);
                                      // //first set notifcount collection to firebase
                                      // await context
                                      //     .read<NotificationProvider>()
                                      //     .setFirstNotifCount(context
                                      //         .read<StudentNumberProvider2>()
                                      //         .studentEmail);
                                      // if (await firestoreService2.updateDeviceToken(
                                      //         studnum: context
                                      //             .read<StudentNumberProvider2>()
                                      //             .studentNumber,
                                      //         deviceToken: val) ==
                                      //     true) {
                                      Future.delayed(
                                          const Duration(milliseconds: 3000),
                                          () {
                                        Navigator.maybePop(context);
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 3500),
                                          () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                Routes2.splashscreen2);
                                      });
                                      // }
                                    });
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
                                            color: context
                                                    .read<ThemeProvider2>()
                                                    .isDark
                                                ? Colors.white
                                                : kPrimaryColor,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            'Weak Password',
                                            style: TextStyle(
                                              color: context
                                                      .read<ThemeProvider2>()
                                                      .isDark
                                                  ? Colors.white
                                                  : kPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'Your password must include: \n\t• Minimum 1 Upper case \n\t• Minimum 1 lowercase\n\t• Minimum 1 Numeric Number\n\t• Minimum 1 Special Character\n• Common Allow Character ( ! @ # \$ & * ~ )'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            context
                                                .read<OtpProvider2>()
                                                .changeRepass = '';
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
                                        color: context
                                                .read<ThemeProvider2>()
                                                .isDark
                                            ? Colors.white
                                            : kPrimaryColor,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Error',
                                        style: TextStyle(
                                          color: context
                                                  .read<ThemeProvider2>()
                                                  .isDark
                                              ? Colors.white
                                              : kPrimaryColor,
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
                                      color:
                                          context.read<ThemeProvider2>().isDark
                                              ? Colors.white
                                              : kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'Empty Fields',
                                      style: TextStyle(
                                        color: context
                                                .read<ThemeProvider2>()
                                                .isDark
                                            ? Colors.white
                                            : kPrimaryColor,
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
                                      context
                                          .read<OtpProvider2>()
                                          .changePassword = '';
                                      context
                                          .read<OtpProvider2>()
                                          .changeRepass = '';
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      shape: GFButtonShape.pills,
                      fullWidthButton: true,
                      color: kPrimaryColor,
                      text: 'Create Account',
                      size: GFSize.LARGE,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
