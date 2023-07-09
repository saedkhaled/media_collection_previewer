import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/widgets/audio_thumbnail.dart';
import 'package:media_collection_previewer/widgets/video_thumbnail.dart';
import 'audio_player/utils.dart';
import 'consts.dart';
import 'gallery.dart';
import 'models/models.dart';
import 'models/theme.dart';
import 'widgets/more_media.dart';

/// A widget that displays a collection of media.
class MediaCollection extends StatelessWidget {
  /// The list of media to display.
  final List<Media> medias;

  /// The theme of the media collection widget.
  final MediaCollectionTheme theme;

  const MediaCollection({
    Key? key,
    required this.medias,
    this.theme = defaultMediaCollectionTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: medias.length <= 2
          ? Column(
              children: medias
                  .mapIndexed(
                      (index, media) => _buildMedia(media, index, context))
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
                        .mapIndexed((index, media) =>
                            _buildMedia(media, index, context))
                        .toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: medias
                        .sublist(2, medias.length > 5 ? 5 : medias.length)
                        .mapIndexed((index, media) => _buildMedia(
                            media, index + 2, context,
                            isLast: index == 2 && medias.length > 5))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMedia(Media media, int index, BuildContext context,
      {bool isLast = false}) {
    if (!isNotEmpty(media.url) && !isNotEmpty(media.path)) {
      throw Exception('Media url or path must be provided');
    }
    final isSubItem = index > 1;
    var child = media.isVideo
        ? VideoThumbnail(
            theme: theme,
            thumbnailUrl: media.thumbnailUrl,
            path: media.path,
            url: media.url,
            isSub: isSubItem,
          )
        : media.isAudio
            ? AudioThumbnail(
                thumbnailUrl: media.thumbnailUrl,
                theme: theme,
                isSub: isSubItem,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: isNotEmpty(media.url)
                    ? CachedNetworkImage(
                        imageUrl: media.url!,
                        height: isSubItem
                            ? theme.subItemHeight
                            : theme.mainItemHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : isNotEmpty(media.path)
                        ? Image.asset(
                            media.path!,
                            height: isSubItem
                                ? theme.subItemHeight
                                : theme.mainItemHeight,
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
                    height:
                        isSubItem ? theme.subItemHeight : theme.mainItemHeight,
                    count: medias.length,
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
          theme: theme,
        ),
      );
    }
  }
}
