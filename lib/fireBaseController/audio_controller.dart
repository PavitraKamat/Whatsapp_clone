// import 'dart:async';
// import 'dart:io';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:just_audio/just_audio.dart' as just;
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';
// import 'package:http/http.dart' as http;

// class AudioController extends ChangeNotifier {
//   final MessageModel message;
//   final bool isSentByUser;

//   // Playback variables
//   final just.AudioPlayer _player = just.AudioPlayer();
//   PlayerController? _waveController;
//   StreamSubscription<just.PlayerState>? _playerStateSub;
//   bool isPlaying = false;
//   bool isWaveformReady = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   Offset _initialDragOffset = Offset.zero;

//   PlayerController? get waveController => _waveController;
//   just.AudioPlayer get player => _player;
//   Offset get initialDragOffset => _initialDragOffset;

//   // Recording variables
//   FlutterSoundRecorder? _recorder;
//   bool isRecording = false;
//   bool isCancelled = false;
//   int recordDuration = 0;
//   String? recordedFilePath;
//   Timer? _timer;

//   // Initialization
//   AudioController({
//     required this.message,
//     required this.isSentByUser,
//   }) {
//     _initAudioPlayer();
//     _tryInitWaveform();
//   }

//   // Playback methods...
//   Future<void> _initAudioPlayer() async {
//     try {
//       final url = message.mediaUrl;
//       if (url == null) return;
//       await _player.setUrl(url);

//       _playerStateSub = _player.playerStateStream.listen((state) {
//         if (state.processingState == just.ProcessingState.completed) {
//           _player.seek(Duration.zero);
//           _player.stop();
//           isPlaying = false;
//           notifyListeners();
//         }

//         if (state.playing != isPlaying) {
//           isPlaying = state.playing;
//           notifyListeners();
//         }
//       });

//       _player.positionStream.listen((pos) {
//         position = pos;
//         notifyListeners();
//       });

//       _player.durationStream.listen((dur) {
//         if (dur != null) {
//           duration = dur;
//           notifyListeners();
//         }
//       });
//     } catch (_) {}
//   }

//   Future<void> _tryInitWaveform() async {
//     try {
//       final url = message.mediaUrl;
//       if (url == null || !url.startsWith("http")) return;

//       _waveController = PlayerController();
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final tempDir = await getTemporaryDirectory();
//         final tempFile =
//             File('${tempDir.path}/temp_audio_${message.messageId}.aac');
//         await tempFile.writeAsBytes(response.bodyBytes);

//         await _waveController!.preparePlayer(
//           path: tempFile.path,
//           noOfSamples: 50,
//         );

//         isWaveformReady = true;
//         notifyListeners();
//       }
//     } catch (_) {}
//   }

//   Future<void> togglePlayback() async {
//     try {
//       if (isPlaying) {
//         await _player.pause();
//         if (_waveController != null && isWaveformReady) {
//           await _waveController!.pausePlayer();
//         }
//         isPlaying = false;
//       } else {
//         await _player.play();
//         if (_waveController != null && isWaveformReady) {
//           await _waveController!.startPlayer();
//         }
//         isPlaying = true;
//       }
//       notifyListeners();
//     } catch (_) {}
//   }

//   double get progressPercent {
//     return duration.inMilliseconds > 0
//         ? position.inMilliseconds / duration.inMilliseconds
//         : 0.0;
//   }

//   String get formattedDuration {
//     final minutes = duration.inMinutes.toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return "$minutes:$seconds";
//   }

//   void setInitialDragOffset(Offset offset) {
//   _initialDragOffset = offset;
// }

// void resetInitialDragOffset() {
//   _initialDragOffset = Offset.zero;
// }


//   // Recording methods...
//   Future<void> startRecording() async {
//     try {
//       isRecording = true;
//       isCancelled = false;
//       recordDuration = 0;
//       notifyListeners();

//       final dir = await getApplicationDocumentsDirectory();
//       final filePath = "${dir.path}/recorded_${DateTime.now().millisecondsSinceEpoch}.m4a";

//       _recorder = FlutterSoundRecorder();
//       await _recorder!.openRecorder();
//       await _recorder!.startRecorder(toFile: filePath, codec: Codec.aacMP4);

//       recordedFilePath = filePath;

//       _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//         recordDuration++;
//         notifyListeners();
//       });
//     } catch (e) {
//       print("Error starting recorder: $e");
//     }
//   }

//   Future<String?> stopRecording() async {
//     try {
//       _timer?.cancel();
//       await _recorder?.stopRecorder();
//       await _recorder?.closeRecorder();
//       isRecording = false;
//       notifyListeners();

//       if (!isCancelled && recordedFilePath != null) {
//         String path = recordedFilePath!;
//         recordedFilePath = null;
//         recordDuration = 0;
//         return path;
//       }

//       recordedFilePath = null;
//       recordDuration = 0;
//       return null;
//     } catch (e) {
//       print("Error stopping recorder: $e");
//       return null;
//     }
//   }

//   Future<void> cancelRecording() async {
//     try {
//       isCancelled = true;
//       _timer?.cancel();
//       await _recorder?.stopRecorder();
//       await _recorder?.closeRecorder();
//       recordedFilePath = null;
//       isRecording = false;
//       notifyListeners();
//     } catch (e) {
//       print("Error canceling recorder: $e");
//     }
//   }

//   Future<int> getAudioDuration(File file) async {
//     final player = AudioPlayer();
//     try {
//       await player.setFilePath(file.path);
//       await Future.delayed(Duration(milliseconds: 500)); // allow loading
//       final duration = player.duration;
//       return duration?.inSeconds ?? 0;
//     } catch (e) {
//       print("Failed to get duration: $e");
//       return 0;
//     } finally {
//       await player.dispose();
//     }
//   }
  

//   // Shared dispose logic
//   @override
//   void dispose() {
//     _playerStateSub?.cancel();
//     _player.dispose();
//     _waveController?.dispose();
//     _recorder?.closeRecorder();
//     _timer?.cancel();
//     super.dispose();
//   }
// }
