import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/audio_player/utils.dart';
import 'package:media_collection_previewer/models/theme.dart';
import 'package:video_player/video_player.dart';

import 'video_placeholder.dart';

class VideoThumbnail extends StatefulWidget {
  /// The url of the thumbnail image of the video.
  final String? thumbnailUrl;

  /// The url of the video to show in the thumbnail.
  final String? url;

  /// The path of the video to show in the thumbnail.
  final String? path;

  /// the theme of the media collection widget to get the widget theme from.
  final MediaCollectionTheme theme;

  /// Whether the thumbnail is a sub item or not.
  final bool isSub;

  const VideoThumbnail({
    super.key,
    required this.theme,
    this.thumbnailUrl,
    this.path,
    this.url,
    this.isSub = false,
  });

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  initState() {
    super.initState();
    if (isNotEmpty(widget.url)) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!));
    } else if (isNotEmpty(widget.path)) {
      _controller = VideoPlayerController.asset(widget.path!);
    }
    _controller?.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height =
        widget.isSub ? widget.theme.subItemHeight : widget.theme.mainItemHeight;
    return (isNotEmpty(widget.thumbnailUrl) ||
            _controller?.value.isInitialized == true)
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: isNotEmpty(widget.thumbnailUrl)
                    ? CachedNetworkImage(
                        height: height,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.thumbnailUrl!,
                      )
                    : Container(
                        height: height,
                        width: double.infinity,
                        color: widget.theme.videoBgColor,
                        child: VideoPlayer(_controller!),
                      ),
              ),
              SizedBox(
                height: height,
                child: Center(
                  child: Container(
                    height: widget.theme.playIconBgSize,
                    width: widget.theme.playIconBgSize,
                    decoration: BoxDecoration(
                      color: widget.theme.videoBgColor
                          .withOpacity(widget.theme.playIconColor.opacity),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: widget.theme.playIconSize,
                      color: widget.theme.playIconColor
                          .withOpacity(widget.theme.playIconColor.opacity),
                    ),
                  ),
                ),
              ),
            ],
          )
        : VideoPlaceholder(
            height: widget.isSub
                ? widget.theme.subItemHeight
                : widget.theme.mainItemHeight,
            width: double.infinity,
            theme: widget.theme,
          );
  }
}
