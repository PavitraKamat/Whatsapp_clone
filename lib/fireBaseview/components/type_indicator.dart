// import 'package:flutter/material.dart';

// class TypeIndicator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _dot(),
//         SizedBox(width: 4),
//         _dot(delay: 200),
//         SizedBox(width: 4),
//         _dot(delay: 400),
//       ],
//     );
//   }

//   Widget _dot({int delay = 0}) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.3, end: 1.0),
//       duration: Duration(milliseconds: 800),
//       curve: Curves.easeInOut,
//       builder: (context, opacity, child) {
//         return Opacity(
//           opacity: opacity,
//           child: child,
//         );
//       },
//       onEnd: () {
//         if (delay == 0) return;
//       },
//       child: Container(
//         width: 8,
//         height: 8,
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }


import 'dart:math';

import 'package:flutter/material.dart';

class TypeIndicator extends StatefulWidget {
  const TypeIndicator({Key? key}) : super(key: key);

  @override
  _TypeIndicatorState createState() => _TypeIndicatorState();
}

class _TypeIndicatorState extends State<TypeIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double bounce = sin((_controller.value * 6.28) +
                        (index * 1.0)) *
                    4;
                return Transform.translate(
                  offset: Offset(0, bounce),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
