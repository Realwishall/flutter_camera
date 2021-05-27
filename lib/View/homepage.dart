import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:flutter_camera_app/View/preview.dart';
import '../Model/listCameraFlashMode.dart';
CameraController? _cameraController;

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
  late File file;
  late int cameraType;
  late int flashMode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraType  = 0;
    flashMode = 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(child: CameraApp(widget.cameras[0],UniqueKey)),
          Positioned(
            bottom:30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildMiniPreview(),
                  CameraControl(),
                  switchCamera(),

                ],),
            ),
          )
        ],
      ),
    );
  }

  Expanded switchCamera() {
    return Expanded(child: GestureDetector(
                    onTap: (){
                      cameraType = cameraType ==0?1:0;
                      _cameraController = CameraController(widget.cameras[cameraType], ResolutionPreset.max);
                       _cameraController!.initialize().then((_) {
                         setState(() {

                         });
                       });

                    },
                    child: Icon(Icons.camera_alt)));
  }

  Expanded CameraControl() {

    ListCameraFlashMode _listCameraFlashMode =  ListCameraFlashMode();

    return Expanded(
                  child: Column(
                    children: [
                      GestureDetector(onTap:(){
                        onTakePictureButtonPressed();
                      },child: Icon(Icons.camera,color: Colors.black,size: 60,)),
                      GestureDetector(onTap: (){
                        if(flashMode==_listCameraFlashMode.listCameraFlashMode.length-1){
                          flashMode =0;
                        }else{
                          flashMode = flashMode+1;
                        }
                        _cameraController!.setFlashMode(_listCameraFlashMode.listCameraFlashMode[flashMode].flashMode);

                        setState(() {

                        });
                      },child: Icon(_listCameraFlashMode.listCameraFlashMode[flashMode].iconData,color: Colors.white))
                    ],
                  ),
                );
  }

  Expanded buildMiniPreview() {
    return Expanded( child: Container(
                      height:70,
                      child: listImageFile.length != 0?PageView.builder(
                          itemCount:listImageFile.length ,itemBuilder: (context,index)=>
                          Stack(children: [
                            Align(alignment: Alignment.center,child: GestureDetector(onTap: (){
                              //Open priveiw
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Preview(listImageFile:listImageFile,indexOfImage:index,key: UniqueKey())),
                              );
                              //Navigator.push(context, Preview(key: UniqueKey));
                            },child: Image(image: FileImage(File(listImageFile[listImageFile.length-index-1].path))))),
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
                          ])):null),);
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

class FlashButton extends StatefulWidget {
  FlashMode flashMode;
  IconData? iconData;
  bool isSelected;
  FlashButton({
    required Key key,required this.flashMode,required this.iconData,required this.isSelected
  }) : super(key: key);

  @override
  _FlashButtonState createState() => _FlashButtonState();
}

class _FlashButtonState extends State<FlashButton> {
  late bool isSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    print('Just Flash');
    return GestureDetector(onTap: (){
      _cameraController!.setFlashMode(widget.flashMode);
      isSelected = !isSelected;
      setState(() {

      });
    },child: Icon(widget.iconData,color: isSelected?Colors.white:Colors.black,));
  }
}



class CameraApp extends StatefulWidget {
  CameraDescription cameras;
  CameraApp(this.cameras,key);


  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {

  @override
  void initState() {

    super.initState();
    _cameraController = CameraController(widget.cameras, ResolutionPreset.max);
    _cameraController!.initialize().then((_) {

      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController!.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(_cameraController!),
    );
  }
}

Future<XFile?> takePicture() async {
  final CameraController? cameraController = _cameraController;
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

  print(e);
  // TODO
}