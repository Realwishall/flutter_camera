import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'View/homepage.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();

  runApp(MaterialApp(
    home: HomePage(cameras),
  ));
}
