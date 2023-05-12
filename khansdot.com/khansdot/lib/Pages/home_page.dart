import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/dialogs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //website url
  late final String _url = "https://khansdot.com";

  //Connectivity package
  late StreamSubscription _connectivitySubcription;

  //webview controller
  late final WebViewController controller;

  //LinearProgressIndicator Value
  var loadingPercentage = 0;

  //CircleProgress Indicator
  bool _progress = false;

  //Floating Action Button
  bool _floatingButtonAnimation = false;

  //OnWillPop Button Function
  Future<bool> _onWillPop() async {
    controller.goBack();
    return false;
  }

  ////Reload Button Animation
  bool _reloadButton = false;

  reloadButtonPressed() {
    _reloadButton = true;
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _reloadButton = false;
      });
    });
    setState(() {});
  }

  ///initial State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///WebView Controller Intializaton
    controller = WebViewController()
      //NavigationDelegate//
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
              _progress = true;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
              _progress = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
              _progress = false;
            });
          },
        ),
      )
      ..enableZoom(true)
      //********************//
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //Load Request//
      ..loadRequest(
        Uri.parse(_url),
      );
    //********//
    ///Floating Animation
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _floatingButtonAnimation = true;
      });
    });

    //Internet Connectivity
    _connectivitySubcription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.wifi ||
          result != ConnectivityResult.mobile) {
        ///Show No internet Dialog
        showNoInternetDialog(context);

      }
      //////*******Init State *******//////////
    });
  }



  ///Dispose Method
  @override
  void dispose() {
    // TODO: implement dispose
    //dispose Connectivity
    _connectivitySubcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          ///AppBar
          appBar: AppBar(
            backgroundColor: CupertinoColors.black,
            title: const Text("Khansdot.com"),
            actions: [
              ///Back Button
              IconButton(
                  onPressed: () async {
                    await controller.goBack();
                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_back_ios)),

              //Forward Button
              IconButton(
                  onPressed: () async {
                    controller.goForward();
                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_forward_ios)),

              // Load a Lottie file from your assets
              GestureDetector(
                onTap: () {
                  setState(() {
                    controller.reload();
                    reloadButtonPressed();
                  });
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: Lottie.asset('images/refresh.json',
                      fit: BoxFit.scaleDown, animate: _reloadButton),
                ),
              ),
            ],
          ),

          //Floating action button
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: AnimatedContainer(
            duration: const Duration(seconds: 1),
            margin: EdgeInsets.only(

                ///Animation
                bottom: _floatingButtonAnimation
                    ? MediaQuery.of(context).size.height * 0.05
                    : 0),
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.amber,
              onPressed: () {
                setState(() {
                  controller.scrollTo(0, 0);
                });
              },
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: CupertinoColors.black,
              ),
            ),
          ),

          body: Stack(
            children: [
              ///WebView
              WebViewWidget(
                controller: controller,
                gestureRecognizers: {
                  Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                },
              ),

              ///Loading Progress Bar
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade100,
                  color: Colors.pink,

                  ///Value 0... to 100
                  value: loadingPercentage / 100.0,
                ),

              //If page is loading show iOS ProgressIndicator
              if (_progress)
                const Center(
                  child:
                      CupertinoActivityIndicator(animating: true, radius: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
