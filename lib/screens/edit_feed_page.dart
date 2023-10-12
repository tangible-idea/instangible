import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/simple_state_provider.dart';

class EditFeedPage extends ConsumerWidget {
  static String id = "/edit";
  const EditFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selecteFeedProvider= ref.watch(selectedFeedProvider.notifier);

    return selecteFeedProvider.state.isEmpty ?
        const Placeholder()
        : Image(
        image: CachedNetworkImageProvider(
            selecteFeedProvider.state
        ),
      );
  }
}
