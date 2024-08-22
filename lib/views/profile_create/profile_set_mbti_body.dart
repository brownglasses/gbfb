import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/notifier/user_notifier.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:gfbf/utils/widgets.dart';
import 'package:gfbf/view_models/profile_create_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileSetMbtiBody extends StatefulHookConsumerWidget {
  const ProfileSetMbtiBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileSetMbtiBody();
}

class _ProfileSetMbtiBody extends ConsumerState<ProfileSetMbtiBody> {
  @override
  Widget build(BuildContext context) {
    final profileNotifer = ref.watch(createUserProfileProvider.notifier);
    final userNotifer = ref.watch(userNotifierProvider);
    final user = userNotifer.userModel;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // MBTI 컨트롤러
    final mbtiController = useState<String>("0000");
    // 체형 컨트롤러
    final bodyTypeController = useState<String?>(null);
    bool isFormComplete() {
      print(mbtiController.value);
      return !mbtiController.value.contains('0') &&
          bodyTypeController.value != null &&
          bodyTypeController.value!.isNotEmpty;
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          8.width, // 텍스트와 아이콘 사이의 간격
                          Text('프로필을 \n생성하세요', style: boldTextStyle(size: 30)),
                        ],
                      ),
                      16.height,
                      const Text('MBTI'),
                      16.height,
                      Row(
                        children: [
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'E',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[0] == 'E'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(0, 1, 'E');
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'S',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[1] == 'S'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(1, 2, 'S');
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'T',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[2] == 'T'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(2, 3, 'T');
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'J',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[3] == 'J'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(3, 4, 'J');
                            },
                          ).expand(),
                        ],
                      ),
                      16.height,
                      Row(
                        children: [
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'I',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[0] == 'I'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(0, 1, 'I');
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'N',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[1] == 'N'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(1, 2, 'N');
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'F',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[2] == 'F'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(2, 3, 'F');
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: 'P',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            color: mbtiController.value[3] == 'P'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              mbtiController.value =
                                  mbtiController.value.replaceRange(3, 4, 'P');
                            },
                          ).expand(),
                        ],
                      ),
                      16.height,
                      const Text('체형'),
                      16.height,
                      Row(
                        children: [
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: '마름',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            height: context.width() * 0.2,
                            color: bodyTypeController.value == '마름'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              bodyTypeController.value = '마름';
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: '보통',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            height: context.width() * 0.2,
                            color: bodyTypeController.value == '보통'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              bodyTypeController.value = '보통';
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: '통통',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            height: context.width() * 0.2,
                            color: bodyTypeController.value == '통통'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              bodyTypeController.value = '통통';
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            enableScaleAnimation: false,
                            splashColor: transparentColor,
                            elevation: 0,
                            text: user.gender == "male" ? '근육질' : '볼륨\n있음',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.2,
                            height: context.width() * 0.2,
                            color: bodyTypeController.value == '볼륨있음'
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              bodyTypeController.value = '볼륨있음';
                            },
                          ).expand(),
                        ],
                      ),
                    ],
                  )),
            ),
            Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppButton(
                    elevation: 0,
                    text: '다음',
                    textStyle: boldTextStyle(color: white),
                    width: context.width(),
                    color: AppColors.primary,
                    onTap: () {
                      if (!isFormComplete()) {
                        toast('모든 필드를 입력해 주세요.');
                        return;
                      }
                      profileNotifer.update(
                        (state) => state.copyWith(
                          mbti: mbtiController.value, // MBTI 정보 추가
                          body: bodyTypeController.value, // 체형 정보 추가
                        ),
                      );
                      context.go(
                          '/profile_set_information/profile_set_mbti_body/profile_set_introduce');
                    },
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
