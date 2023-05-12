import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../components/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Opacity Animation
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _opacity = 1;
      });
    });

    ///Navigate to HomePage
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, Routes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //logo
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _opacity,
              child: Image.asset("images/logo.png"),
            ),
          ),

          //Yasir Khan
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Text
                  const Text(
                    "Made by",
                    style: TextStyle(fontSize: 10),
                  ),

                  //Animated Text
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Yasir Khan'),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          //App Version
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: AutoSizeText(
                "version 1.1",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                    fontSize: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
