import 'package:flutter/material.dart';

Widget spacer({double? height, double? width}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
  );
}

void goToPage(BuildContext context, {required Widget page}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: ((context) => page)),
  );
}

void replacePage(BuildContext context, {required Widget page}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: ((context) => page)),
  );
}
