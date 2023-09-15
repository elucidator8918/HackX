import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/Utils.dart';
import 'package:http/http.dart' as http;

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child: image == null
                ? Image(
                    image: const AssetImage(
                      "assets/images/download.jpg",
                    ),
                    width: width * (250 / 340),
                    height: height * (250 / 804),
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    image!,
                    width: width * (250 / 340),
                    height: height * (250 / 804),
                    fit: BoxFit.cover,
                  )),
        Padding(
            padding:
                const EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
            child: ListTile(
              onTap: () {
                pickImage();
                if (image != null) {
                  getOCR(image);
                }
              },
              leading: Icon(
                Icons.camera_alt_outlined,
                size: 25,
                color: Colors.grey[900],
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
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
        Padding(
            padding:
                const EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
            child: ListTile(
              onTap: () async {
                var file = await pickFile();
              },
              leading: Icon(
                Icons.upload_file_outlined,
                size: 25,
                color: Colors.grey[900],
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Upload File",
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

  Future getOCR(File? imagePath) async {
    if (kDebugMode) {
      print(imagePath!.path);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {'token': '$token'};
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$url/ocr/'),
    );
    response.files.add(http.MultipartFile(
        'img', imagePath!.readAsBytes().asStream(), imagePath.lengthSync(),
        filename: basename(imagePath.path),
        contentType: MediaType('application', 'octet-stream')));
    response.headers.addAll(header);
    var res = await response.send();
    var responseBody = await res.stream.bytesToString();
    if (kDebugMode) {
      print(responseBody);
      print(res.statusCode);
    }
    if (res.statusCode != 200) {
      Utils.showSnackBar("Error occurred! Unable to login.");
    }

    Map<String, dynamic> data = jsonDecode(responseBody);
  }

  Future pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        return file;
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to pick file: $e');
      }
    }
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
