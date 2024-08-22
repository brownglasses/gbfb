import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';

import 'package:gfbf/utils/colors.dart';
import 'package:gfbf/utils/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileViewScreen extends HookConsumerWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewViewModelProvider);

    useEffect(() {
      Future.microtask(
          () => ref.read(profileViewViewModelProvider.notifier).getMyProfile());
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        title: const Text('프로필'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (profile) => ProfileDetails(profile: profile),
        error: (message) => Center(child: Text('Error: $message')),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final ProfileModel profile;

  const ProfileDetails({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 둥근 모서리 사진
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(profile.photoUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              12.height,
              // 2. 해시태그 스타일의 프로필 정보
              Wrap(
                spacing: 8.0, // 해시태그 사이의 간격
                runSpacing: 4.0, // 줄 사이의 간격
                children: [
                  _buildProfileTag('# ${profile.university ?? '정보 없음'}'),
                  _buildProfileTag('# ${profile.age ?? '정보 없음'}세'),
                  _buildProfileTag('# ${profile.height ?? '정보 없음'}cm'),
                  _buildProfileTag('# ${profile.smoking ? "흡연" : "비흡연"}'),
                  _buildProfileTag('# ${profile.religion ?? '정보 없음'}'),
                  _buildProfileTag('# ${profile.mbti ?? '정보 없음'}'),
                  _buildProfileTag('# ${profile.body ?? '정보 없음'}'),
                ],
              ),
              12.height,
              // 3. 저는 이런 사람이에요 (Bio)
              Text('저는 이런 사람이에요', style: primaryTextStyle(size: 16)),
              AppTextField(
                controller: TextEditingController(text: profile.bio),
                textFieldType: TextFieldType.MULTILINE,
                decoration: buildInputDecoration(
                  borderColor: transparentColor,
                ),
                maxLines: 4,
              ).paddingOnly(top: 8, bottom: 16),

              // 4. 관심사 (Interests)
              Text('평소에는 이런 것들을 즐겨요', style: primaryTextStyle(size: 16)),
              AppTextField(
                controller: TextEditingController(text: profile.interests),
                textFieldType: TextFieldType.MULTILINE,
                decoration: buildInputDecoration(
                  borderColor: transparentColor,
                ),
                maxLines: 4,
              ).paddingOnly(top: 8, bottom: 16),

              // 5. 만나고 싶은 사람 (Likes)
              Text('이런 사람 만나고 싶어요', style: primaryTextStyle(size: 16)),
              AppTextField(
                controller: TextEditingController(text: profile.likes),
                textFieldType: TextFieldType.MULTILINE,
                decoration: buildInputDecoration(
                  borderColor: transparentColor,
                ),
                maxLines: 4,
              ).paddingOnly(top: 8, bottom: 16),

              // 6. 싫어하는 것 (Dislikes)
              Text('이런 사람은 싫어요', style: primaryTextStyle(size: 16)),
              AppTextField(
                controller: TextEditingController(text: profile.dislikes),
                textFieldType: TextFieldType.MULTILINE,
                decoration: buildInputDecoration(
                  borderColor: transparentColor,
                ),
                maxLines: 4,
              ).paddingOnly(top: 8, bottom: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black87,
        ),
      ),
    );
  }
}
