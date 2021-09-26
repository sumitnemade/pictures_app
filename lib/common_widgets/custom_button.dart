import 'package:flutter/material.dart';
import 'package:pictures_app/constants/app_colors.dart';
import 'package:pictures_app/constants/keys.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, this.buttonText, this.onTap, this.color})
      : super(key: key);
  final GestureTapCallback? onTap;
  final String? buttonText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        //width: 325,
        height: 40,
        decoration: BoxDecoration(
            color: color ?? AppColors.whiteColor,
            borderRadius: BorderRadius.circular(7)),
        child: Text(
          buttonText ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white,
            fontFamily: Keys.fontFamilyNoto,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.3334423928571427,
          ),
        ),
      ),
    );
  }
}
