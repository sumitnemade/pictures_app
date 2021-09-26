import 'package:flutter/material.dart';
import 'package:pictures_app/common_widgets/spacing.dart';
import 'package:pictures_app/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.loadingText}) : super(key: key);
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white20tran,
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
        alignment: Alignment.center,
        width: 150,
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SPH(10),
            Text(
              loadingText ?? "Loading...",
              style: TextStyle(
                  color: AppColors.textColor2,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
