import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xgen_test/features/auth/presentation/login_screen.dart';
import 'package:xgen_test/features/auth/presentation/sign_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String route = '/onboarding';
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, SignScreen.route);
              },
              child: Text("Sign In"),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
              child: Text("LogIn"),
            ),
          ],
        ),
      ),
    );
  }
}
