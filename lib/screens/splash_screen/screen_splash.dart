import 'dart:async';

import 'package:flutter/material.dart';
import 'package:track_mind/screens/home/screen_home.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  double time = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      setState(() {
        time = 1.0;
      });
    });

    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx1) {
            return const Screenhome();
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: AnimatedOpacity(
        opacity: time,
        duration: const Duration(seconds: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('sample test'),
            Image.asset(
              'assets/play_store_512.png',
            )
          ],
        ),
      ),
    );
  }
}
