// stful
import 'dart:async';
import 'package:app/NavbarBottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Navbarbottom())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color.fromARGB(255, 231, 182, 7),
          statusBarIconBrightness: Brightness.light,
        ),
        toolbarHeight: 0,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(right: 50, left: 50),
          color: const Color.fromARGB(255, 231, 182, 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('asset/splash.jpeg'),
              ),
              Text(
                "Jayapataka Swami",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              Text(
                "Official Mobile App",
                style: TextStyle(fontSize: 20),
              ),
            ],
          )),
    );
  }
}
