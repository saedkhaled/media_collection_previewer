import 'package:equatable/equatable.dart';

import '../enums.dart';

class Media extends Equatable {
  final int id;
  final String url;
  final MediaType type;
  final String thumbnailUrl;

  const Media({
    required this.id,
    required this.url,
    required this.type,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, url, type, thumbnailUrl];
}
