import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileProvider= StateProvider((ref) => "test");

final responseProvider= StateProvider((ref) => "answer here.");


final loadingProvider= StateProvider((ref) => false);


final videoLinkProvider= StateProvider((ref) => "");


final selectedFeedProvider= StateProvider((ref) => "");
