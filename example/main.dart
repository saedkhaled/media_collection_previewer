import 'package:flutter/material.dart';
import 'package:media_collection_previewer/media_collection_previewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Collection Previewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    final medias = [
      const Media(
          id: 1,
          type: MediaType.video,
          url:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
      const Media(
        id: 2,
        type: MediaType.audio,
        url:
            'https://flutter.github.io/assets-for-api-docs/assets/audio/rooster.mp3',
      ),
      const Media(
        id: 3,
        type: MediaType.image,
        url:
            'https://flutter.github.io/assets-for-api-docs/assets/flutter-test/goldens/widget_testImage.png',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Collection Previewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaCollection(
                medias: medias,
                theme: const MediaCollectionTheme(
                  arrowColor: Colors.white,
                  arrowBgColor: Colors.black,
                  playIconBgColor: Colors.black,
                  playIconBgSize: 50,
                  playIconSize: 30,
                  audioIconBgColor: Colors.black,
                  audioIconBgSize: 50,
                  audioIconColor: Colors.white,
                  audioIconSize: 30,
                  audioPlayerBgColor: Colors.black,
                  dividerWidth: 2.5,
                  mainItemHeight: 300,
                  subItemHeight: 198.25,
                )),
          ],
        ),
      ),
    );
  }
}
