import 'package:equatable/equatable.dart';
import '../enums.dart';

class Media extends Equatable {
  final int id;
  final String url;
  final MediaType type;
  final String thumbnailUrl;

  const Media(this.id, this.url, this.type, this.thumbnailUrl);

  @override
  List<Object?> get props => [id, url, type, thumbnailUrl];
}
