import 'dart:convert';

FeedModel feedModelFromJson(String response) {
  var jsonResponse= json.decode(response);

  FeedModel user;
  try {
    user= FeedModel.fromJson(jsonResponse);
  } catch(e) {
    print("exception from fromJson: $e");
    print("jsonResponse: $jsonResponse");
    user= FeedModel();
  }

  // github put http
  if(user.github.isNotEmpty && !user.github.startsWith("http")) {
    user.github = "https://${user.github}";
  }

  return user;
}

String feedModelToJson(List<FeedModel> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

// {
// "name": "JaeJun Lee",
// "headline": "Frontend Programmer",
// "number": "+82 10 2858 4900",
// "email": "slugj2020@gmail.com",
// "location": "South Korea",
// "skillsFrontend": [
// "Dart / Flutter",
// "Java",
// "Javascript (Typescript)"
// ],
// "skillsBackend": [
// "Nest",
// "AWS lambda"
// ],
// "experienceYear": 4
// }
class FeedModel {
  bool isVideo;
  String content;
  String location;
  String link;
  String github;
  String number;
  double experienceYear;
  List<String> skillsFrontend;
  List<String> skillsBackend;

  FeedModel({
    this.isVideo = false,
    this.content= '',
    this.location = '',
    this.link = '',
    this.github = '',
    this.number = '',
    this.experienceYear = 0.0,
    List<String>? skillsFrontend,
    List<String>? skillsBackend,
  }) : skillsFrontend = skillsFrontend ?? [],
        skillsBackend = skillsBackend ?? [];

  Map<String, dynamic> toJson() {
    return {
      'isVideo': isVideo,
      'content': content,
      'location': location,
      'link': link,
      'github': github,
      'number': number,
      'experienceYear': experienceYear,
      'skillsFrontend': skillsFrontend,
      'skillsBackend': skillsBackend,
    };
  }

  factory FeedModel.fromJson(Map<String, dynamic> json) {

    dynamic experienceYear= json['experienceYear'];
    double lfExperienceYear= 0.0;
    if(experienceYear != null && experienceYear != 0) {
      lfExperienceYear= experienceYear;
    }

    return FeedModel(
      isVideo: json['isVideo'] ?? '',
      content: json['content'] ?? '',
      location: json['location'] ?? '',
      link: json['link'] ?? '',
      github: json['github'] ?? '',
      number: json['number'] ?? '',
      experienceYear: lfExperienceYear,
      skillsFrontend: List<String>.from(json['skillsFrontend'] ?? []),
      skillsBackend: List<String>.from(json['skillsBackend'] ?? []),
    );
  }
}