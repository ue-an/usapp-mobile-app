// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:getwidget/components/button/gf_button.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:provider/src/provider.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/firebasee_storage.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';

// class UploadIMGtoFirebase extends StatefulWidget {
//   @override
//   _UploadIMGtoFirebaseState createState() => _UploadIMGtoFirebaseState();
// }

// class _UploadIMGtoFirebaseState extends State<UploadIMGtoFirebase> {
//   // File? file;

//   TextEditingController _textEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     var file = context.read<UploadImageProvider>().file;
//     // final FirebaseeStorage storage = FirebaseeStorage();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Profile"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               context.watch<UploadImageProvider>().file == null
//                   ? InkWell(
//                       onTap: () {
//                         // chooseImage();
//                       },
//                       child: Icon(
//                         Icons.image,
//                         size: 48,
//                       ),
//                     )
//                   : Image.file(file!),
//               SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 controller: _textEditingController,
//                 decoration: InputDecoration(
//                     labelText: "Name",
//                     hintText: "Enter name",
//                     border: OutlineInputBorder()),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Divider(
//                 thickness: 3,
//                 color: Theme.of(context).backgroundColor,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   // updateProfile(context);
//                   final results = await FilePicker.platform.pickFiles(
//                     allowMultiple: false,
//                     type: FileType.custom,
//                     allowedExtensions: ['png', 'jpg'],
//                   );

//                   if (results == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('No file'),
//                       ),
//                     );
//                     return null;
//                   }
//                   final path = results.files.single.path;
//                   final fileName = results.files.single.name;
//                   // setState(() {
//                   //   file = File(path!);
//                   // });
//                   context.read<UploadImageProvider>().changeFile = File(path!);

//                   print(path);
//                   print(fileName);

//                   context
//                       .read<UploadImageProvider>()
//                       .uploadFile(path, fileName)
//                       .then((value) => print('Done'));
//                 },
//                 child: Text("Update profile"),
//               ),
//               // get list of files found from firebase storage
//               // FutureBuilder(
//               //     future: storage.listFiles(),
//               //     builder: (BuildContext context,
//               //         AsyncSnapshot<firebase_storage.ListResult> snapshot) {
//               //       if (snapshot.connectionState == ConnectionState.done &&
//               //           snapshot.hasData) {
//               //         return Container(
//               //           padding: EdgeInsets.symmetric(horizontal: 20),
//               //           height: 100,
//               //           child: ListView.builder(
//               //               scrollDirection: Axis.horizontal,
//               //               itemCount: snapshot.data!.items.length,
//               //               itemBuilder: (BuildContext context, int index) {
//               //                 return GFButton(
//               //                   onPressed: () {},
//               //                   child: Text(snapshot.data!.items[index].name),
//               //                 );
//               //               }),
//               //         );
//               //       }
//               //       if (snapshot.connectionState == ConnectionState.waiting ||
//               //           !snapshot.hasData) {
//               //         return CircularProgressIndicator();
//               //       }
//               //       return Container();
//               //     })
//               //=================
//               // FutureBuilder(
//               //   future: storage.downloadURL('elaina.jpeg'),
//               //   builder:
//               //       (BuildContext context, AsyncSnapshot<String> snapshot) {
//               //     if (snapshot.connectionState == ConnectionState.done &&
//               //         snapshot.hasData) {
//               //       return Container(
//               //         width: 300,
//               //         height: 250,
//               //         child: Image.network(
//               //           snapshot.data!,
//               //           fit: BoxFit.cover,
//               //         ),
//               //       );
//               //     }
//               //     if (snapshot.connectionState == ConnectionState.waiting ||
//               //         !snapshot.hasData) {
//               //       return const CircularProgressIndicator();
//               //     }
//               //     return Container();
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // chooseImage() async {
//   //   XFile? xfile = await ImagePicker()
//   //       .pickImage(source: ImageSource.gallery, maxHeight: 200);
//   //   print("file " + xfile!.path);
//   //   file = File(xfile.path);
//   //   setState(() {});
//   // }

//   // updateProfile(BuildContext context) async {
//   //   Map<String, dynamic> map = {};
//   //   if (file != null) {
//   //     String url = await uploadImage();
//   //     map['profileImage'] = url;
//   //   }
//   //   map['name'] = _textEditingController.text;

//   //   await FirebaseFirestore.instance
//   //       .collection("students")
//   //       .doc(FirebaseAuth.instance.currentUser!.uid)
//   //       .update(map);
//   //   Navigator.pop(context);
//   // }

//   // Future<String> uploadImage() async {
//   //   TaskSnapshot taskSnapshot = await FirebaseStorage.instance
//   //       .ref()
//   //       .child("profile")
//   //       .child(
//   //           FirebaseAuth.instance.currentUser!.uid + "_" + basename(file!.path))
//   //       .putFile(file!);

//   //   return taskSnapshot.ref.getDownloadURL();
//   // }
// }
