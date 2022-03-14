import 'package:flutter/material.dart';
import 'package:my_journal/utils/helpers.dart';

class MyCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final double? height;

  const MyCard({
    Key? key,
    required this.onTap,
    required this.child,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 2.2,
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          splashColor: Theme.of(context).colorScheme.surfaceVariant,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            width: double.maxFinite,
            // height: height ?? 100,
            child: child,
          ),
        ),
      ),
    );
  }
}
