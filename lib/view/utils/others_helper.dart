import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

//===========================>

showLoading(Color color) {
  return SpinKitThreeBounce(
    color: color,
    size: 16.0,
  );
}

// showError(BuildContext context) {
//   return Container(
//       height: MediaQuery.of(context).size.height - 180,
//       alignment: Alignment.center,
//       child: const Text("Something went wrong"));
// }

void showToast(String msg, Color? color) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

// snackbar
showSnackBar(BuildContext context, String msg, color) {
  var snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: color,
    duration: const Duration(milliseconds: 2000),
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void toastShort(String msg, Color color) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
