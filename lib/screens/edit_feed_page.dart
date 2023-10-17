import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../riverpod/simple_state_provider.dart';

class EditFeedPage extends ConsumerStatefulWidget {
  static String id = "/edit";
  const EditFeedPage({super.key});

  @override
  EditFeedState createState() => EditFeedState();
}

class EditFeedState extends ConsumerState<EditFeedPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    var selectedFeedNotifier= ref.read(selectedFeedProvider);

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        selectedFeedNotifier.link))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        // TODO;
        selectedFeedNotifier.isVideo= true;
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
            onPressed: () {

            },
          ),
        ],
    ),
    body: _controller.value.isInitialized ? Stack(
      children: [
        VideoPlayer(_controller),
        InkWell(
          onTap: () {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          },
          child: Center(
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
      ],
    ) : const Placeholder()
    );
  }
}