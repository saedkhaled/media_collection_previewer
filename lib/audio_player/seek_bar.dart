part of 'audio_player.dart';

class _SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  // final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const _SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    // this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                //TODO: Buffer slider removed because it has design problem need to be fixed later.
                // SfSliderTheme(
                //   data: SfSliderThemeData(
                //     activeTrackColor: selectedTheme[ColorTheme.border2],
                //     activeTrackHeight: 12,
                //   ),
                //   child: ExcludeSemantics(
                //     child: SfSlider(
                //       min: 0.0,
                //       max: widget.duration.inMilliseconds.toDouble() == 0.0
                //           ? 0.1
                //           : widget.duration.inMilliseconds.toDouble(),
                //       value: min(
                //           widget.bufferedPosition.inMilliseconds.toDouble(),
                //           widget.duration.inMilliseconds.toDouble()),
                //       onChanged: (value) {
                //         setState(() {
                //           _dragValue = value;
                //         });
                //         if (widget.onChanged != null) {
                //           widget.onChanged!(
                //               Duration(milliseconds: value.round()));
                //         }
                //       },
                //       onChangeEnd: (value) {
                //         if (widget.onChangeEnd != null) {
                //           widget.onChangeEnd!(
                //               Duration(milliseconds: value.round()));
                //         }
                //         _dragValue = null;
                //       },
                //     ),
                //   ),
                // ),
                SfSliderTheme(
                  data: SfSliderThemeData(
                    thumbStrokeWidth: 6,
                    // thumbStrokeColor: selectedTheme[ColorTheme.info],
                    // thumbColor: selectedTheme[ColorTheme.primary],
                    thumbRadius: 10,
                    overlayRadius: 10,
                    // activeTrackColor: selectedTheme[ColorTheme.info],
                    activeTrackHeight: 10,
                    // inactiveTrackColor: selectedTheme[ColorTheme.border3],
                    inactiveTrackHeight: 10,
                  ),
                  child: SfSlider(
                    min: 0.0,
                    max: widget.duration.inMilliseconds.toDouble() == 0.0
                        ? 0.1
                        : widget.duration.inMilliseconds.toDouble(),
                    value: min(
                        _dragValue ?? widget.position.inMilliseconds.toDouble(),
                        widget.duration.inMilliseconds.toDouble()),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                      // if (widget.onChanged != null) {
                      //   widget
                      //       .onChanged!(Duration(milliseconds: value.round()));
                      // }
                    },
                    onChangeEnd: (value) {
                      if (widget.onChangeEnd != null) {
                        widget.onChangeEnd!(
                            Duration(milliseconds: value.round()));
                      }
                      _dragValue = null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch("$_remaining")
                    ?.group(1) ??
                '$_remaining',
            style: const TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
