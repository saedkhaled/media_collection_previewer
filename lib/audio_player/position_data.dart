part of 'audio_player.dart';

class _PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  _PositionData(this.position, this.bufferedPosition, this.duration);
}
