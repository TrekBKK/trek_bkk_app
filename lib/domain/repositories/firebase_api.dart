import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadFile(XFile file) async {
    final now = DateTime.now();
    final formatter = DateFormat('ddMMyyyy');
    String timeNow = formatter.format(now);

    Reference ref =
        _storage.ref().child("routes/$timeNow-${basename(file.path)}");
    UploadTask uploadTask = ref.putFile(File(file.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    if (taskSnapshot.state == TaskState.success) {
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } else {
      print('upload image error');
      return '';
    }
  }
}
