import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as just;
import 'package:path_provider/path_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';
import 'package:http/http.dart' as http;

class AudioMessageProvider extends ChangeNotifier {
  final MessageModel message;
  final bool isSentByUser;

  final just.AudioPlayer _player = just.AudioPlayer();
  PlayerController? _waveController;
  StreamSubscription<just.PlayerState>? _playerStateSub;

  bool isPlaying = false;
  bool isWaveformReady = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  AudioMessageProvider({
    required this.message,
    required this.isSentByUser,
  }) {
    _initAudioPlayer();
    //_tryInitWaveform();
  }

  PlayerController? get waveController => _waveController;
  just.AudioPlayer get player => _player;

  Future<void> _initAudioPlayer() async {
    try {
      final url = message.mediaUrl;
      if (url == null) return;
      await _player.setUrl(url);

      _playerStateSub = _player.playerStateStream.listen((state) {
        if (state.processingState == just.ProcessingState.completed) {
          _player.seek(Duration.zero);
          _player.stop();
          isPlaying = false;
          notifyListeners();
        }

        if (state.playing != isPlaying) {
          isPlaying = state.playing;
          notifyListeners();
        }
      });

      _player.positionStream.listen((pos) {
        position = pos;
        notifyListeners();
      });

      _player.durationStream.listen((dur) {
        if (dur != null) {
          duration = dur;
          notifyListeners();
        }
      });
    } catch (_) {}
  }

  // Future<void> _tryInitWaveform() async {
  //   try {
  //     final url = message.mediaUrl;
  //     if (url == null || !url.startsWith("http")) return;

  //     _waveController = PlayerController();
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final tempDir = await getTemporaryDirectory();
  //       final tempFile =
  //           File('${tempDir.path}/temp_audio_${message.messageId}.aac');
  //       await tempFile.writeAsBytes(response.bodyBytes);

  //       await _waveController!.preparePlayer(
  //         path: tempFile.path,
  //         noOfSamples: 50,
  //       );

  //       isWaveformReady = true;
  //       notifyListeners();
  //     }
  //   } catch (_) {}
  // }

  Future<void> togglePlayback() async {
    try {
      if (isPlaying) {
        await _player.pause();
        if (_waveController != null && isWaveformReady) {
          await _waveController!.pausePlayer();
        }
        isPlaying = false;
      } else {
        await _player.play();
        if (_waveController != null && isWaveformReady) {
          await _waveController!.startPlayer();
        }
        isPlaying = true;
      }
      notifyListeners();
    } catch (_) {}
  }

  void disposePlayer() {
    _playerStateSub?.cancel();
    _player.dispose();
    _waveController?.dispose();
  }

  double get progressPercent {
    return duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;
  }

  String get formattedDuration {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
