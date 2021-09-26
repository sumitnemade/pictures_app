import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common_widgets/custom_notification/overlay_state_finder.dart';
import 'constants/enums.dart';
import 'screens/dashboard.dart';
import 'screens/login_signup_screen.dart';
import 'states/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthState()),
      ],
      // child: MyApp(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthState authState = Provider.of<AuthState>(context, listen: false);

    return OverlaySupport.global(
      child: MaterialApp(
          title: "Indian Cricket league",
          home: Consumer<AuthState>(builder: (context, AuthState auth, _) {
            authState.init();
            return auth.getStatus() == Status.Authenticated
                ? const Dashboard()
                : (auth.getStatus() == Status.Unauthenticated ||
                        auth.getStatus() == Status.Uninitialized)
                    ? const LoginSignUpScreen()
                    : Container(
                        color: Colors.white,
                      );
          })),
    );
  }
}
