import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/test_ui/utils/DAWidgets.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gfbf/test_ui/utils/DAColors.dart';

class UserProfileScreen extends HookConsumerWidget {
  const UserProfileScreen({super.key, required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userNotifierProvider).userModel;
    // This hook initializes on first build
    useEffect(() {
      // You can perform initialization or async operations here
      return null; // Return a function to clean up if needed
    }, const []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        foregroundColor: black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("프로필"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                16.height,
                commonCachedNetworkImage(
                  profile.photoUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ).cornerRadiusWithClipRRect(20),
                16.height,
                AppButton(
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                  width: context.width(),
                  color: AppColors.primary,
                  onTap: () {
                    ref
                        .read(sendMatchRequestUseCaseProvider)
                        .execute(user!.uid, profile.uid!);
                    //TODO : if user.uid == null && profile.uid == null, then show Error Dialog
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.telegram, color: white),
                      Text('매칭 신청하기',
                          style: boldTextStyle(color: white),
                          textAlign: TextAlign.center),
                      const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            16.height,
            ProfileInfoHorizontalScroll(profile: profile),
            16.height,
            buildProfileSection('저는 이런 사람이에요!', profile.bio),
            buildProfileSection('이런 사람 만나고 싶어요', profile.likes),
            buildProfileSection('이런 사람은 싫어요', profile.dislikes),
          ],
        ).paddingAll(16),
      ),
    );
  }

  Widget buildProfileSection(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(title, style: boldTextStyle(size: 15)),
        16.height,
        Text(
          content ?? "$title 정보 없음",
          style: secondaryTextStyle(),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}

class ProfileInfoHorizontalScroll extends StatelessWidget {
  const ProfileInfoHorizontalScroll({super.key, required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildProfileInfoTile("대학교", profile.university),
          buildProfileInfoTile("MBTI", profile.mbti),
          buildProfileInfoTile("나이", profile.age?.toString()),
          buildProfileInfoTile("키", profile.height?.toString()),
          buildProfileInfoTile("체형", profile.body),
          buildProfileInfoTile("종교", profile.religion),
        ],
      ),
    );
  }

  Widget buildProfileInfoTile(String title, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title, style: boldTextStyle(size: 16)),
              8.height,
              Text(subtitle ?? "정보 없음", style: secondaryTextStyle()),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
