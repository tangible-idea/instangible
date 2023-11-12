
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/utils/ai_utils.dart';

import '../riverpod/simple_state_provider.dart';

class QuotePage extends ConsumerWidget {
  static String id= "QuotePage";

  QuotePage({super.key}) {
    initPage();
  }
  AIUtils aiUtils= AIUtils();

  initPage() async {
    var result= await aiUtils.getQuote();
    print("result from Quote: ${result.author}");

    var imageURL= await aiUtils.callImageGenBOT(result.author ?? "");
    print(imageURL);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var quoteRef= ref.watch(genQuoteProvider.notifier);

    return const Scaffold(
      body: SafeArea(
        child: Column(children: [
            Text("content"),
            //Image(image: image)
          ],
        ),
      ),
    );
  }
}
