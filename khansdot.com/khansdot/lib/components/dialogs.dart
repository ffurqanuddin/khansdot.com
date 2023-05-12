import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<dynamic> showNoInternetDialog(context) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset("images/nointernet.json"),
          //Okay
          CupertinoButton(
              color: Colors.pink,
              child: const Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}
