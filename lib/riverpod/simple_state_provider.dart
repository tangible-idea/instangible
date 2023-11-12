import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/model/quotes.dart';
import 'package:instagible/model/user_model.dart';

final fileProvider= StateProvider((ref) => "test");

final responseProvider= StateProvider((ref) => "answer here.");

final loadingProvider= StateProvider((ref) => false);

final videoLinkProvider= StateProvider((ref) => "");

final selectedFeedProvider= StateProvider((ref) => FeedModel());

// for quote
final genQuoteProvider= StateProvider((ref) => Quote());
