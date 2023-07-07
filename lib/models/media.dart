import 'package:equatable/equatable.dart';

import '../enums.dart';

class Media extends Equatable {
  final int id;
  final String? url;
  final String? path;
  final MediaType type;
  final String? thumbnailUrl;

  const Media({
    required this.id,
    this.url,
    this.path,
    required this.type,
    this.thumbnailUrl,
  });

  get isVideo {
    var source = url ?? path;
    if (source == null || source.isEmpty) return false;
    source = source.toLowerCase();
    return type == MediaType.video ||
        source.contains('.mp4') ||
        source.contains('.mov');
  }

  get isAudio {
    var source = url ?? path;
    if (source == null || source.isEmpty) return false;
    source = source.toLowerCase();
    return type == MediaType.audio ||
        source.contains('.mp3') ||
        source.contains('.wav');
  }

  @override
  List<Object?> get props => [id, url, path, type, thumbnailUrl];
}
