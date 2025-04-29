import 'package:flutter/material.dart';

class TextStatusProvider with ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  double keyboardHeight = 0;
  Color backgroundColor = Colors.brown[300]!;

  final List<Color> colors = [    
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.brown[300]!,
  ];

  TextStatusProvider() {
    focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    notifyListeners();
  }

  void changeBackgroundColor() {
    colors.shuffle();
    backgroundColor = colors.first;
    notifyListeners();
  }

  void updateKeyboardHeight(BuildContext context) {
    keyboardHeight = focusNode.hasFocus
        ? MediaQuery.of(context).viewInsets.bottom
        : 0;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    super.dispose();
  }
}
