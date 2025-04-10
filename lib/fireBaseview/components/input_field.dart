import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseview/components/attachment_bottom_sheet.dart';

// class MessageInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final VoidCallback onSend;
//   final VoidCallback onVoiceMsgSend;
//   //final bool isTyping;
//   final String senderId;
//   final String receiverId;

//   const MessageInputField({
//     Key? key,
//     required this.controller,
//     required this.onSend,
//     required this.onVoiceMsgSend,
//     //required this.isTyping,
//     required this.senderId,
//     required this.receiverId,
//   }) : super(key: key);

//   @override
//   State<MessageInputField> createState() => _MessageInputFieldState();
// }

// class _MessageInputFieldState extends State<MessageInputField> {
//   bool isTyping = false;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: TextFormField(
//                   controller: widget.controller,
//                   textAlignVertical: TextAlignVertical.center,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   onChanged: (text) {
//                     if (isTyping != text.isNotEmpty) {
//                       setState(() {
//                         isTyping = text.isNotEmpty;
//                       });
//                     }
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Type a message",
//                     border: InputBorder.none,
//                     prefixIcon: IconButton(
//                       onPressed: () {},
//                       icon: Icon(Icons.emoji_emotions),
//                       color: Colors.grey,
//                     ),
//                     suffixIcon: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               showModalBottomSheet(
//                                   backgroundColor: Colors.transparent,
//                                   context: context,
//                                   builder: (builder) => AttachmentBottomSheet(
//                                         senderId: widget.senderId,
//                                         receiverId: widget.receiverId,
//                                       ));
//                             },
//                             icon: Icon(Icons.attach_file)),
//                         IconButton(
//                             onPressed: () {}, icon: Icon(Icons.camera_alt)),
//                       ],
//                     ),
//                     contentPadding: EdgeInsets.symmetric(vertical: 10),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 5),
//           Padding(
//             padding: const EdgeInsets.only(right: 5, bottom: 2),
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.teal,
//               child: IconButton(
//                   icon: Icon(isTyping ? Icons.send : Icons.mic,
//                       color: Colors.white),
//                   onPressed: () {
//                     if (isTyping) {
//                       widget.onSend();
//                       widget.controller.clear();
//                       setState(() {
//                         isTyping = false;
//                       });
//                     }
//                     widget.onVoiceMsgSend();
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final VoidCallback onSend;
//   final Function(String path) onVoiceMsgSend;
//   final String senderId;
//   final String receiverId;

//   const MessageInputField({
//     Key? key,
//     required this.controller,
//     required this.onSend,
//     required this.onVoiceMsgSend,
//     required this.senderId,
//     required this.receiverId,
//   }) : super(key: key);

//   @override
//   State<MessageInputField> createState() => _MessageInputFieldState();
// }

// class _MessageInputFieldState extends State<MessageInputField> {
//   bool isTyping = false;
//   bool isRecording = false;
//   final AudioRecorder _audioRecorder = AudioRecorder();
//   String? _audioPath;
//   Timer? _timer;
//   int _recordDuration = 0;

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _audioRecorder.dispose();
//     super.dispose();
//   }

//   Future<void> _startRecording() async {
//     if (await _audioRecorder.hasPermission()) {
//       final dir = await getTemporaryDirectory();
//       final filePath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

//       await _audioRecorder.start(const RecordConfig(),path: filePath);
//       setState(() {
//         isRecording = true;
//         _recordDuration = 0;
//         _audioPath = filePath;
//       });

//       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//         setState(() {
//           _recordDuration++;
//         });
//       });
//     }
//   }

//   Future<void> _stopRecording({bool send = true}) async {
//     _timer?.cancel();
//     _timer = null;

//     final path = await _audioRecorder.stop();
//     setState(() {
//       isRecording = false;
//       _recordDuration = 0;
//     });

//     if (send && path != null && File(path).existsSync()) {
//       widget.onVoiceMsgSend(path);
//     }
//   }

