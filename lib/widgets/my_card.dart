import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            width: double.maxFinite,
            child: child,
          ),
        ),
      ),
    );
  }
}
