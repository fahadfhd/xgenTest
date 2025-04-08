import 'package:flutter/material.dart';
import 'package:xgen_test/app/routes.dart';
import 'package:xgen_test/features/splash/splash_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.5),
                minimumSize: Size(double.infinity, 50.h),
                disabledForegroundColor: Colors.grey,
                disabledBackgroundColor: Colors.grey,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                foregroundColor: Colors.white,
              ),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          onGenerateRoute: onAppGenerateRoute(),
          initialRoute: SplashScreen.route,
        );
      },
    );
  }
}
