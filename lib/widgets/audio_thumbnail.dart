import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/audio_player/utils.dart';
import 'package:media_collection_previewer/models/theme.dart';

class AudioThumbnail extends StatelessWidget {
  final String? thumbnailUrl;
  final MediaCollectionTheme theme;
  final bool isSub;

  const AudioThumbnail({
    super.key,
    required this.theme,
    this.thumbnailUrl,
    this.isSub = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSub ? theme.subItemHeight : theme.mainItemHeight,
      decoration: BoxDecoration(
        color: theme.audioPlayerBgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: isNotEmpty(thumbnailUrl)
            ? CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                height: isSub ? theme.subItemHeight : theme.mainItemHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Container(
                height: theme.audioIconBgSize,
                width: theme.audioIconBgSize,
                decoration: BoxDecoration(
                    color: theme.audioIconBgColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.music_note,
                  color: theme.audioIconColor,
                  size: theme.audioIconSize,
                ),
              ),
      ),
    );
  }
}
