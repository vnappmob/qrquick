import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveItem extends StatelessWidget {
  RiveItem({
    Key? key,
    required this.mediaUrl,
  }) : super(key: key);

  final String mediaUrl;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Center(
        child: RiveAnimation.asset(
          mediaUrl,
          animations: ['runLoop'],
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
