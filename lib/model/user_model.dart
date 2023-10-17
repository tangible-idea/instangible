import 'dart:convert';


String feedModelToJson(List<FeedModel> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

class FeedModel {
  String id;
  bool isVideo;
  String content;
  String displayUrl;
  String link;
  String description;
  String videoViewCount;
  double videoDuration;


  FeedModel({
    this.id= '',
    this.isVideo = false,
    this.content= '',
    this.displayUrl = '',
    this.link = '',
    this.description = '',
    this.videoViewCount = '',
    this.videoDuration = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isVideo': isVideo,
      'content': content,
      'displayUrl': displayUrl,
      'link': link,
      'github': description,
      'video_view_count': videoViewCount,
      'video_duration': videoDuration,
    };
  }

  fromJson(Map<String, dynamic> json) {

    // dynamic experienceYear= json['video_duration'];
    // double lfExperienceYear= 0.0;
    // if(experienceYear != null && experienceYear != 0) {
    //   lfExperienceYear= experienceYear;
    // }

    return FeedModel(
      id: json['id'] ?? '',
      isVideo: json['is_video'] ?? '',
      content: json['content'] ?? '',
      displayUrl: json['display_url'] ?? '',
      link: json['link'] ?? '',
      description: json['edge_media_to_caption']['edges'][0]['node']['text'] ?? '',
      videoViewCount: json['video_view_count'] ?? '',
      videoDuration: json['video_duration']
    );
  }
}