import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/users/repositories/videos_repository.dart';
import 'package:tiktok/features/users/view_models/users_view_model.dart';
import 'package:tiktok/features/videos/models/video_model.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  //#1. Repository 지정 & 로딩
  late final VideosRepository _videosRepository;

  @override
  FutureOr<void> build() {
    _videosRepository = ref.read(videosRepo);
  }

  //#2. 사용자 메서드
  //아바타 이미지 등록후 업데이트용
  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;

    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _videosRepository.uploadVideoFile(
          video,
          user!.uid,
        ); // Storage:파일저장

        print("[Storage에 파일저장 완료]");
        print("1.task 데이터:----------------------------------");
        debugPrint('$task');
        print("2.user 데이터:----------------------------------");
        debugPrint('$user');

        if (task.metadata != null) {
          VideoModel videoModel = VideoModel(
            title: "From FLutter!",
            description: "Hell yeah!",
            fileUrl: await task.ref.getDownloadURL(),
            thumbnailUrl: "",
            creatorUid: user.uid,
            creator: userProfile.name,
            likes: 0,
            comments: 0,
            creatAt: DateTime.now().millisecondsSinceEpoch,
          );

          await _videosRepository.saveVideo(videoModel); // Store:파일정보저장

          //context.pushReplacement("/home");
          context.pop(); //뒤로
          context.pop(); //뒤로

          print("[FireStore에 파일저장 완료]");
        }
      });
    }
  }
}

//#3. Provider 제공
final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
