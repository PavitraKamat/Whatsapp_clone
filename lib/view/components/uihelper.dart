import 'package:flutter/material.dart';

class UiHelper {
  static CustomButton(
      {required VoidCallback callback,
      required String buttonname,
      Color? backgroundColor,
      Color? textColor,
      Widget? icon}) {
    return SizedBox(
      height: 45,
      width: 350,
      child: ElevatedButton(
        onPressed: () {
          callback();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00A884),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon,
              SizedBox(width:3),
            ],
            Text(
              buttonname,
              style: TextStyle(
                fontSize: 15,
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // child: Text(
        //   buttonname,
        //   style: TextStyle(fontSize: 14, color: Colors.white),
        // )
      ),
    );
  }

  static CustomText(
      {required String text,
      required double height,
      Color? color,
      FontWeight? fontweight}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: height,
          color: color ?? Color(0XFF5E5E5E),
          fontWeight: fontweight),
    );
  }

  static CustomContainer(TextEditingController controller) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0XFFD9D9D9)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
