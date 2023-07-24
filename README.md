The media_collection_previewer is a versatile Flutter package designed to simplify the way you preview various media
files,
including images, audio, and video, within your Flutter applications.
This package enables developers to open and interact with a comprehensive viewer for media files by simply clicking on
them,
thereby enhancing the user experience and the overall quality of your application.

<img src="https://github.com/saedkhaled/media_collection_previewer/blob/main/screenshots/preview.gif?raw=true" width="700" alt="Preview"/>

Note: This package is still under development and is subject to change.

## Features

- Supports multiple file formats: Effortlessly preview image, video, and audio files all in one place.
- Supported image formats: JPEG, PNG, GIF.
- Supported video formats: MP4, MOV.
- Supported audio formats: MP3, WAV.
- Supports media playback from local assets, and remote URLs.

## Getting started

To use this package, add media_collection_previewer as a dependency in your pubspec.yaml file.

## Installation

In your `pubspec.yaml` file within your Flutter Project add `media_collection_previewer` under dependencies:

```yaml
dependencies:
  media_collection_previewer: <latest_version>
```

## Using it

- Import the package and create a list of media files to preview.

```dart
import 'package:media_collection_previewer/media_collection_previewer.dart';

List<Media> medias = [
  Media(
    id: 1,
    type: MediaType.image,
    path: imagePath,
  ),
  Media(
    id: 2,
    type: MediaType.video,
    url: url,
    thumbnailUrl: thumbnailUrl,
  ),
  Media(
    id: 3,
    type: MediaType.audio,
    path: audioPath,
  ),
];
```

- Create a `MediaCollection` widget and pass the list of media files to it.

```dart

final widget = MediaCollection(medias: medias);
```

This will create a previewer which shows your media files and allows them to be opened and viewed on click.

## Additional information

You can check out the [example]('https://github.com/saedkhaled/media_collection_previewer/tree/main/example/main.dart') directory
for a sample application using this package.

## License

web_video_player is licensed under the New BSD License check
the [License]('https://github.com/saedkhaled/media_collection_previewer/blob/main/LICENSE') for more details.
