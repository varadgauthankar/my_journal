import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/helpers.dart';

class ExceptionWidget extends StatelessWidget {
  final bool isError;
  final bool isLabel;
  const ExceptionWidget({Key? key, this.isError = false, this.isLabel = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isError
              ? const Icon(
                  EvaIcons.alertTriangleOutline,
                  size: 80,
                  color: Colors.amberAccent,
                )
              : SvgPicture.asset(
                  'assets/empty.svg',
                  height: 100,
                ),
          spacer(height: 12),
          Text(
            isError
                ? 'Something went wrong!'
                : isLabel
                    ? 'No labels'
                    : 'No journals!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: isError ? FontWeight.w500 : FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
