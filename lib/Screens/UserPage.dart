import 'package:flutter/material.dart';
import 'package:hackx/Screens/Drawer/Drawer.dart';
import 'package:hackx/Screens/Profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'BottomBar/AudioInput.dart';
import 'BottomBar/Chat/TextInput.dart';
import 'BottomBar/OCRInput.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.token}) : super(key: key);

  final String token;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int currentIndex = 1;
  final screens = const [
    OCRInput(),
    TextInput(),
    AudioInput(),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilePage()));
              },
              icon: Image.asset(
                'assets/images/new_profile.png',
                height: height * (42 / 804),
                width: width * (42 / 340),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.cyan[500],
              selectedItemColor: Colors.grey[900],
              unselectedItemColor: Colors.grey[900],
              selectedFontSize: 18,
              unselectedFontSize: 14,
              iconSize: 27,
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              onTap: (index) => setState(() {
                currentIndex = index;
              }),
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(
                    Icons.video_camera_back_outlined,
                    color: Colors.grey[900],
                  ),
                  label: "Camera",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.text_format_outlined,
                    color: Colors.grey[900],
                  ),
                  label: "Text",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.audiotrack_outlined,
                    color: Colors.grey[900],
                  ),
                  label: "Audio",
                ),
              ],
            ),
          ),
        ),
        drawer: const NavigationDrawer1(),
      ),
    );
  }
}
