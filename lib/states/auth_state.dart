import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pictures_app/common_widgets/custom_notification/notification.dart';
import 'package:pictures_app/constants/enums.dart';
import 'package:pictures_app/models/app_user.dart';
import 'package:pictures_app/services/firebase_helper.dart';
import 'package:pictures_app/utils/app_utils.dart';

class AuthState with ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Status? _status = Status.Uninitialized;
  User? _user;
  AppUser? _appUser;
  final FirebaseHelper _db = FirebaseHelper();

  AuthState() {
    _firebaseAuth = FirebaseAuth.instance;
    // _user = _firebaseAuth.currentUser;

    //listener for authentication changes such as user sign in and sign out
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  // AuthState.instance() : _firebaseAuth = FirebaseAuth.instance {
  //   _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  // }

  init() async {
    _user = _firebaseAuth.currentUser;
    // _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  FirebaseAuth? getAuth() => _firebaseAuth;

  AppUser? getAppUser() => _appUser;

  User? getFirebaseUser() => _user;

  Status? getStatus() => _status;

  void setAppUser(AppUser? appUser) {
    _appUser = appUser;
  }

  void setFirebaseUser(User? user) {
    _user = user;
  }

  void setAuthStatus(Status? status) {
    _status = status;
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      debugPrint(firebaseUser.uid);

      _user = firebaseUser;
      _appUser = await _db.getUser(_user?.uid.toString());
      // debugPrint(_appUser?.toMap());
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      AppUtils.showToast(ToastType.SUCCESS, "Login Success",
          position: NotificationPosition.top);
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      AppUtils.showToast(ToastType.ERROR, e.toString(),
          position: NotificationPosition.top);
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyPhoneNumber(String phone) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.verifyPhoneNumber(
          codeSent: (String verificationId, int? forceResendingToken) {},
          verificationFailed: (FirebaseAuthException error) {},
          phoneNumber: phone,
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {});
      AppUtils.showToast(ToastType.SUCCESS, "Login Success",
          position: NotificationPosition.top);
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      AppUtils.showToast(ToastType.ERROR, e.toString(),
          position: NotificationPosition.top);
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _status = Status.Unauthenticated;

    if (_user != null) {
      _firebaseAuth.signOut();
      _user = null;
      _appUser = null;
      _status = Status.Unauthenticated;
      notifyListeners();
    }
    return Future.delayed(Duration.zero);
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      _status = Status.Authenticated;
      AppUser user = AppUser(
          id: _user?.uid,
          status: "Active",
          email: email,
          fullName: name,
          profileImage: "");

      bool result = await _db.saveUser(user);
      notifyListeners();
      return result;
    } catch (e) {
      AppUtils.showToast(ToastType.ERROR, e.toString(),
          position: NotificationPosition.top);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }
}
