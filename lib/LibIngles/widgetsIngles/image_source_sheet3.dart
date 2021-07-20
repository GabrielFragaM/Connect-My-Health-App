import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet3 extends StatelessWidget {

  final Function(File) onImageSelected2;

  ImageSourceSheet3({this.onImageSelected2});

  void imageSelected(File image2) async {
    if(image2 != null){
      File croppedImage2 = await image2;
      onImageSelected2(croppedImage2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: (){},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Text("Camera"),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.camera);
              imageSelected(image);
            },
          ),
          FlatButton(
            child: Text("Gallery"),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);
              imageSelected(image);
            },
          )
        ],
      ),
    );
  }
}
