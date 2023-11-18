
// for quote
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/model/quotes.dart';

import '../utils/ai_utils.dart';


AIUtils aiUtils= AIUtils();

//final genQuoteProvider= StateProvider((ref) => Quote());
final futureQuoteProvider= FutureProvider.autoDispose<Quote>((ref) async {
  var result= await aiUtils.getQuote();
  print("result from Quote: ${result.author}");

  var imageURL= await aiUtils.callImageGenBOT(result.author ?? "");
  print(imageURL);

  var caption= await aiUtils.callGetDescrption(result.content.toString());
  print(caption);

  result.authorImage= imageURL;
  result.caption= caption;
  return result;
});
