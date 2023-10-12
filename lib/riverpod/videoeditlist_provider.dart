import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
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


// class VideoNotifier {
//   VideoState state;
//   VideoNotifier(this.state);
// }
//
// enum VideoState {
//   uninitialized,
//   initialized,
// }
//
// final videoNotifierProvider = StateProvider<VideoNotifier>((ref) =>
//     VideoNotifier(VideoState.uninitialized));
//
// final videoControllerProvider =
// Provider.autoDispose<VideoPlayerController>((ref) {
//   final videoUrl = ref.watch(videoUrlProvider);
//   final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl.toString()));
//   controller.initialize().then((_) {
//     ref.read(videoNotifierProvider).state = VideoNotifier(VideoState.initialized);
//   });
//   ref.onDispose(() => controller.dispose());
//   return controller;
// });