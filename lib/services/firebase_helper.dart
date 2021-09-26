import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pictures_app/common_widgets/custom_notification/notification.dart';
import 'package:pictures_app/constants/enums.dart';
import 'package:pictures_app/models/app_user.dart';
import 'package:pictures_app/models/image_model.dart';
import 'package:pictures_app/utils/app_utils.dart';

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper.internal();

  factory FirebaseHelper() => _instance;

  FirebaseHelper.internal();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference imagesCollection =
      FirebaseFirestore.instance.collection('images');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<AppUser> getUser(String? userID) async {
    debugPrint(userID);
    return usersCollection.doc(userID).get().then((value) {
      debugPrint("s4");
      return AppUser.map(value.data());
    }).catchError((error) {
      AppUtils.showToast(ToastType.ERROR, error.toString(),
          position: NotificationPosition.top);
    });
  }

  Future<List<ImageModel>> getAllImages() async {
    List<ImageModel> items = [];

    return await imagesCollection
        .orderBy("uploadDate", descending: true)
        // .limit(50)
        .get()
        .then((snap) {
      for (var element in snap.docs) {
        items.add(ImageModel.map(element.data()));
      }
      return items;
    }).catchError((error) {
      return items;
    });
  }

  Future<bool> saveUser(AppUser? appUser) async {
    try {
      return await usersCollection
          .doc(appUser?.id)
          .set(appUser?.toMap())
          .then((value) {
        return true;
      });
    } catch (e) {
      AppUtils.showToast(ToastType.ERROR, e.toString(),
          position: NotificationPosition.top);
      return false;
    }
  }

  Future<void> savePicture(ImageModel? model) async {
    try {
      final TransactionHandler createTransaction = (Transaction tx) async {
        final ds = await tx.get(imagesCollection.doc());
        model?.id = ds.id;
        final Map<String?, dynamic> data = model!.toMap();

        tx.set(ds.reference, data);

        return data;
      };

      await FirebaseFirestore.instance
          .runTransaction(createTransaction)
          .then((mapData) {})
          .catchError((error) {});
    } catch (e) {
      AppUtils.showToast(ToastType.ERROR, e.toString(),
          position: NotificationPosition.top);
    }
  }

  static Future uploadImage(
      Asset asset, String folderName, String filename) async {
    ByteData byteData = await asset.requestOriginal();
    Uint8List imageData = byteData.buffer.asUint8List();
    Reference reference =
        FirebaseStorage.instance.ref().child(folderName).child(filename);
    UploadTask uploadTask = reference.putData(imageData);

    return await (await uploadTask).ref.getDownloadURL();
  }
}
