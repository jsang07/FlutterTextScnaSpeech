import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:textscanspeech/scan.dart';
import 'package:textscanspeech/speech.text.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget? _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return const Scanner();
      case 1:
        return const Speech();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final value = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('확인'),
                content: const Text('나가시겠습니까?'),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text('아니요')),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text('네')),
                ],
              );
            },
          );
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
          body: _bodyWidget(),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: GNav(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.black,
                  gap: 20,
                  padding: const EdgeInsets.all(16),
                  onTabChange: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  tabs: const [
                    GButton(
                      icon: Icons.camera_alt,
                      text: 'Image to Text',
                      margin: EdgeInsets.only(left: 25),
                    ),
                    GButton(
                      icon: Icons.speaker,
                      text: 'Speech to Text',
                      margin: EdgeInsets.only(right: 25),
                    )
                  ]),
            ),
          ),
        ));
  }
}
