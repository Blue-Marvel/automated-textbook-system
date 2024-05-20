import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlashTopBar {
  static Widget flashBar(BuildContext context, String message) {
    return Flushbar(
      title: "Hey Ninja",
      titleColor: Colors.white,
      message:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: const [
        BoxShadow(color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
      backgroundGradient:
          const LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: false,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.cancel_outlined,
        color: Colors.greenAccent,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      titleText: Text(
        message,
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      messageText: const Text(''),
    )..show(context);
  }
}
