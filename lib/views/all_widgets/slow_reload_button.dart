import 'dart:async';

import 'package:flutter/material.dart';

class SlowReloadButton extends StatefulWidget {
  SlowReloadButton({
    Key? key,
    required this.onPressed,
    this.duration,
    this.color,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Duration? duration;
  final Color? color;

  @override
  State<StatefulWidget> createState() {
    return _SlowReloadButtonState();
  }
}

class _SlowReloadButtonState extends State<SlowReloadButton> {
  bool available = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return available
        ? IconButton(
            icon: Icon(
              Icons.refresh,
              color: widget.color ?? Colors.white,
            ),
            onPressed: () {
              Timer(widget.duration ?? Duration(seconds: 30), () {
                if (mounted) {
                  setState(() {
                    available = true;
                  });
                }
              });
              setState(() {
                available = false;
                widget.onPressed!.call();
              });
            })
        : Container();
  }
}
