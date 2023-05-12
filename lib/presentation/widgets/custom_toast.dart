import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showErrorToast({
  required BuildContext context,
  required String error,
}) async {
  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 10,
        ),
        child: Text(
          error,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Future<void> showToast({
  required BuildContext context,
  required String message,
}) async {
  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 10,
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
