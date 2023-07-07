import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/audio_player/utils.dart';
import 'package:media_collection_previewer/consts.dart';

class AudioThumbnail extends StatelessWidget {
  final double height;
  final String? thumbnailUrl;
  final Color bgColor;
  final Color iconColor;
  final Color iconBgColor;
  final double iconBgSize;
  final double iconSize;

  const AudioThumbnail({
    super.key,
    required this.height,
    this.thumbnailUrl,
    this.bgColor = defaultIconBgColor,
    this.iconColor = defaultIconBgColor,
    this.iconSize = defaultIconSize,
    this.iconBgColor = defaultIconColor,
    this.iconBgSize = defaultIconBgSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: isNotEmpty(thumbnailUrl)
            ? CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Container(
                height: iconBgSize,
                width: iconBgSize,
                decoration:
                    BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.music_note,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
      ),
    );
  }
}
