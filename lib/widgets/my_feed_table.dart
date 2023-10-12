
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/riverpod/simple_state_provider.dart';
import '../model/user_model.dart';
import '../riverpod/videoeditlist_provider.dart';

/// refer to [FeedModel]
class FeedTable extends ConsumerWidget {
  FeedTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedWatch= ref.watch(feedEditListProvider);
    final selectedFeedNotifier= ref.read(selectedFeedProvider.notifier);


    if (feedWatch.isEmpty) {
      return const SizedBox.shrink();
    }
    else{
      Column(children:
        feedWatch.map((e) => Text(e.link)).toList(),
      );
    }

    Widget _buildFeedItem(FeedModel item) {
      return Card(
        child: Column(
          children: [
            Image(
              image: CachedNetworkImageProvider(
                  item.link
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(item.content),
            ),
            ButtonBar(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle like button press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle comment button press
                    selectedFeedNotifier.state= item;
                    Navigator.of(context).pushNamed("/edit");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Handle share button press
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: feedWatch.length,
      itemBuilder: (context, index) {
        return _buildFeedItem(feedWatch[index]);
      },
    );


  }
}
