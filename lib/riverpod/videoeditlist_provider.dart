import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';

/// StateNotifierProvider is a combination of StateProvider and ChangeNotifierProvider.
final feedEditListProvider = StateNotifierProvider<FeedEditListNotifier, List<FeedModel>>
  ((ref) => FeedEditListNotifier());

class FeedEditListNotifier extends StateNotifier<List<FeedModel>> {
  FeedEditListNotifier() :
        super([]);

  void addFeedModel(FeedModel feedModel) {
    state = [...state, feedModel];
  }

  void addFeedModels(List<FeedModel> feedModels) {
    state = [...state, ...feedModels];
  }
}

