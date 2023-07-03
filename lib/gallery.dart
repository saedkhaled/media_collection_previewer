import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'models/Media.dart';

class Gallery extends StatelessWidget {
  final int index;
  final List<Media> medias;
  final VideoPlayerController? videoController;

  const Gallery({
    Key? key,
    required this.index,
    required this.medias,
    this.videoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
