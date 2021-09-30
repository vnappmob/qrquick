import 'package:flutter/material.dart';

class BottomBarClipper extends CustomClipper<Path> {
  BottomBarClipper({required this.centerSize});
  final double centerSize;
  final double thickness = 0.3;
  late Radius radius;

  @override
  Path getClip(Size size) {
    radius = Radius.circular(centerSize / 3);
    final path = Path();
    path.moveTo(0, size.height / 3);
    path.arcToPoint(Offset(size.height / 3, 0),
        clockwise: true, radius: radius);
    path.lineTo(size.width / 2 - (centerSize / 2 + thickness), 0);

    path.arcToPoint(Offset(size.width / 2 + (centerSize / 2 + thickness), 0),
        clockwise: false, radius: radius);

    path.lineTo(size.width - (size.height / 3), 0);
    path.arcToPoint(Offset(size.width, size.height / 3),
        clockwise: true, radius: radius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
