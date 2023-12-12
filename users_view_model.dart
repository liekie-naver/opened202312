import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';
import 'package:tiktok/features/users/repositories/user_repository.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  //#1. Repository 지정 & 로딩
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;
  @override
  FutureOr<UserProfileModel> build() async {
    //await Future.delayed(const Duration(seconds: 10));
    _userRepository = ref.read(userRepo); //유저가 계정이 없는 경우
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _userRepository
          .findProfile(_authenticationRepository.user!.uid);
      debugPrint('profile: $profile');
      return UserProfileModel.fromJason(profile!);
    }

    return UserProfileModel.empty();
  }

// emailSigunUp이 리턴하는 것을 받음

  //#2. 외부 호출 메서드
  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    state = const AsyncValue.loading(); // 로딩중 표시인가??

    final profile = UserProfileModel(
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.com",
      name: credential.user!.displayName ?? "Anon",
      bio: "undefined",
      link: "undefined",
      hasAvatar: false,
    );
    await _userRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

//아바타 이미지 등록후 업데이트용
  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    //state 업데이트
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    //FireStore 업데이트
    await _userRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }
}

//#3. Provider 제공
final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
