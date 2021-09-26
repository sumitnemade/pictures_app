import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pictures_app/common_widgets/custom_notification/notification.dart';
import 'package:pictures_app/common_widgets/custom_notification/overlay.dart';
import 'package:pictures_app/common_widgets/custom_notification/overlay_notification.dart';
import 'package:pictures_app/constants/enums.dart';

class AppUtils {
  static void showToast(ToastType toastType, String message,
      {NotificationPosition? position}) {
    showSimpleNotification(
        Text(
          message,
          // textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Noto',
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.3112128999999997,
          ),
        ),
        toastType: toastType,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        duration: const Duration(seconds: 4),
        position: position ?? NotificationPosition.bottom,
        background: toastType == ToastType.SUCCESS
            ? Colors.green
            : toastType == ToastType.ERROR
                ? Colors.red
                : Colors.orangeAccent);
  }

  static OverlaySupportEntry showProgress() {
    return showProgressIndicator();
  }

  static OverlaySupportEntry showFullScreenProgress() {
    return showFullScreenProgressIndicator();
  }

  static convertTimestampToString(Timestamp? tp) {
    return DateFormat('dd MMM yyyy, hh:mm').format(tp!.toDate());
  }

  static String getHashTags(String hashTag) {
    String hash = "";
    List hashList = hashTag.split(" ");

    for (String hashT in hashList) {
      if (hashT.isNotEmpty && !hash.contains("#$hashT ")) {
        hash += "#$hashT ";
      }
    }
    return hash;
  }
}
