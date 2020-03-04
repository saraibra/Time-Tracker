import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final double height;
  final VoidCallback onPressed;
  CustomRaisedButton(
      { @required this.child,
        @required this.color,
        this.radius: 2.0,
        this.height:50.0,
        @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: double.infinity,
      child: RaisedButton(
        child: child,
        onPressed: onPressed,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius))),
      ),
    );
  }
}
