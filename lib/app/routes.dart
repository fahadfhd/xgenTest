import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:xgen_test/app/slide_right_route.dart';
import 'package:xgen_test/features/auth/presentation/login_screen.dart';
import 'package:xgen_test/features/auth/presentation/on_boarding_screen.dart';
import 'package:xgen_test/features/auth/presentation/sign_screen.dart';
import 'package:xgen_test/features/home/presentation/add_notes_screen.dart';
import 'package:xgen_test/features/home/presentation/home_screen.dart';
import 'package:xgen_test/features/home/presentation/note_details_screen.dart';
import 'package:xgen_test/features/profile/presentation/profile.dart';
import 'package:xgen_test/features/splash/splash_screen.dart';

RouteFactory onAppGenerateRoute() => (settings) {
  Route<dynamic> getRoute(Widget child) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: (context) => child,
        settings: settings,
      );
    } else {
      return SlideRightRoute(child, settings.name);
    }
  }

  switch (settings.name) {
    case '/':
      return getRoute(const SplashScreen());
    case SplashScreen.route:
      return getRoute(const SplashScreen());
    case SignScreen.route:
      return getRoute(const SignScreen());

    case OnBoardingScreen.route:
      return getRoute(const OnBoardingScreen());
    case LoginScreen.route:
      return getRoute(const LoginScreen());

    case HomeScreen.route:
      return getRoute(const HomeScreen());

    case AddEditNoteScreen.route:
      return getRoute(const AddEditNoteScreen());

    case NoteDetailScreen.route:
      final note = settings.arguments as NoteDetailScreen;
      return getRoute(NoteDetailScreen(note: note.note));
    case UserProfileScreen.route:
      return getRoute(const UserProfileScreen());
  }
};
