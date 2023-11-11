//import 'dart:ffi';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/screens/edit_youtube_page.dart';
import 'package:instagible/utils/flutter_insta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
//import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final messageProvider = StateProvider((ref) => '');
//final showDialogProvider = StateProvider((ref) => false);

class MessageInputDialog {

  showInputDialog(BuildContext context, WidgetRef ref) {
    String editedValue= ref.watch(messageProvider.notifier).state;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text('Enter URL'),
              TextFormField(
                initialValue: editedValue,
                onChanged: (value) {
                  //ref.read(messageProvider.notifier).state= value;
                  editedValue= value;
                },
                decoration: const InputDecoration(hintText: 'Type your message'),
              )
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () async {

                ref.read(messageProvider.notifier).state= editedValue;
                //var result= await FlutterInsta().downloadReels(editedValue);

                var yt = YoutubeExplode();
                /*var title = video.title; // "Scamazon Prime"
                var author = video.author; // "Jim Browning"
                var duration = video.duration; // Instance of Duration - 0:19:48.00000*/
                // You can provide either a video ID or URL as String or an instance of `VideoId`.
                //var video = await yt.videos.get('https://youtube.com/watch?v=Dpp1sIL1m5Q'); // Returns a Video instance.

                var manifest = await yt.videos.streamsClient.getManifest('SXZLNeVDfRA');
                // Get highest quality muxed stream
                var streamInfo = manifest.muxed.bestQuality;
                // Get the actual stream
                var stream = yt.videos.streams.get(streamInfo);

                Directory appDocDirectory = await getApplicationDocumentsDirectory();

                Directory('${appDocDirectory.path}/dir').create(recursive: true)
                // The created directory is returned as a Future.
                    .then((Directory directory) async {
                      EditYoutubeState.targetFilePath= '${directory.path}/download_youtube.mp4';

                      // Open a file for writing.
                      var file = File(EditYoutubeState.targetFilePath);
                      var fileStream = file.openWrite();

                      // Pipe all the content of the stream into the file.
                      await stream.pipe(fileStream);

                      // Close the file.
                      await fileStream.flush();
                      await fileStream.close();

                      Navigator.of(context).pushNamed(EditYoutubePage.id);
                });




                //print(result);
                // Do something with the message
                //print('Message: ${messageRef.state}');
                //Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },

    );
  }
}
