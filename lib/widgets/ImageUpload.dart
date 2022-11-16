import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  String imageUrl = '';
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Upload Image',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            child: (imageFile?.path != null)
                ? Image.file(
                    File(imageFile!.path),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network('https://i.imgur.com/sUFH1Aq.png'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                _getFromGallery();
              },
              child: const Text("Select Image",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
        ],
      ),
    );
  }

  uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isDenied) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        // File file = File(filePath);
        setState(() {});
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("images");
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isDenied) {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        setState(() {});
        try {
          await imagesRef
              .child('/img-${DateTime.now().toIso8601String()}.jpg')
              .putFile(file)
              .then((p0) async {
            print(p0.ref.fullPath);
            final url = await imagesRef.getDownloadURL();
            print('------------URL');
            print(url);
          });
        } on FirebaseException catch (e) {
          // ...
          print(e);
        }
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }
  }
}
