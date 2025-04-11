import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as just;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';
import 'package:http/http.dart' as http;

class AudioMessageBubble extends StatefulWidget {
  final MessageModel message;
  final double maxWidth;
  final bool isSentByUser;
  final bool isRead;

  const AudioMessageBubble({
    required this.message,
    required this.maxWidth,
    required this.isSentByUser,
    required this.isRead,
    super.key,
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  late just.AudioPlayer _player;
  PlayerController? _waveController;
  StreamSubscription<just.PlayerState>? _playerStateSub;
  bool isPlaying = false;
  bool isWaveformReady = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = just.AudioPlayer();

    // Initialize audio player and try to setup waveform
    _initAudioPlayer();
    _tryInitWaveform();
  }

  Future<void> _initAudioPlayer() async {
    try {
      // Setup basic audio player
      final url = widget.message.mediaUrl!;
      await _player.setUrl(url);

      // Listen to player state changes
      _playerStateSub = _player.playerStateStream.listen((state) {
        if (state.processingState == just.ProcessingState.completed) {
          // When playback is complete, reset to beginning and show play icon
          if (mounted) {
            setState(() => isPlaying = false);
          }
          _player.seek(Duration.zero); // Reset position to beginning
          _player.stop();
        }

        // Update play/pause state based on player state
        if (state.playing != isPlaying && mounted) {
          setState(() => isPlaying = state.playing);
        }
      });

      // Listen to position updates
      _player.positionStream.listen((position) {
        if (mounted) {
          setState(() => _position = position);
        }
      });

      // Get duration
      _player.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() => _duration = duration);
        }
      });
    } catch (e) {
      debugPrint("Error initializing audio player: $e");
    }
  }

  Future<void> _tryInitWaveform() async {
    // Optional waveform setup - we'll show fallback UI if this fails
    try {
      _waveController = PlayerController();

      final url = widget.message.mediaUrl!;
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile =
            File('${tempDir.path}/temp_audio_${widget.message.messageId}.aac');
        await tempFile.writeAsBytes(response.bodyBytes);

        // Use lower values and simpler setup to reduce chances of errors
        await _waveController!.preparePlayer(
          path: tempFile.path,
          noOfSamples: 50,
        );

        if (mounted) {
          setState(() => isWaveformReady = true);
        }
      }
    } catch (e) {
      debugPrint("Waveform initialization failed: $e");
      // We'll use fallback UI, so no need to handle this error
    }
  }

  Future<void> _togglePlayback() async {
    try {
      if (isPlaying) {
        // Pause audio and update UI to show play icon
        await _player.pause();
        if (_waveController != null && isWaveformReady) {
          _waveController!.pausePlayer().catchError((e) {
            debugPrint("Error pausing waveform: $e");
          });
        }
        if (mounted) {
          setState(() => isPlaying = false);
        }
      } else {
        // Play audio and update UI to show pause icon
        await _player.play();
        if (_waveController != null && isWaveformReady) {
          _waveController!.startPlayer().catchError((e) {
            debugPrint("Error starting waveform: $e");
          });
        }
        if (mounted) {
          setState(() => isPlaying = true);
        }
      }
    } catch (e) {
      debugPrint('Error toggling playback: $e');
    }
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _player.dispose();
    _waveController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isSentByUser ? Colors.white : Colors.black87;
    final backgroundColor = widget.isSentByUser
        ? const Color.fromARGB(255, 169, 230, 174)
        : Colors.white;

    // Calculate progress percent for the fallback progress bar
    final progressPercent = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft:
              widget.isSentByUser ? const Radius.circular(16) : Radius.zero,
          bottomRight:
              widget.isSentByUser ? Radius.zero : const Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Play/Pause Button with proper icon toggling
          InkWell(
            onTap: _togglePlayback,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.isSentByUser
                    ? Colors.white.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: textColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Content area with waveform or fallback
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waveform or fallback progress bar
                SizedBox(
                  height: 25,
                  child: isWaveformReady && _waveController != null
                      ? AudioFileWaveforms(
                          size: const Size(double.infinity, 35),
                          playerController: _waveController!,
                          enableSeekGesture: true,
                          waveformType: WaveformType.fitWidth,
                          playerWaveStyle: PlayerWaveStyle(
                            fixedWaveColor: widget.isSentByUser
                                ? Colors.white.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.7),
                            liveWaveColor: widget.isSentByUser
                                ? Colors.white
                                : Colors.blue,
                            spacing: 4,
                            showSeekLine: false,
                            waveCap: StrokeCap.round,
                            waveThickness: 3,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Fallback UI - simple progress bar
                            LinearProgressIndicator(
                              value: progressPercent,
                              backgroundColor: widget.isSentByUser
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                              color: widget.isSentByUser
                                  ? Colors.white
                                  : Colors.blue,
                              minHeight: 5,
                            ),
                          ],
                        ),
                ),

                //const SizedBox(height: 1),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.message.audioDuration != null)
                      Text(
                        "${widget.message.audioDuration}s",
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
                      ),
                    Row(
                      children: [
                        Text(
                          DateFormat.jm().format(widget.message.timestamp),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54),
                        ),
                        if (widget.isSentByUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: messageStatusIcon(widget.message),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messageStatusIcon(MessageModel message) {
    if (message.isRead) {
      return Icon(Icons.done_all, color: Colors.blue, size: 12);
    } else if (message.isDelivered) {
      return Icon(Icons.done_all, color: Colors.grey, size: 12);
    } else {
      return Icon(Icons.done, color: Colors.grey, size: 12);
    }
  }
}
