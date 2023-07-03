import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/enums.dart';
import 'package:video_player/video_player.dart';
import 'gallery.dart';
import 'models/models.dart';

class MediaCollection extends StatelessWidget {
  final List<Media> medias;

  const MediaCollection({
    Key? key,
    required this.medias,
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
                          colors: [Colors.black45.withOpacity(0.9)],
                          stops: const [0.0]).createShader(rect),
                      blendMode: BlendMode.srcOut,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 40,
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
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.black,
                      size: 35,
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
              onTap: () async {
                VideoPlayerController? videoController0;
                if (media.url.endsWith(".mp4") ||
                    media.url.endsWith(".MOV") ||
                    media.type == MediaType.video) {
                  Uri uri = Uri.parse(media.url);
                  videoController0 = VideoPlayerController.networkUrl(uri);
                  await videoController0.initialize();
                }
                if (context.mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => Gallery(
                      index: index,
                      medias: medias,
                      videoController: videoController0,
                    ),
                  );
                }
              },
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
              onTap: () async {
                VideoPlayerController? videoController;
                if (media.url.endsWith(".mp4") ||
                    media.url.endsWith(".MOV") ||
                    media.type == MediaType.video) {
                  Uri uri = Uri.parse(media.url);
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
                    ),
                  );
                }
              },
              child: child),
    );
  }
}
