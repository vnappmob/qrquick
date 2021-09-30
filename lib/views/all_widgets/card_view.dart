import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({
    Key? key,
    this.headTitle,
    this.headLeading,
    this.headTrailing,
    this.headSub,
    this.margin,
    this.padding,
    this.colors,
    this.child,
  }) : super(key: key);
  final Widget? headTitle;
  final Widget? headLeading;
  final Widget? headTrailing;
  final Widget? headSub;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<Color>? colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: colors ?? [Colors.transparent, Colors.transparent],
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: margin ?? const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: headTitle != null ? 45 : 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: Colors.transparent.withOpacity(0.3),
              ),
              child: Row(
                children: [
                  Expanded(child: headLeading ?? Container(), flex: 1),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: headTitle ?? Container(),
                    ),
                  ),
                  Expanded(child: headTrailing ?? Container(), flex: 1),
                ],
              ),
            ),
            headSub ?? Container(),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                width: double.infinity,
                padding: padding ?? const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(0.1),
                  borderRadius: headTitle != null
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )
                      : BorderRadius.circular(15),
                ),
                child: child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
