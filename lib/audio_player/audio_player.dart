import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'utils.dart';

part 'control_buttons.dart';

part 'position_data.dart';

part 'seek_bar.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String? url;
  final String? path;
  final String? thumbnailUrl;
  final int mediaId;
  final bool autoPlay;

  const AudioPlayerWidget({
    super.key,
    this.url,
    this.path,
    this.thumbnailUrl = "",
    required this.mediaId,
    this.autoPlay = false,
  });

  @override
  createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with WidgetsBindingObserver {
  // var showControls = true;
  // var isFirstLaunch = true;
  // var isBrowserFullScreen = true;
  final _player = AudioPlayer();

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playingStream.listen((isPlaying) {
      if (isPlaying) {
        // widget.controller?.play(widget.mediaId);
      }
    });
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      if (kDebugMode) {
        print('A stream error occurred: $e');
      }
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      if (isNotEmpty(widget.url)) {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.url!)));
      } else if (isNotEmpty(widget.path)) {
        await _player.setAudioSource(AudioSource.asset(widget.path!));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio source: $e");
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<_PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, _PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => _PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
    if (widget.mediaId != 0) {
      // widget.controller?.playingId.listen((id) async {
      //   if (_player.playing && id != widget.mediaId) _player.pause();
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: widget.thumbnailUrl ?? '',
            errorWidget: (ctx, url, error) => const Icon(
              Icons.music_note,
              color: Colors.black45,
              size: 70,
            ),
          ),
        ),
        // Display play/pause button and volume/speed sliders.
        Positioned(
          bottom: 0,
          left: 24,
          right: 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _ControlButtons(_player),
              ),
              Expanded(
                child: StreamBuilder<_PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return _SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }
}
