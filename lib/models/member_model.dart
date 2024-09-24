import 'package:project_management_app/models/link_model.dart';

class MemberModel {
  late final String? position;
  late final String? userId;

  late final String? firstName;
  late final String? lastName;
  late final String? email;
  late final String? imageUrl;
  late final String? resumeUrl;
  late final LinkModel? link;

  MemberModel(
      {required this.position,
      required this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.imageUrl,
      this.resumeUrl,
      this.link});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
        position: json['position'].toString(),
        userId: json['id'].toString(),
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        imageUrl: json['image_url'],
        resumeUrl: json['resume_url'],
        link: LinkModel.fromJson(json['link']));
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'id': userId,
      'first_name': firstName.toString(),
      'last_name': lastName.toString(),
      'email': email.toString(),
      'image_url': imageUrl.toString(),
      'resume_url': resumeUrl.toString(),
      'link': link?.toJson() ?? {}
    };
  }
}
