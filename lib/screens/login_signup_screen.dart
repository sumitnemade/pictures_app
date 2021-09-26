import 'package:flutter/material.dart';
import 'package:pictures_app/common_widgets/custom_button.dart';
import 'package:pictures_app/common_widgets/custom_notification/notification.dart';
import 'package:pictures_app/common_widgets/custom_notification/overlay.dart';
import 'package:pictures_app/common_widgets/custom_text_field.dart';
import 'package:pictures_app/common_widgets/spacing.dart';
import 'package:pictures_app/constants/app_colors.dart';
import 'package:pictures_app/constants/enums.dart';
import 'package:pictures_app/constants/keys.dart';
import 'package:pictures_app/states/auth_state.dart';
import 'package:pictures_app/utils/app_utils.dart';
import 'package:provider/provider.dart';

import '../utils/size_helper.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginSignUpScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _isLogin = true;
  late OverlaySupportEntry _progress;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  void _login() async {
    if (_email.text.isEmpty) {
      AppUtils.showToast(ToastType.ERROR, "Please enter email",
          position: NotificationPosition.top);
      return;
    } else if (_password.text.isEmpty) {
      AppUtils.showToast(ToastType.ERROR, "Please enter password",
          position: NotificationPosition.top);
      return;
    } else if (_password.text.length < 6) {
      AppUtils.showToast(
          ToastType.ERROR, "Please enter password more than 7 characters",
          position: NotificationPosition.top);
      return;
    } else {
      _progress = AppUtils.showProgress();

      var authState = Provider.of<AuthState>(context, listen: false);
      await authState.signIn(_email.text, _password.text);
      _progress.dismiss(animate: false);
    }
  }

  void _signUp() async {
    if (_name.text.isEmpty) {
      AppUtils.showToast(ToastType.ERROR, "Please enter name",
          position: NotificationPosition.top);
      return;
    } else if (_email.text.isEmpty) {
      AppUtils.showToast(ToastType.ERROR, "Please enter email",
          position: NotificationPosition.top);
      return;
    } else if (_password.text.isEmpty) {
      AppUtils.showToast(ToastType.ERROR, "Please enter password",
          position: NotificationPosition.top);
      return;
    } else if (_password.text.length < 6) {
      AppUtils.showToast(
          ToastType.ERROR, "Please enter password more than 7 characters",
          position: NotificationPosition.top);
      return;
    } else {
      _progress = AppUtils.showProgress();

      var authState = Provider.of<AuthState>(context, listen: false);

      try {
        await authState.register(_email.text, _password.text, _name.text);
        _progress.dismiss(animate: false);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = const TextStyle(
        color: Colors.black87,
        fontFamily: Keys.fontFamilyNoto,
        fontSize: 18,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        height: 1);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SPH(displayHeight(context) * 0.10),
                if (!_isLogin)
                  Text(
                    'Name',
                    textAlign: TextAlign.start,
                    style: style,
                  ),
                if (!_isLogin) SPH(10),
                if (!_isLogin)
                  CustomTextField(
                    controller: _name,
                    keyboardType: TextInputType.text,
                  ),
                if (!_isLogin) SPH(15),
                Text(
                  'Email',
                  textAlign: TextAlign.start,
                  style: style,
                ),
                SPH(10),
                CustomTextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SPH(15),
                Text(
                  'Password',
                  textAlign: TextAlign.start,
                  style: style,
                ),
                SPH(10),
                CustomTextField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SPH(40),
                CustomButton(
                  color: AppColors.cbut,
                  onTap: _isLogin ? _login : _signUp,
                  buttonText: _isLogin ? 'Login' : 'Sign Up',
                ),
                SPH(15),
                TextButton(
                  onPressed: () {
                    _isLogin = !_isLogin;
                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? "Create Account" : "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.cbut,
                          fontFamily: Keys.fontFamilyNoto,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.3334423928571427,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
