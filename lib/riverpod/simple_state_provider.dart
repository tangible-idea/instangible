import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/model/quotes.dart';
import 'package:instagible/model/user_model.dart';
import 'package:instagible/utils/ai_utils.dart';

final fileProvider= StateProvider((ref) => "test");

final responseProvider= StateProvider((ref) => "answer here.");

final loadingProvider= StateProvider((ref) => false);

final videoLinkProvider= StateProvider((ref) => "");

final selectedFeedProvider= StateProvider((ref) => FeedModel());
