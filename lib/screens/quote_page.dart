
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/simple_state_provider.dart';

class QuotePage extends ConsumerWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var quoteRef= ref.watch(genQuoteProvider.notifier);

    return const Column(children: [
        Text("content"),
        //Image(image: image)
      ],
    );
  }
}
