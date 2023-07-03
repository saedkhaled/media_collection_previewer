import 'package:equatable/equatable.dart';
import 'package:media_collection_previewer/models/enums.dart';

class Media extends Equatable {
  final int id;
  final String url;
  final MediaType type;
  final String thumbnailUrl;

  const Media(this.id, this.url, this.type, this.thumbnailUrl);

  @override
  List<Object?> get props => [id, url, type, thumbnailUrl];
}
