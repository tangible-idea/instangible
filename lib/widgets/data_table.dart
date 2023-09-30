
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
import '../riverpod/videoeditlist_provider.dart';

/// refer to [FeedModel]
class CVTable extends ConsumerWidget {
  const CVTable({super.key});

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
      return Card(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  item.link
                ),
              ),
              title: Text(item.link),
              subtitle: Text(item.location),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Handle more options button press
                },
              ),
            ),
            // CachedNetworkImage(
            //   imageUrl: item.imageUrl,
            //   fit: BoxFit.cover,
            //   placeholder: (context, url) => CircularProgressIndicator(),
            //   errorWidget: (context, url, error) => Icon(Icons.error),
            // ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(item.content),
            ),
            ButtonBar(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle like button press
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Handle comment button press
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
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
