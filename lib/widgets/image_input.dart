import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
     return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;  // The type of _selectedImage is File and initially it holds a null value // We use this File type for showing a preview of the image and for the File we import the 'dart:io'; package (input/output).
 // File is a variable which is provided by dart:io package and it is used to store a image for e.g., we can store a color by using Color variable which is provided by material.dart package
  void _takePicture() async{
    final imagePicker = ImagePicker();  // The type of imagePicker is ImagePicker
    final pickedImage = await imagePicker.pickImage(        // .pickVideo, .pickMultiImage, .pickMedia, .pickMultipleMedia  // The type of pickedImage is XFile? which can holds a null value
        source: ImageSource.camera,       // .gallery,
      // imageQuality: ,
      // maxHeight: ,
      maxWidth: 600, // mobile screen width
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);  // here we catch the user's directory image path and convert this path's value into File that means we convert the XFile into File
    });
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build (BuildContext context) {

    Widget content = TextButton.icon(onPressed: _takePicture, icon: const Icon(Icons.camera), label: const Text('Take Picture') );
        if (_selectedImage != null) {
          content = GestureDetector(
            onTap: _takePicture,
              child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
        // We take Image.asset for the image but here we take image from user's file directory so we write Image.file
          );
        }
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2), ),
      ),
      alignment: Alignment.center, // Alignment of content
      child: content,
    );
  }
}