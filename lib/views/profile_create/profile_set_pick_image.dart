import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:gfbf/utils/widgets.dart';
import 'package:gfbf/view_models/profile_create_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileSetPickImage extends StatefulHookConsumerWidget {
  const ProfileSetPickImage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSetPickImageState();
}

class _ProfileSetPickImageState extends ConsumerState<ProfileSetPickImage> {
  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    final image = useState<File?>(null);
    final profileNotifer = ref.watch(createUserProfileProvider.notifier);
    final viewModel = ref.watch(profileCreateViewModelProvider.notifier);

    void pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image.value = File(pickedFile.path);
      }
    }

    Future<void> createProfileAndShowDialogs() async {
      // 1. 로딩창 띄우기
      showInDialog(
        context,
        builder: (context) => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('프로필 생성 중...', style: TextStyle(fontSize: 18)),
          ],
        ),
        dialogAnimation: DialogAnimation.SCALE,
        barrierDismissible: false,
      );

      // 2. 프로필 생성 작업 수행
      await viewModel.createProfile(profileNotifer.state, image.value);

      // 2초 정도 로딩을 표시한 후
      await Future.delayed(const Duration(seconds: 2));

      // 로딩창 닫기
      finish(context);

      // 3. 프로필 생성 완료! 문구 나타내기
      showInDialog(
        context,
        builder: (context) => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text('프로필 생성 완료!', style: TextStyle(fontSize: 18)),
          ],
        ),
        dialogAnimation: DialogAnimation.SCALE,
        barrierDismissible: false,
      );

      // 1초 후에 성공 메시지 다이얼로그 닫기
      await Future.delayed(const Duration(seconds: 1));
      finish(context);

      // 4. 프로필 페이지로 이동하는 확인 버튼이 있는 다이얼로그 띄우기
      showInDialog(
        context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text('프로필 페이지로 이동하시겠습니까?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            AppButton(
              text: '확인',
              onTap: () {
                finish(context);
                GoRouter.of(context).go('/profile_view');
              },
            ),
          ],
        ),
        dialogAnimation: DialogAnimation.SCALE,
        barrierDismissible: false,
      );
    }

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('프로필 생성'),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '사진 한 장으로 표현하면?',
                            style: boldTextStyle(size: 24),
                          ),
                          8.height,
                          Text(
                            '꼭 얼굴이 아닌 자신을 표현하는 아무 사진이나 괜찮아요',
                            style: secondaryTextStyle(size: 12),
                          ),
                          16.height,
                          AppButton(
                            elevation: 0,
                            text: '이미지 찾기',
                            onTap: pickImage,
                          ),
                          16.height,
                          image.value == null
                              ? placeHolderWidget(
                                  radius: 10,
                                )
                              : Image.file(image.value!),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppButton(
                  width: context.width(),
                  text: '프로필 생성',
                  onTap: image.value != null
                      ? () async {
                          // 프로필 생성 후 다이얼로그 띄우기 및 처리
                          await createProfileAndShowDialogs();
                        }
                      : () {
                          toast('사진을 선택해주세요');
                        },
                  color: image.value != null
                      ? AppColors.primary
                      : Colors.grey, // Use pale red for disabled state
                ),
              ),
            ],
          )),
    );
  }
}
