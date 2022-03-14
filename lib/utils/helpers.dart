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

void showSnackbar(BuildContext context, String text) {
  WidgetsBinding.instance!.addPostFrameCallback(
    ((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }),
  );
}

Widget myCircularProgressIndicator({double? size}) {
  return SizedBox(
    height: size,
    width: size,
    child: const CircularProgressIndicator(),
  );
}

ColorScheme getColorScheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}
