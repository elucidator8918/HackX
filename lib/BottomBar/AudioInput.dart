import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/AudioModel.dart';
import '../Models/Utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var lst = [];
String ngrokurl = "https://3f61-34-124-150-43.ngrok-free.app";

class AudioInput extends StatefulWidget {
  const AudioInput({super.key});

  @override
  State<AudioInput> createState() => _AudioInputState();
}

class _AudioInputState extends State<AudioInput>
    with SingleTickerProviderStateMixin {
  int maxDuration = 10;
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;
  List<Color> gradientColors = const [
    Color(0xffFF0069),
    Color(0xffFED602),
    Color(0xff7639FB),
    Color(0xffD500C5),
    Color(0xffFF7A01),
    Color(0xffFF0069),
  ];
  late AnimationController _controller;
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  bool isRecorderReady = false, gotSomeTextYo = false, isPlaying = false;

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    String? path = await recorder.stopRecorder();
    File audioPath = await saveAudioPermanently(path!);
    if (kDebugMode) {
      print('Recorded audio: $path');
    }
    //await player.startPlayer(fromURI: path, codec: Codec.aacADTS);
    lst = await sendAudio(audioPath);
    if (kDebugMode) {
      print(lst);
    }
    if (lst[1] == 200) {
      gotSomeTextYo = true;
      setState(() {
        maxDuration = maxDuration;
      });
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: maxDuration))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isPlaying = false;
        }
      });
    initRecorder();
    player.openPlayer().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    recorder.closeRecorder();
    player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[900]!,
                Colors.black,
                Colors.grey[900]!,
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 50 * (height / deviceHeight),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Speak into the mic",
                    style: TextStyle(
                        fontFamily: "productSansReg",
                        color: Color(0xFF009CFF),
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 100 * (height / deviceHeight),
                ),
                StreamBuilder<RecordingDisposition>(
                    stream: recorder.onProgress,
                    builder: (context, snapshot) {
                      final duration = snapshot.hasData
                          ? snapshot.data!.duration
                          : Duration.zero;
                      String twoDigits(int n) => n.toString().padLeft(2, '0');
                      final twoDigitMinutes =
                          twoDigits(duration.inMinutes.remainder(60));
                      final twoDigitSeconds =
                          twoDigits(duration.inSeconds.remainder(60));
                      return Text(
                        "$twoDigitMinutes:$twoDigitSeconds s",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF009CFF),
                          fontFamily: "productSansReg",
                        ),
                      );
                    }),
                SizedBox(
                  height: 70 * (height / deviceHeight),
                ),
                if (isPlaying)
                  Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                    color: const Color(0xFF009CFF),
                    size: 50 * (height / deviceHeight),
                  )),
                if (!isPlaying)
                  SizedBox(
                    height: 150 * (height / deviceHeight),
                    child: gotSomeTextYo
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              lst[0],
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "productSansReg",
                                  color: Color(0xFF009CFF)),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                  ),
                SizedBox(
                  height: 50 * (height / deviceHeight),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 60 * (height / deviceHeight),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      shape: BoxShape.circle),
                  child: GestureDetector(
                    onTap: () async {
                      if (recorder.isRecording) {
                        isPlaying = false;
                        await stop();
                        _controller.reset();
                      } else {
                        await record();
                        isPlaying = true;
                        _controller.reset();
                        _controller.forward();
                      }
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      height: isPlaying
                          ? 25 * (height / deviceHeight)
                          : 50 * (height / deviceHeight),
                      width: isPlaying
                          ? 25 * (height / deviceHeight)
                          : 50 * (height / deviceHeight),
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(isPlaying ? 6 : 100),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70 * (height / deviceHeight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getAudio(String text) async {
    var res = await http.post(
      Uri.parse('$ngrokurl/coqui-tts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"text": text, 'emotion': "Cheerful & Professional"}),
    );
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.bodyBytes);
      }
      await player.startPlayer(fromDataBuffer: res.bodyBytes);
    }
  }

  Future getNER(String text) async {
    var res = await http.post(
      Uri.parse('$ngrokurl/ner/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"text": text}),
    );
    if (kDebugMode) {
      print(res.statusCode);
    }
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.body);
      }
    }
  }

  Future<List<Object?>> getLLMResponse(String text) async {
    var res = await http.post(
      Uri.parse('$ngrokurl/chat/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"text": text}),
    );
    Map<String, dynamic> data = jsonDecode(res.body);
    var stuff = Audio.fromJson(data);
    if (kDebugMode) {
      print(res.statusCode);
      await getAudio(stuff.text!);
    }
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.body);
      }
    }
    return [stuff.text, res.statusCode];
  }

  Future<List<Object?>> sendAudio(File? audioPath) async {
    List<Object?> lst = [];
    if (kDebugMode) {
      print(audioPath!.path);
    }
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$ngrokurl/transcribe/'),
    );
    response.files.add(http.MultipartFile(
        'file', audioPath!.readAsBytes().asStream(), audioPath.lengthSync(),
        filename: basename(audioPath.path),
        contentType: MediaType('application', 'octet-stream')));
    var res = await response.send();
    var responseBody = await res.stream.bytesToString();
    if (kDebugMode) {
      print(responseBody);
      print(res.statusCode);
    }
    if (res.statusCode != 200) {
      Utils.showSnackBar("Error occurred!");
    }

    Map<String, dynamic> data = jsonDecode(responseBody);
    var stuff = Audio.fromJson(data);
    if (res.statusCode == 200) {
      lst = await getLLMResponse(stuff.text!);
      await getNER(stuff.text!);
      if (kDebugMode) {
        print(stuff.text);
      }
    }

    return lst;
  }

  Future<File> saveAudioPermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final audio = File('${directory.path}/$name');
    return File(path).copy(audio.path);
  }
}
