import 'package:flutter/material.dart';

class TypeIndicator extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(),
        SizedBox(width: 4),
        _dot(delay: 200),
        SizedBox(width: 4),
        _dot(delay: 400),
      ],
    );
  }

  Widget _dot({int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      onEnd: () {
        if (delay == 0) return;
      },
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
