import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';

/// StateNotifierProvider is a combination of StateProvider and ChangeNotifierProvider.
final videoEditListProvider = StateNotifierProvider<VideoEditListNotifier, List<UserModel>>
  ((ref) => VideoEditListNotifier());

class VideoEditListNotifier extends StateNotifier<List<UserModel>> {
  VideoEditListNotifier() :
        super([]);

  void addUserModel(UserModel userModel) {
    state = [...state, userModel];
  }

  void addUserModels(List<UserModel> userModels) {
    state = [...state, ...userModels];
  }
}

