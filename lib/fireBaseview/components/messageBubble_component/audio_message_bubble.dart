import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/audio_message_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';
import 'package:wtsp_clone/fireBaseview/components/messageBubble_component/message_status_icon.dart';

class AudioMessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSentByUser;

  const AudioMessageBubble({
    required this.message,
    required this.isSentByUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioMessageProvider(
        message: message,
        isSentByUser: isSentByUser,
      ),
      child: Consumer<AudioMessageProvider>(
        builder: (context, provider, _) {
          final textColor = isSentByUser ? Colors.white : Colors.black87;
          final backgroundColor = isSentByUser
              ? const Color.fromARGB(255, 169, 230, 174)
              : Colors.white;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isSentByUser ? const Radius.circular(16) : Radius.zero,
                bottomRight:
                    isSentByUser ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Play/Pause Button with proper icon toggling
                InkWell(
                  onTap: provider.togglePlayback,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSentByUser
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      provider.isPlaying ? Icons.pause : Icons.play_arrow,
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
                        child: provider.isWaveformReady &&
                                provider.waveController != null
                            ? AudioFileWaveforms(
                                size: const Size(double.infinity, 35),
                                playerController: provider.waveController!,
                                enableSeekGesture: true,
                                waveformType: WaveformType.fitWidth,
                                playerWaveStyle: PlayerWaveStyle(
                                  fixedWaveColor: isSentByUser
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : Colors.grey.withValues(alpha: 0.7),
                                  liveWaveColor:
                                      isSentByUser ? Colors.white : Colors.blue,
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
                                    value: provider.progressPercent,
                                    backgroundColor: isSentByUser
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : Colors.grey.withValues(alpha: 0.3),
                                    color: isSentByUser
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
                          if (message.audioDuration != null)
                            Text(
                              "${message.audioDuration}s",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                          Row(
                            children: [
                              Text(
                                DateFormat.jm().format(message.timestamp),
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black54),
                              ),
                              if (isSentByUser)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: MessageStatusIcon(message: message),
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
        },
      ),
    );
  }
}
