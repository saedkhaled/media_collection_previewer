import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/enums.dart';
import 'package:video_player/video_player.dart';

import 'consts.dart';
import 'gallery.dart';
import 'models/models.dart';

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
    var child = (media.url.endsWith(".mp4") ||
            media.url.endsWith(".MOV") ||
            media.type == MediaType.video)
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: media.thumbnailUrl,
                  height: height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: height,
                child: Center(
                  child: ClipOval(
                    child: ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                          colors: [playIconBgColor.withOpacity(0.9)],
                          stops: const [0.0]).createShader(rect),
                      blendMode: BlendMode.srcOut,
                      child: Container(
                        padding: EdgeInsets.all((playIconBgSize - playIconSize) / 2),
                        child: Icon(
                          Icons.play_arrow,
                          size: playIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : (media.url.endsWith(".mp3") ||
                media.url.endsWith(".wav") ||
                media.type == MediaType.audio)
            ? Container(
                height: height,
                decoration: BoxDecoration(
                  color: audioPlayerBgColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Container(
                    height: audioIconBgSize,
                    width: audioIconBgSize,
                    decoration: BoxDecoration(
                        color: audioIconBgColor, shape: BoxShape.circle),
                    child: Icon(
                      Icons.music_note,
                      color: audioIconColor,
                      size: audioIconSize,
                    ),
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: media.url,
                  height: height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: isLast
          ? InkWell(
              onTap: () => _showGallery(context, index, medias),
              child: Stack(
                children: [
                  child,
                  Container(
                    height: height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 60,
                            ),
                          ),
                          TextSpan(
                            text: '${count - 5}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
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
    VideoPlayerController? videoController;
    if (medias[index].url.endsWith(".mp4") ||
        medias[index].url.endsWith(".MOV") ||
        medias[index].type == MediaType.video) {
      Uri uri = Uri.parse(medias[index].url);
      videoController = VideoPlayerController.networkUrl(uri);
      await videoController.initialize();
    }
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Gallery(
          index: index,
          medias: medias,
          videoController: videoController,
          arrowColor: arrowColor,
          arrowBgColor: arrowBgColor,
        ),
      );
    }
  }

}
