import 'package:flutter/material.dart';

class AccountLogo extends StatelessWidget {
  AccountLogo({
    Key? key,
    this.textColor = Colors.black,
    required this.character,
    this.size = 50,
  }) : super(key: key);
  final Color textColor;
  final String character;
  final double size;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: textColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            character.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: size * 0.7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
