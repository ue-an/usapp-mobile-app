import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/student.dart';
import 'package:uuid/uuid.dart';

class UploadImageProvider with ChangeNotifier {
  final _firestoreService = FirestoreService2();
  File? _storageFilePath;
  late String? _pickedImageUrl = '';
  //getter
  File? get storageFilePath => _storageFilePath;
  String? get pickedImageUrl => _pickedImageUrl;
  //setter
  set changeStorageFilePath(File storageFilePath) {
    _storageFilePath = storageFilePath;
    notifyListeners();
  }

  set changePickedImageUrl(String pickedImageUrl) {
    _pickedImageUrl = pickedImageUrl;
    notifyListeners();
  }

  //functions
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // Upload the photo to firebase storage
  Future<void> uploadFile(
    String filePath,
  ) async {
    File file = File(filePath);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var n = prefs.getString('userstatus');
      await storage.ref('profile/$n').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  //upload/save to firebase storage (NOT COLLECTION!)
  Future<void> uploadFileFirstTime(
    String filePath,
    String email,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('profile/$email').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  //upload reply photos
  Future<void> uploadReplyPhoto(
    String filePath,
    String imageName,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('replies/$imageName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  //upload comment photos
  Future<void> uploadCommentPhoto(
    String filePath,
    String imageName,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('comments/$imageName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  // Get list results of found files from firebase storage
  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    notifyListeners();
    return results;
  }

  //Get/Download the url of photo from firebase storage
  Future<String> getDownloadURL(String curUserEmail) async {
    //select the image url
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('profile/$curUserEmail');
    //get image url from firebase storage
    var url = await ref.getDownloadURL();
    _pickedImageUrl = url;
    notifyListeners();
    return url;
    // return url;
  }

  //FROM PROFILE
  Future<void> uploadFileFromProfile(
    String filePath,
    String email,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('profile/$email').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  setPhotoUrlFromProfile(String studentnumber, String photoUrl) async {
    var res = await _firestoreService.updatePhotoUrlFromProfile(
        studentnumber, photoUrl);
    notifyListeners();
    return res;
  }

  Future<String> getDownloadURLFromProfile(String curUserEmail) async {
    //select the image url
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('profile/$curUserEmail');
    //get image url from firebase storage
    var url = await ref.getDownloadURL();
    _pickedImageUrl = url;
    notifyListeners();
    return url;
    // return url;
  }

  Future<String> getDownloadURLFromReplies(String imageName) async {
    //select the image url
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('replies/$imageName');
    //get image url from firebase storage
    var url = await ref.getDownloadURL();
    _pickedImageUrl = url;
    notifyListeners();
    return url;
    // return url;
  }

  Future<String> getDownloadURLFromComments(String imageName) async {
    //select the image url
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('comments/$imageName');
    //get image url from firebase storage
    var url = await ref.getDownloadURL();
    _pickedImageUrl = url;
    notifyListeners();
    return url;
    // return url;
  }
}
