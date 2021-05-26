import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

CameraController? controller;

class HomePage extends StatefulWidget {
  List<CameraDescription> cameras = [];

  HomePage(this.cameras, {
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XFile> listImageFile = [];
  List<String> pathToImageLocation = [];

  String path = '';
  late File file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraApp(widget.cameras),
          Positioned(
            bottom:30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded( child: Container(
                        height:70,
                        //Image(image: FileImage(File(listImageFile[0].path)),):null),
                        child: listImageFile.length != 0?PageView.builder(
                            itemCount:listImageFile.length ,itemBuilder: (context,index)=>
                            Stack(children: [
                              Align(alignment: Alignment.center,child: Image(image: FileImage(File(listImageFile[listImageFile.length-index-1].path)))),
                              Positioned(
                                right:0,
                                top:0,
                                child: GestureDetector(
                                  onTap: (){
                                    print('Removing');
                                    listImageFile.removeAt(listImageFile.length-index-1);setState(() {

                                    });},
                                  child: Icon(Icons.delete,color: Colors.white70,size: 15,),
                                ),
                              ),
                              Align(alignment:Alignment.centerRight,child: Opacity(opacity: (index!=listImageFile.length-1 && listImageFile.length>1)?1:0,child: Icon(Icons.skip_next),)),
                              Align(alignment:Alignment.centerLeft,child: Opacity(opacity: index != 0?1:0,child: Icon(Icons.skip_previous),))
                            ])):null),
                  ),
                  Expanded(
                    child: GestureDetector(onTap:(){
                      onTakePictureButtonPressed();
                    },child: Icon(Icons.camera,color: Colors.black,size: 60,)),
                  ),
                  Expanded(child: Icon(Icons.swap_horizontal_circle_outlined)),

                ],),
            ),
          )
        ],
      ),
    );
  }

  void onTakePictureButtonPressed() async{

    takePicture().then((XFile? file) {
      if(file != null){
        listImageFile.add(file);
      }
      if (file != null) showInSnackBar('Picture saved to ${file.path}');
      showInSnackBar('hhe');
      setState(() {

      });
  });}
}



class CameraApp extends StatefulWidget {
  List<CameraDescription> cameras;
  CameraApp(this.cameras);


  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {

  @override
  void initState() {

    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller!),
    );
  }
}

Future<XFile?> takePicture() async {
  final CameraController? cameraController = controller;
  if (cameraController == null || !cameraController.value.isInitialized) {
    showInSnackBar('Error: select a camera first.');
    return null;
  }

  if (cameraController.value.isTakingPicture) {
    // A capture is already pending, do nothing.
    showInSnackBar('A capture is already pending, do nothing');
    return null;
  }

  try {
    XFile file = await cameraController.takePicture();
    showInSnackBar('file');

    return file;
  } on CameraException catch (e) {
    _showCameraException(e);
    showInSnackBar(e.toString());

    return null;
  }
}

void showInSnackBar(String message) {
  // TODO
  print(message);
}

void _showCameraException(CameraException e) {
  // TODO
}