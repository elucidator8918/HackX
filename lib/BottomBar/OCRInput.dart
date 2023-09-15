import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OCRInput extends StatefulWidget {
  const OCRInput({Key? key}) : super(key: key);

  @override
  State<OCRInput> createState() => _OCRInputState();
}

class _OCRInputState extends State<OCRInput> {
  File? image;
  String? name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(20),
            child: image == null
                ? const Image(
              image: AssetImage(
                "assets/images/download.jpg",
              ),
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            )
                : Image.file(
              image!,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            )),
        Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                pickImage();
              },
              leading: Icon(
                Icons.camera_alt_outlined,
                size: 25,
                color: Colors.grey[900],
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Text(
                  "Use Camera",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                      fontSize: 25,
                      letterSpacing: 2),
                ),
              ),
              tileColor: Colors.cyan[500],
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(10)),
            )),
      ],
    );
  }

  Future pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (image == null) return;
      File imagePath = await saveImagePermanently(image.path);
      name = image.name;
      setState(() {
        this.image = imagePath;
      });
      return imagePath;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future<File> saveImagePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final image = File('${directory.path}/$name');
    return File(path).copy(image.path);
  }
}
