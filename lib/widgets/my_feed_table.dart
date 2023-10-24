
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/riverpod/simple_state_provider.dart';
import 'package:instagible/screens/edit_feed_page.dart';
import 'package:instagible/utils/file_utils.dart';
import '../model/user_model.dart';
import '../riverpod/videoeditlist_provider.dart';



/// refer to [FeedModel]
class FeedTable extends ConsumerWidget {
  FeedTable({super.key});
  static File fileEditTarget= File("");

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
                  item.displayUrl
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
                  onPressed: () async {
                    // Handle comment button press
                    var targetFile= await FileUtils.downloadFile(item.link, "./download.mp4");
                    //item.downloadedFile= targetFile;
                    fileEditTarget= targetFile;

                    selectedFeedNotifier.state= item;
                    Navigator.of(context).pushNamed(EditFeedPage.id);
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
