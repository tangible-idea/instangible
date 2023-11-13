
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/model/quotes.dart';
import 'package:instagible/riverpod/quote_provider.dart';
import 'package:instagible/utils/ai_utils.dart';

import '../riverpod/simple_state_provider.dart';
import '../styles/txt_style.dart';

class QuotePage extends ConsumerStatefulWidget {
  static String id= "QuotePage";

  @override
  QuoteState createState() => QuoteState();
}

class QuoteState extends ConsumerState<QuotePage> {

  @override
  initState() {
  }


  Widget buildQuoteContent(Quote quote) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            // darken image filter with a generated author image.
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
              child: Image.network(quote.authorImage!, )),
            // Text in center with a quote content.
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                    "${quote.content}\n\n- ${quote.author} -",
                    textAlign: TextAlign.center,
                    style: MyTextStyle.h3),
              ),
            ),

          ]
        )
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
              data: (data)=> buildQuoteContent(data),
              error: (err, stack) => Text(err.toString()),
              loading: ()=> const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Generating a new quote.")
                ],
            ))),
        ),
      );
  }

}
