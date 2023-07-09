import 'package:flutter/material.dart';
import 'package:media_collection_previewer/models/theme.dart';

class VideoPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final MediaCollectionTheme theme;

  const VideoPlaceholder({
    super.key,
    required this.height,
    required this.width,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: theme.videoPlaceholderBgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: ClipOval(
          child: ShaderMask(
            shaderCallback: (rect) => LinearGradient(
                colors: [theme.playIconBgColor.withOpacity(0.9)],
                stops: const [0.0]).createShader(rect),
            blendMode: BlendMode.srcOut,
            child: Container(
              padding: EdgeInsets.all(
                  (theme.playIconBgSize - theme.playIconSize) / 2),
              child: Icon(
                Icons.play_arrow,
                size: theme.playIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
