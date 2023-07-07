import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_collection_previewer/audio_player/utils.dart';
import 'package:media_collection_previewer/consts.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final String? thumbnailUrl;
  final String? url;
  final String? path;
  final double height;
  final Color iconBgColor;
  final double iconSize;
  final double iconBgSize;

  const VideoThumbnail({
    super.key,
    this.thumbnailUrl,
    this.path,
    this.url,
    required this.height,
    this.iconBgColor = defaultIconColor,
    this.iconSize = defaultIconSize,
    this.iconBgSize = defaultIconBgSize,
  });

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  initState() {
    super.initState();
    if (isNotEmpty(widget.path)) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!));
    } else if (isNotEmpty(widget.url)) {
      _controller = VideoPlayerController.asset(widget.path!);
    }
    _controller?.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isNotEmpty(widget.thumbnailUrl) ||
            _controller?.value.isInitialized == true)
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: isNotEmpty(widget.thumbnailUrl)
                    ? CachedNetworkImage(
                        imageUrl: widget.thumbnailUrl!,
                        height: widget.height,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        height: widget.height,
                        width: double.infinity,
                        child: VideoPlayer(_controller!),
                      ),
              ),
              SizedBox(
                height: widget.height,
                child: Center(
                  child: ClipOval(
                    child: ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                          colors: [widget.iconBgColor.withOpacity(0.9)],
                          stops: const [0.0]).createShader(rect),
                      blendMode: BlendMode.srcOut,
                      child: Container(
                        padding: EdgeInsets.all(
                            (widget.iconBgSize - widget.iconSize) / 2),
                        child: Icon(
                          Icons.play_arrow,
                          size: widget.iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : const Placeholder();
  }
}
