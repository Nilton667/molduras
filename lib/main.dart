import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molduras/app/views/login.dart';
import 'package:desktop_window/desktop_window.dart';
import 'app/util/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setMinWindowSize(
      Size(1200, 800),
    );
  }
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      title: 'Aphit Molduras',
      theme: themeData.lightTheme,
      darkTheme: themeData.darkTheme,
      home: LoginScreen(),
    ),
  );
}
