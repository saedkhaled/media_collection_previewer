import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/widgets/audio_thumbnail.dart';
import 'package:media_collection_previewer/widgets/video_thumbnail.dart';
import 'audio_player/utils.dart';
import 'consts.dart';
import 'gallery.dart';
import 'models/models.dart';
import 'widgets/more_media.dart';

/// A widget that displays a collection of media.
class MediaCollection extends StatelessWidget {
  /// The list of media to display.
  final List<Media> medias;

  /// The color of the arrow icon.
  final Color arrowColor;

  /// The color of the arrow icon background.
  final Color arrowBgColor;

  /// The color of the play icon background.
  final Color playIconBgColor;

  /// The color of the audio icon background.
  final Color audioIconBgColor;

  /// The color of the audio icon.
  final Color audioIconColor;

  /// The color of the audio player background.
  final Color audioPlayerBgColor;

  /// The size of the play icon.
  final double playIconSize;

  /// The size of the audio icon.
  final double audioIconSize;

  /// The size of the play icon background.
  final double playIconBgSize;

  /// The size of the audio icon background.
  final double audioIconBgSize;

  const MediaCollection({
    Key? key,
    required this.medias,
    this.arrowColor = defaultIconColor,
    this.arrowBgColor = defaultIconBgColor,
    this.playIconBgColor = defaultIconColor,
    this.audioIconBgColor = defaultIconColor,
    this.audioIconColor = defaultIconBgColor,
    this.audioPlayerBgColor = defaultIconBgColor,
    this.playIconSize = defaultIconSize,
    this.audioIconSize = defaultIconSize,
    this.playIconBgSize = defaultIconBgSize,
    this.audioIconBgSize = defaultIconBgSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: medias.length <= 2
          ? Column(
              children: medias
                  .mapIndexed((index, media) =>
                      _buildMedia(media, index, 300, context, medias.length))
                  .toList(),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: medias
                        .sublist(0, 2)
                        .mapIndexed((index, media) => _buildMedia(
                            media, index, 300, context, medias.length))
                        .toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: medias
                        .sublist(2, medias.length > 5 ? 5 : medias.length)
                        .mapIndexed((index, media) => _buildMedia(
                            media, index + 2, 198.25, context, medias.length,
                            isLast: index == 2 && medias.length > 5))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMedia(
      Media media, int index, double height, BuildContext context, int count,
      {bool isLast = false}) {
    if (!isNotEmpty(medias[index].url) && !isNotEmpty(medias[index].path)) {
      throw Exception('Media url or path must be provided');
    }
    var child = media.isVideo
        ? VideoThumbnail(
            height: height,
            thumbnailUrl: media.thumbnailUrl,
            path: media.path,
            iconBgColor: playIconBgColor,
            iconBgSize: playIconBgSize,
            iconSize: playIconSize,
          )
        : media.isAudio
            ? AudioThumbnail(
                height: height,
                thumbnailUrl: media.thumbnailUrl,
                bgColor: audioPlayerBgColor,
                iconColor: audioIconColor,
                iconSize: audioIconSize,
                iconBgColor: audioIconBgColor,
                iconBgSize: audioIconBgSize,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: isNotEmpty(media.url)
                    ? CachedNetworkImage(
                        imageUrl: media.url!,
                        height: height,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : isNotEmpty(media.path)
                        ? Image.asset(
                            media.path!,
                            height: height,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(),
              );
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: isLast
          ? InkWell(
              onTap: () => _showGallery(context, index, medias),
              child: Stack(
                children: [
                  child,
                  MoreMedia(
                    height: height,
                    count: count,
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: () => _showGallery(context, index, medias),
              child: child,
            ),
    );
  }

  _showGallery(BuildContext context, int index, List<Media> medias) async {
    if (!isNotEmpty(medias[index].url) && !isNotEmpty(medias[index].path)) {
      throw Exception('Media url or path must be provided');
    }
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Gallery(
          index: index,
          medias: medias,
          arrowColor: arrowColor,
          arrowBgColor: arrowBgColor,
        ),
      );
    }
  }
}
