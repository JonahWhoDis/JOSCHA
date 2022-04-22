import 'package:flutter/material.dart';

import 'splash.dart';

class AppRoutes {
  /// Set routes  name here
  static String authLogin = '/auth-login';
  static String splash = '/';
  static String game = '/game';

  /// Add entry for new route here
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const Splash(),
    };
  }
}
