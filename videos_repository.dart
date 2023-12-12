import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/video_model.dart';

class VideosRepository {
  //#1.DB 인스턴스

  final FirebaseStorage _storage = FirebaseStorage.instance; //Storage
  final FirebaseFirestore _db = FirebaseFirestore.instance; //Store
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; //Base

  //#2.사용자 메서드
  // Storage:파일저장
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
          "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(video);
  }

  //비디오 fetch 하기

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos() {
    // await _db.collection("videos").where("likes",isGreaterThan:10).get();
    return _db.collection("videos").orderBy("createAt", descending: true).get();
  }

  // Store:파일정보저장
  Future<void> saveVideo(VideoModel videoModel) async {
    await _db.collection("videos").add(videoModel.toJson());
  }
}

//#3. Provider 제공
final videosRepo = Provider((ref) => VideosRepository());
