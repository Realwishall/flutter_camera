import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Preview extends StatefulWidget {
  Key key;
  List<XFile> listImageFile;
  int indexOfImage;
  Preview({required this.key,required this.listImageFile,required this.indexOfImage}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: widget.indexOfImage);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(000),
      body: PageView.builder(
          controller:_pageController,
          itemCount:widget.listImageFile.length ,itemBuilder: (context,index)=>
          InteractiveViewer(
            child: Stack(children: [
              Align(alignment: Alignment.center,child: Image(image: FileImage(File(widget.listImageFile[widget.listImageFile.length-index-1].path)))),

            ]),
          )));
  }
}
