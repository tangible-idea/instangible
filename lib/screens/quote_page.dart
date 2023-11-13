
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/model/quotes.dart';
import 'package:instagible/riverpod/quote_provider.dart';
import 'package:instagible/utils/ai_utils.dart';

import '../riverpod/simple_state_provider.dart';

class QuotePage extends ConsumerStatefulWidget {
  static String id= "QuotePage";

  @override
  QuoteState createState() => QuoteState();
}

class QuoteState extends ConsumerState<QuotePage> {

  @override
  initState() {
  }


  Widget widgetQuoteContent(Quote quote) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${quote.content}\n${quote.author}"),
        Image.network(quote.authorImage!)
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    var quoteRef= ref.watch(futureQuoteProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: quoteRef.when(
              data: (data)=> widgetQuoteContent(data),
              error: (err, stack) => Text(err.toString()),
              loading: ()=> const Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }

}
