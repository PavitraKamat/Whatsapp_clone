import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/text_status_provider.dart';

// class TextStatusScreen extends StatefulWidget {
//   @override
//   _TextStatusScreenState createState() => _TextStatusScreenState();
// }
// class _TextStatusScreenState extends State<TextStatusScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   Color backgroundColor = Colors.brown[300]!;
//   List<Color> colors = [
//     Colors.black,
//     Colors.blue,
//     Colors.green,
//     Colors.red,
//     Colors.orange,
//     Colors.purple,
//     Colors.brown[300]!,
//   ];
//   double _keyboardHeight = 0;
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() { 
//       setState(() {
//         _keyboardHeight =
//             _focusNode.hasFocus ? MediaQuery.of(context).viewInsets.bottom : 0;
//       });
//     });
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: TextField(
//                 controller: _controller,
//                 focusNode: _focusNode,
//                 textAlign: TextAlign.center,
//                 maxLines: null,
//                 autofocus: true,
//                 style: TextStyle(fontSize: 28, color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: "Type a status",
//                   hintStyle: TextStyle(color: Colors.white54, fontSize: 26),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 50,
//             left: 10,
//             child: IconButton(
//               icon: Icon(Icons.close, color: Colors.white, size: 30),
//               onPressed: () => Navigator.pop(context, _controller.text),
//             ),
//           ),
//           Positioned(
//             top: 50,
//             right: 10,
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.text_fields, color: Colors.white, size: 30),
//                   onPressed: () {
//                     // Implement text style change logic here
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.palette, color: Colors.white, size: 30),
//                   onPressed: () {
//                     setState(() {
//                       backgroundColor = (colors..shuffle()).first;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: _keyboardHeight,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon:
//                         Icon(Icons.video_call, color: Colors.white70, size: 30),
//                     onPressed: () {
//                       // Implement video status selection
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.photo, color: Colors.white70, size: 30),
//                     onPressed: () {
//                       // Implement photo status selection
//                     },
//                   ),

//                   // Text Option
//                   IconButton(
//                     icon: Icon(Icons.text_snippet,
//                         color: Colors.white70, size: 30),
//                     onPressed: () {
//                       // Implement text status selection
//                     },
//                   ),

//                   FloatingActionButton(
//                       backgroundColor: Colors.green,
//                       mini: true,
//                       child: Icon(Icons.send, color: Colors.white),
//                       onPressed: () {
//                         if (_controller.text.trim().isNotEmpty) {
//                           Navigator.pop(context, 
//                           {
//                             'text': _controller.text.trim(),
//                             'color': backgroundColor,
//                           }
//                           );
//                         }
//                       }),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



class TextStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TextStatusProvider>(context);
    provider.updateKeyboardHeight(context);

    return Scaffold(
      backgroundColor: provider.backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: provider.controller,
                focusNode: provider.focusNode,
                textAlign: TextAlign.center,
                maxLines: null,
                autofocus: true,
                style: TextStyle(fontSize: 28, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type a status",
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 26),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () =>
                  Navigator.pop(context, provider.controller.text),
            ),
          ),
          Positioned(
            top: 50,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.text_fields, color: Colors.white, size: 30),
                  onPressed: () {
                    // Add text style logic
                  },
                ),
                IconButton(
                  icon: Icon(Icons.palette, color: Colors.white, size: 30),
                  onPressed: provider.changeBackgroundColor,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: provider.keyboardHeight,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration:
                  BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.video_call,
                        color: Colors.white70, size: 30),
                    onPressed: () {
                      // Video logic
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.photo, color: Colors.white70, size: 30),
                    onPressed: () {
                      // Photo logic
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.text_snippet,
                        color: Colors.white70, size: 30),
                    onPressed: () {
                      // Text logic
                    },
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    mini: true,
                    child: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (provider.controller.text.trim().isNotEmpty) {
                        Navigator.pop(context, {
                          'text': provider.controller.text.trim(),
                          'color': provider.backgroundColor,
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