//   String _formatDuration(int seconds) {
//     final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
//     final secs = (seconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$secs';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: isRecording
//                 ? Container(
//                     padding: EdgeInsets.only(left: 10, right: 10),
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 250, 250, 250),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.mic, color: Colors.red),
//                         SizedBox(width: 8),
//                         Text(
//                           _formatDuration(_recordDuration),
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         Spacer(),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.grey[700]),
//                           onPressed: () => _stopRecording(send: false),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.send, color: Colors.teal),
//                           onPressed: () => _stopRecording(send: true),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Card(
//                     elevation: 5,
//                     color: const Color.fromARGB(255, 250, 250, 250),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: TextFormField(
//                         controller: widget.controller,
//                         textAlignVertical: TextAlignVertical.center,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         onChanged: (text) {
//                           setState(() => isTyping = text.isNotEmpty);
//                         },
//                         decoration: InputDecoration(
//                           hintText: "Type a message",
//                           border: InputBorder.none,
//                           prefixIcon: IconButton(
//                             onPressed: () {},
//                             icon: Icon(Icons.emoji_emotions),
//                           ),
//                           suffixIcon: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                     backgroundColor: Colors.transparent,
//                                     context: context,
//                                     builder: (_) => AttachmentBottomSheet(
//                                       senderId: widget.senderId,
//                                       receiverId: widget.receiverId,
//                                     ),
//                                   );
//                                 },
//                                 icon: Icon(Icons.attach_file),
//                               ),
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(Icons.camera_alt),
//                               ),
//                             ],
//                           ),
//                           contentPadding: EdgeInsets.symmetric(vertical: 10),
//                         ),
//                       ),
//                     ),
//                   ),
//           ),
//           SizedBox(width: 5),
//           Padding(
//             padding: const EdgeInsets.only(right: 5, bottom: 2),
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor:  Colors.teal,
//               child: isTyping
//                   ? IconButton(
//                       icon: Icon(Icons.send, color: Colors.white),
//                       onPressed: () {
//                         widget.onSend();
//                         widget.controller.clear();
//                         setState(() => isTyping = false);
//                       },
//                     )
//                   : IconButton(
//                       icon: Icon(isRecording ? Icons.stop : Icons.mic,
//                           color: Colors.white),
//                       onPressed: () {
//                         if (!isRecording) {
//                           _startRecording();
//                         }
//                       },
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class MessageInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final Function(String path) onVoiceMsgSend;
  final String senderId;
  final String receiverId;

  const MessageInputField({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onVoiceMsgSend,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool isTyping = false;
  bool isRecording = false;
  Offset _initialDragOffset = Offset.zero;
  Timer? _timer;
  int _recordDuration = 0;
  String? _audioPath;

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(const RecordConfig(), path: filePath);

      setState(() {
        isRecording = true;
        _recordDuration = 0;
        _audioPath = filePath;
      });

      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          _recordDuration++;
        });
      });
    }
  }

  Future<void> _stopRecording({bool send = true}) async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();

    setState(() {
      isRecording = false;
      _recordDuration = 0;
      _audioPath = null;
    });

    if (send && path != null && File(path).existsSync()) {
      widget.onVoiceMsgSend(path);
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: isRecording
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mic, color: Colors.red),
                        SizedBox(width: 8),
                        Text(_formatDuration(_recordDuration)),
                        Spacer(),
                        Text("Slide left to cancel",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  )
                : _buildTextInput(),
          ),
          SizedBox(width: 5),
          _buildMicButton(),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 250, 250, 250),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: widget.controller,
          maxLines: null,
          onChanged: (text) => setState(() => isTyping = text.isNotEmpty),
          decoration: InputDecoration(
            hintText: "Type a message",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.emoji_emotions),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AttachmentBottomSheet(
                        senderId: widget.senderId,
                        receiverId: widget.receiverId,
                      ),
                    );
                  },
                  icon: Icon(Icons.attach_file),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt),
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressMoveUpdate: (details) {
        if (_initialDragOffset == Offset.zero) {
          _initialDragOffset = details.globalPosition;
        }

        final dx = details.globalPosition.dx - _initialDragOffset.dx;

        if (dx < -80) {
          // Swiped left far enough
          _stopRecording(send: false);
          _initialDragOffset = Offset.zero;
        }
      },
      onLongPressEnd: (_) {
        if (isRecording) {
          _stopRecording(send: true);
          _initialDragOffset = Offset.zero;
        }
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.teal,
        child: isTyping
            ? IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  widget.onSend();
                  widget.controller.clear();
                  setState(() => isTyping = false);
                },
              )
            : IconButton(
                icon: Icon(isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white),
                onPressed: () {
                  if (!isRecording) {
                    _startRecording();
                  }
                },
              ),
      ),
    );
  }
}
