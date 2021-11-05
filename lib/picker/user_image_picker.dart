import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageStore;
  Future pickAnImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxHeight: 150, maxWidth: 150);
      if (pickedImage == null) return;
      final imageTemporay = File(pickedImage.path);
      setState(() {
        this.pickedImageStore = imageTemporay;
      });
      widget.imagePickFn(pickedImageStore!);
    } on Exception catch (e) {
      print('Failed to upload image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage:
              pickedImageStore != null ? FileImage(pickedImageStore!) : null,
        ),
        IconButton(
          onPressed: pickAnImage,
          icon: Icon(Icons.image),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
