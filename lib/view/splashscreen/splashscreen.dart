import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahul/view/loginscreen/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changingScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const LoginScreen());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    changingScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDEFE6),
      body: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Image.asset('images/splashscreenimage.png'),
        ),
      ),
    );
  }
}
