import 'package:flutter/material.dart';

class UserProfileModel {
  final bool hasAvatar;
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;

  UserProfileModel({
    required this.hasAvatar,
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
  });

  UserProfileModel.empty()
      : hasAvatar = false,
        uid = "",
        email = "",
        name = "",
        bio = "",
        link = "";

  UserProfileModel.fromJason(Map<String, dynamic> json)
      : hasAvatar = json["hasAvatar"],
        uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"];

  Map<String, dynamic> toJason() {
    debugPrint('UserProfileModel:toJason()');
    return {
      // "hasAvatar": hasAvatar,
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link
    };
  }

  //아바타 이미지 등록후 업데이트용
  UserProfileModel copyWith({
    bool? hasAvatar,
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
  }) {
    debugPrint('UserProfileModel:copyWith()');
    return UserProfileModel(
      hasAvatar: hasAvatar ?? this.hasAvatar,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
    );
  }
}
