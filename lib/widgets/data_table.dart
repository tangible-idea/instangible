
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
import '../riverpod/videoeditlist_provider.dart';

/// refer to [FeedModel]
class FeedTable extends ConsumerWidget {
  FeedTable({super.key});

  TextEditingController textController= TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedProvider= ref.watch(feedEditListProvider);

    if (feedProvider.isEmpty) {
      return const SizedBox.shrink();
    }
    else{
      Column(children:
        feedProvider.map((e) => Text(e.link)).toList(),
      );
    }

    Widget _buildFeedItem(FeedModel item) {
      textController.text= item.link;
      return Card(
        child: Column(
          children: [
            Image(
              image: CachedNetworkImageProvider(
                  item.link
              ),
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Hint',
                helperText: 'Helper',
                labelText: 'Label',
                border: OutlineInputBorder(),
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
      itemCount: feedProvider.length,
      itemBuilder: (context, index) {
        return _buildFeedItem(feedProvider[index]);
      },
    );


  }
}
