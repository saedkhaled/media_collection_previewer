import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/audio_player/utils.dart';
import 'package:media_collection_previewer/models/theme.dart';
import 'package:video_player/video_player.dart';
import 'package:web_video_player/player.dart';

import 'audio_player/audio_player.dart';
import 'models/models.dart';
import 'widgets/arrows_bar.dart';

class Gallery extends StatefulWidget {
  final int index;
  final List<Media> medias;
  final MediaCollectionTheme theme;

  const Gallery({
    Key? key,
    required this.index,
    required this.medias,
    required this.theme,
  }) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var _currentIndex = 0;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    _currentIndex = widget.index;
    if (widget.medias[_currentIndex].isVideo) {
      _videoController = isNotEmpty(widget.medias[_currentIndex].url)
          ? VideoPlayerController.networkUrl(
              Uri.parse(widget.medias[_currentIndex].url!))
          : VideoPlayerController.asset(widget.medias[_currentIndex].path!);
    }
    _videoController?.initialize().then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Widget content;
    // var isImage = false;
    var height = 400.0;
    var width = 500.0;
    if (widget.medias[_currentIndex].isVideo) {
      height = MediaQuery.sizeOf(context).width < 650
          ? ((MediaQuery.sizeOf(context).width *
                  _videoController!.value.size.height) /
              _videoController!.value.size.width)
          : _videoController!.value.size.height / 2;
      width = MediaQuery.sizeOf(context).width < 650
          ? MediaQuery.sizeOf(context).width
          : _videoController!.value.size.width / 1.7;
      content = _videoController!.value.isInitialized
          ? Center(
              child: SizedBox(
                height: height,
                width: width,
                child: ColoredBox(
                  color: Colors.black,
                  child: WebVideoPlayer(
                    videoController: _videoController!,
                    url: widget.medias[_currentIndex].url!,
                    autoPlay: true,
                  ),
                ),
              ),
            )
          : Container();
    } else if (widget.medias[_currentIndex].isAudio) {
      width = MediaQuery.sizeOf(context).width < 650
          ? MediaQuery.sizeOf(context).width
          : MediaQuery.sizeOf(context).width * 0.85;
      content = Material(
        child: SizedBox(
          height: 400,
          child: AudioPlayerWidget(
            url: widget.medias[_currentIndex].url!,
            mediaId: widget.medias[_currentIndex].id,
            thumbnailUrl: widget.medias[_currentIndex].thumbnailUrl,
          ),
        ),
      );
    } else {
      //replace small image url with large image url
      // isImage = true;
      // width =
      //     MediaQuery.sizeOf(context).width - (context.isPhone ? 20 : 200);
      height = MediaQuery.sizeOf(context).height - 50;
      width = MediaQuery.sizeOf(context).width - 50;
      content = InteractiveViewer(
        child: isNotEmpty(widget.medias[_currentIndex].url)
            ? CachedNetworkImage(
                imageUrl: widget.medias[_currentIndex].url!,
                height: height,
                width: double.infinity,
                fit: BoxFit.contain,
              )
            : isNotEmpty(widget.medias[_currentIndex].path)
                ? Image.asset(
                    widget.medias[_currentIndex].path!,
                    height: height,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                : Container(),
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
          ArrowsBar(
            index: _currentIndex,
            length: widget.medias.length,
            arrowColor: widget.theme.arrowColor,
            arrowBgColor: widget.theme.arrowBgColor,
            onArrowTap: (index) async {
              if (widget.medias[index].isVideo) {
                if (isNotEmpty(widget.medias[index].url)) {
                  _videoController = VideoPlayerController.networkUrl(
                      Uri.parse(widget.medias[index].url!));
                } else if (isNotEmpty(widget.medias[index].path)) {
                  _videoController =
                      VideoPlayerController.asset(widget.medias[index].path!);
                }
                _videoController?.initialize().then((_) {
                  setState(() {});
                });
              }
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: child,
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
