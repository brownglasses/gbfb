import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:gfbf/utils/widget.dart';
import 'package:gfbf/view_models/profile_create_view_model.dart';
import 'package:gfbf/views/profile_create/profile_set_preference.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';
import 'package:go_router/go_router.dart';

class ProfileSetIntroduce extends StatefulHookConsumerWidget {
  const ProfileSetIntroduce({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSetIntroduceState();
}

class _ProfileSetIntroduceState extends ConsumerState<ProfileSetIntroduce> {
  @override
  Widget build(BuildContext context) {
    final bioController = useTextEditingController();
    final interestController = useTextEditingController();
    final profileNotifer = ref.watch(createUserProfileProvider.notifier);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('프로필 생성'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('자신을 소개해주세요', style: boldTextStyle(size: 24)),
                      8.height,
                      Text(
                        '프로필을 더 완성도 있게 만들어보세요!',
                        style: secondaryTextStyle(),
                      ),
                      20.height,
                      const Text('자기소개',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      8.height,
                      AppTextField(
                        controller: bioController,
                        textFieldType: TextFieldType.MULTILINE,
                        decoration:
                            buildInputDecoration(hintText: '짧게 자신을 소개해주세요'),
                        maxLines: 4,
                      ).paddingBottom(16),
                      const Text('관심사',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      8.height,
                      AppTextField(
                        controller: interestController,
                        textFieldType: TextFieldType.MULTILINE,
                        decoration:
                            buildInputDecoration(hintText: '자신의 관심사를 적어주세요'),
                        maxLines: 4,
                      ).paddingBottom(16),
                      16.height,
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton(
                    width: context.width(),
                    text: '다음',
                    color: AppColors.primary,
                    textStyle: boldTextStyle(color: white),
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onTap: () {
                      profileNotifer.update(
                        (state) => state.copyWith(
                          bio: bioController.text,
                          interests: interestController.text,
                        ),
                      );
                      context.go(
                          '/profile_set_information/profile_set_introduce/profile_set_preference');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
