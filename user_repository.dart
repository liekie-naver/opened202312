import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';

class UserRepository {
  //#1.DB 인스턴스

  final FirebaseStorage _storage = FirebaseStorage.instance; //Storage
  final FirebaseFirestore _db = FirebaseFirestore.instance; //Store
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; //Base

  //#2.사용자 메서드
  Future<void> createProfile(UserProfileModel profile) async {
    //Map<String,dynamic>형식의 json 데이터를 넣어야 함.
    await _db.collection("users").doc(profile.uid).set(profile.toJason());
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child("avatars/$fileName");
    // final task = await fileRef.putFile(file);
    debugPrint('file:$file');
    debugPrint('fileName:$fileName');
    await fileRef.putFile(file);
  }

  //아바타 이미지 등록후 업데이트용 Storage
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }
}

//#3. Provider 제공
final userRepo = Provider((ref) => UserRepository());
