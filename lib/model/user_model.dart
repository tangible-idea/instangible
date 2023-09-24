import 'dart:convert';

UserModel userModelFromJson(String response) {
  var jsonResponse= json.decode(response);

  UserModel user;
  try {
    user= UserModel.fromJson(jsonResponse);
  } catch(e) {
    print("exception from fromJson: $e");
    print("jsonResponse: $jsonResponse");
    user= UserModel();
  }

  // github put http
  if(user.github.isNotEmpty && !user.github.startsWith("http")) {
    user.github = "https://${user.github}";
  }

  return user;
}

String userModelToJson(List<UserModel> data) {
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
class UserModel {
  String name;
  String headline;
  String location;
  String email;
  String github;
  String number;
  double experienceYear;
  List<String> skillsFrontend;
  List<String> skillsBackend;

  UserModel({
    this.name = '',
    this.headline= '',
    this.location = '',
    this.email = '',
    this.github = '',
    this.number = '',
    this.experienceYear = 0.0,
    List<String>? skillsFrontend,
    List<String>? skillsBackend,
  }) : skillsFrontend = skillsFrontend ?? [],
        skillsBackend = skillsBackend ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'headline': headline,
      'location': location,
      'email': email,
      'github': github,
      'number': number,
      'experienceYear': experienceYear,
      'skillsFrontend': skillsFrontend,
      'skillsBackend': skillsBackend,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {

    dynamic experienceYear= json['experienceYear'];
    double lfExperienceYear= 0.0;
    if(experienceYear != null && experienceYear != 0) {
      lfExperienceYear= experienceYear;
    }

    return UserModel(
      name: json['name'] ?? '',
      headline: json['headline'] ?? '',
      location: json['location'] ?? '',
      email: json['email'] ?? '',
      github: json['github'] ?? '',
      number: json['number'] ?? '',
      experienceYear: lfExperienceYear,
      skillsFrontend: List<String>.from(json['skillsFrontend'] ?? []),
      skillsBackend: List<String>.from(json['skillsBackend'] ?? []),
    );
  }
}