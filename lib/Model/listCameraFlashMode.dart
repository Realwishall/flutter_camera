import 'package:camera/camera.dart';

import 'cameraFlashMode.dart';
import 'package:flutter/material.dart';
 class ListCameraFlashMode{
  final List<CameraFlashMode> listCameraFlashMode = [];
   ListCameraFlashMode(){
    listCameraFlashMode.add(CameraFlashMode(Icons.flash_off, FlashMode.off));
    listCameraFlashMode.add(CameraFlashMode(Icons.flash_on, FlashMode.always));
    listCameraFlashMode.add(CameraFlashMode(Icons.flash_auto, FlashMode.auto));
  }
}