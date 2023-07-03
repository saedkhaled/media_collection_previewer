part of 'audio_player.dart';

/// Displays the play/pause button and volume/speed sliders.
class _ControlButtons extends StatefulWidget {
  final AudioPlayer player;

  const _ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  State<_ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<_ControlButtons> {
  var _showVolume = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: widget.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 20.0,
                child: const CircularProgressIndicator(
                  color: Colors.black45,
                ),
              );
            } else if (playing != true) {
              return InkWell(
                onTap: widget.player.play,
                child: const Icon(
                  Icons.play_arrow,
                  size: 20.0,
                  color: Colors.black45,
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return InkWell(
                onTap: widget.player.pause,
                child: const Icon(
                  Icons.pause,
                  size: 20.0,
                  color: Colors.black45,
                ),
              );
            } else {
              return InkWell(
                onTap: () => widget.player.seek(Duration.zero),
                child: const Icon(
                  Icons.replay,
                  size: 20.0,
                  color: Colors.black45,
                ),
              );
            }
          },
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: _showVolume,
              child: StreamBuilder<double>(
                stream: widget.player.volumeStream,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 120,
                    width: 20,
                    child: SfSliderTheme(
                      data: SfSliderThemeData(
                        thumbStrokeWidth: 6,
                        // thumbStrokeColor: selectedTheme[ColorTheme.info],
                        // thumbColor: selectedTheme[ColorTheme.primary],
                        // activeTrackColor: selectedTheme[ColorTheme.info],
                        activeTrackHeight: 5,
                        // inactiveTrackColor:
                        // selectedTheme[ColorTheme.border3],
                        inactiveTrackHeight: 5,
                        thumbRadius: 10,
                        overlayRadius: 10,
                      ),
                      child: SfSlider.vertical(
                        interval: 0.1,
                        min: 0.0,
                        max: 1.0,
                        value: snapshot.data ?? widget.player.volume,
                        onChanged: (value) => widget.player.setVolume(value),
                      ),
                    ),
                  );
                },
              ),
            ),
            StreamBuilder<double>(
              stream: widget.player.volumeStream,
              builder: (context, snapshot) {
                return InkWell(
                  child: Icon(
                    (snapshot.data ?? 0) > 0
                        ? Icons.volume_up
                        : Icons.volume_off,
                    color: Colors.black45,
                    size: 20,
                  ),
                  onTap: () {
                    if (_showVolume) {
                      widget.player
                          .setVolume((snapshot.data ?? 0.0) > 0 ? 0 : 1);
                    } else {
                      setState(() {
                        _showVolume = true;
                      });
                      Timer(const Duration(seconds: 3),
                          () => setState(() => _showVolume = false));
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
