import 'package:flutter/material.dart';

class TrapeziumClipper extends CustomClipper<Path> {
  final double cornerRadius;

  TrapeziumClipper({required this.cornerRadius});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.arcToPoint(
      Offset(size.width - 10, 5),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(size.width - 15, size.height - 5);
    path.arcToPoint(
      Offset(size.width - 25, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.lineTo(25, size.height);
    path.arcToPoint(
      Offset(15, size.height - 5),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.lineTo(10, 5);
    path.arcToPoint(
      const Offset(0, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
