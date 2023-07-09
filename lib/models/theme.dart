import 'package:flutter/material.dart';
import 'package:media_collection_previewer/consts.dart';

/// The theme for the media collection previewer.
class MediaCollectionTheme {
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

  /// The color of the video placeholder background.
  final Color videoPlaceholderBgColor;

  /// The color of the video placeholder icon background.
  final Color videoPlaceholderIconBgColor;

  final Color videoBgColor;

  /// The height of the main item in the grid view.
  final double mainItemHeight;

  /// The height of the sub item in the grid view.
  final double subItemHeight;

  /// The width of the divider between the media items.
  final double dividerWidth;

  /// The constructor for the media collection theme (default values are provided).
  const MediaCollectionTheme({
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
    this.videoPlaceholderBgColor = defaultIconBgColor,
    this.videoPlaceholderIconBgColor = defaultIconColor,
    this.mainItemHeight = defaultMainItemHeight,
    this.subItemHeight = defaultSubItemHeight,
    this.dividerWidth = defaultDividerWidth,
    this.videoBgColor = defaultVideoBgColor,
  });
}
