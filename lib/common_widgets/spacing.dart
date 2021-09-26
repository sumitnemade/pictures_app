import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget SPW(double width) {
  return SizedBox(
    width: width,
  );
}

Widget SPH(double height) {
  return SizedBox(
    height: height,
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
