
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../screens/edit_youtube_page.dart';

class YoutubeUtils {

  static getYoutubeVideo(String videoLink) async {

    try {
      var yt = YoutubeExplode();
      /*var title = video.title; // "Scamazon Prime"
      var author = video.author; // "Jim Browning"
      var duration = video.duration; // Instance of Duration - 0:19:48.00000*/

      RegExp regYoutubeSlug = RegExp(r"\w{11}", // parse 11 digits video slug.
        caseSensitive: false,
        multiLine: false,
      );

      var youtubeLink = regYoutubeSlug.firstMatch(videoLink);
      var youtubeSlug = youtubeLink?.group(0);
      print("regexed slug: $youtubeSlug");

      /// link sample1: https://youtube.com/watch?v=SXZLNeVDfRA
      /// link sample2: https://www.youtube.com/shorts/oV1xt7Lo61c?feature=share
      /// slug sample: 'SXZLNeVDfRA'
      var manifest = await yt.videos.streamsClient.getManifest(youtubeSlug);
      // Get highest quality muxed stream
      var streamInfo = manifest.muxed.sortByVideoQuality().last;
      // Get the actual stream
      var stream = yt.videos.streams.get(streamInfo);

      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      await Directory('${appDocDirectory.path}/dir').create(recursive: true)
      // The created directory is returned as a Future.
          .then((Directory directory) async {
        EditYoutubeState.targetFilePath =
        '${directory.path}/download_youtube.mp4';

        // Open a file for writing.
        var file = File(EditYoutubeState.targetFilePath);
        var fileStream = file.openWrite();

        // Pipe all the content of the stream into the file.
        await stream.pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();
      });
    }on Exception catch (_, ex) {
      print(ex.toString());
    }
  }

}