import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/screens/homepage.dart';
import 'package:instagible/widgets/my_feed_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';
import 'package:video_editor/ui/crop/crop_grid.dart';
import 'package:video_player/video_player.dart';

import '../riverpod/simple_state_provider.dart';
import '../widgets/message_input_dialog.dart';

class EditFeedPage extends ConsumerStatefulWidget {
  static String id = "/edit";
  const EditFeedPage({super.key});

  @override
  EditFeedState createState() => EditFeedState();
}

class EditFeedState extends ConsumerState<EditFeedPage> {

  late VideoPlayerController _videoController;
  late final VideoEditorController _editController= VideoEditorController.file(
    FeedTable.fileEditTarget,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 10),
  );

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    var selectedFeedNotifier= ref.read(selectedFeedProvider);

    _videoController = VideoPlayerController.networkUrl(Uri.parse(
        selectedFeedNotifier.link))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        // TODO;
        selectedFeedNotifier.isVideo= true;
        setState(() {});
      });

    _editController
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
        // handle minumum duration bigger than video duration error
          Navigator.pop(context);
      }, test: (e) => e is VideoMinDurationError)
        .then((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _editController.dispose();
  }



  Widget VideoPreview() {
    return _videoController.value.isInitialized ? Stack(
      children: [
        VideoPlayer(_videoController),
        InkWell(
          onTap: () {
            _videoController.value.isPlaying
                ? _videoController.pause()
                : _videoController.play();
          },
          child: Center(
            child: Icon(
              _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
      ],
    ) : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    // We can also use "ref" to listen to a provider inside the build method
    var selectedFeedNotifier= ref.watch(selectedFeedProvider.notifier);

    print("rebuild");

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Instangible", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {

              ref.read(messageProvider.notifier).state= "gymweirdos";
              MessageInputDialog.showInputDialog(context, ref);
              setState(() {

              });

            },
          ),
        ],
    ),
    body: _editController.initialized ? Stack(
      alignment: Alignment.center,
      children: [
        CropGridViewer.preview(
            controller: _editController),
        AnimatedBuilder(
          animation: _editController.video,
          builder: (_, __) => AnimatedOpacity(
            opacity:
            _editController.isPlaying ? 0 : 1,
            duration: kThemeAnimationDuration,
            child: GestureDetector(
              onTap: _editController.video.play,
              child: Container(
                width: 40,
                height: 40,
                decoration:
                const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        CoverViewer(controller: _editController)
      ])

            : const SizedBox()
    );
  }
}