import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/enums.dart';
import 'package:video_player/video_player.dart';
import 'package:web_video_player/player.dart';
import 'audio_player/audio_player.dart';
import 'models/models.dart';

class Gallery extends StatefulWidget {
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
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var _currentIndex = 0;
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    _videoController = widget.videoController;
    _currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Widget content;
    var isImage = false;
    var height = 400.0;
    var width = 500.0;
    if (widget.medias[_currentIndex].url.endsWith(".mp4") ||
        widget.medias[_currentIndex].url.endsWith(".MOV") ||
        widget.medias[_currentIndex].type == MediaType.video) {
      height = MediaQuery.sizeOf(context).width < 650
          ? ((MediaQuery.sizeOf(context).width *
                  _videoController!.value.size.height) /
              _videoController!.value.size.width)
          : _videoController!.value.size.height / 2;
      width = MediaQuery.sizeOf(context).width < 650
          ? MediaQuery.sizeOf(context).width
          : _videoController!.value.size.width / 1.7;
      content = WebVideoPlayer(
        videoController: _videoController!,
        url: widget.medias[_currentIndex].url,
        mediaId: widget.medias[_currentIndex].id,
      );
    } else if (widget.medias[_currentIndex].url.endsWith(".mp3") ||
        widget.medias[_currentIndex].url.endsWith(".wav") ||
        widget.medias[_currentIndex].type == MediaType.audio) {
      width = MediaQuery.sizeOf(context).width < 650
          ? MediaQuery.sizeOf(context).width
          : MediaQuery.sizeOf(context).width * 0.85;
      content = Material(
        child: SizedBox(
          height: 400,
          child: AudioPlayerWidget(
            url: widget.medias[_currentIndex].url,
            mediaId: widget.medias[_currentIndex].id,
            thumbnailUrl: widget.medias[_currentIndex].thumbnailUrl,
          ),
        ),
      );
    } else {
      //replace small image url with large image url
      isImage = true;
      // width =
      //     MediaQuery.sizeOf(context).width - (context.isPhone ? 20 : 200);
      height = MediaQuery.sizeOf(context).height - 50;
      content = InteractiveViewer(
        child: CachedNetworkImage(
          placeholder: (_, s) => const Placeholder(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          imageUrl:
              widget.medias[_currentIndex].url.replaceFirst('small', 'large'),
          height: height,
          fit: BoxFit.contain,
        ),
      );
    }
    var child = Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: content,
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: _currentIndex > 0,
                    child: InkWell(
                      onTap: () async {
                        if (widget.medias[_currentIndex - 1].url
                                .endsWith(".mp4") ||
                            widget.medias[_currentIndex - 1].url
                                .endsWith(".MOV") ||
                            widget.medias[_currentIndex - 1].type ==
                                MediaType.video) {
                          final uri =
                              Uri.parse(widget.medias[_currentIndex - 1].url);
                          _videoController =
                              VideoPlayerController.networkUrl(uri);
                          await _videoController?.initialize();
                        }
                        setState(() {
                          _currentIndex--;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF272829),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFFFFFFFF),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _currentIndex < widget.medias.length - 1,
                    child: InkWell(
                      onTap: () async {
                        if (widget.medias[_currentIndex + 1].url
                                .endsWith(".mp4") ||
                            widget.medias[_currentIndex + 1].url
                                .endsWith(".MOV") ||
                            widget.medias[_currentIndex + 1].type ==
                                MediaType.video) {
                          final uri =
                              Uri.parse(widget.medias[_currentIndex + 1].url);
                          _videoController =
                              VideoPlayerController.networkUrl(uri);
                          await _videoController?.initialize();
                        }
                        setState(() {
                          _currentIndex++;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF272829),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF272829),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: isImage
                ? child
                : SizedBox(
                    height: height,
                    width: width,
                    child: child,
                  ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: Color(0xFFFFFFFF),
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
