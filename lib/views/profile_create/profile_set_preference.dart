import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:gfbf/utils/widgets.dart';
import 'package:gfbf/view_models/profile_create_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:go_router/go_router.dart';

class ProfileSetPreference extends StatefulHookConsumerWidget {
  const ProfileSetPreference({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSetPreferenceState();
}

class _ProfileSetPreferenceState extends ConsumerState<ProfileSetPreference> {
  @override
  Widget build(BuildContext context) {
    final likeController = useTextEditingController();
    final dislikeController = useTextEditingController();
    final profileNotifer = ref.watch(createUserProfileProvider.notifier);
    final isButtonEnabled = useState<bool>(false);

    final likeLength = useState<int>(0);
    final dislikeLength = useState<int>(0);

    void validateForm() {
      likeLength.value = likeController.text.length;
      dislikeLength.value = dislikeController.text.length;

      isButtonEnabled.value =
          likeLength.value >= 10 && dislikeLength.value >= 10;
    }

    // Attach listeners to the text controllers to validate form input
    likeController.addListener(validateForm);
    dislikeController.addListener(validateForm);

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
                      const Text('이런 사람 만나고 싶어요',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      8.height,
                      AppTextField(
                        controller: likeController,
                        textFieldType: TextFieldType.MULTILINE,
                        decoration:
                            buildInputDecoration(hintText: '두부상, 미소가 매력적인 사람'),
                        maxLines: 4,
                      ),
                      4.height,
                      if (likeLength.value > 0)
                        Text(
                          likeLength.value < 10
                              ? '${10 - likeLength.value}글자 더 작성해주세요!'
                              : '충분히 작성되었습니다.',
                          style: secondaryTextStyle(
                              color: likeLength.value < 10
                                  ? Colors.red
                                  : Colors.green),
                        ),
                      16.height,
                      const Text('이런 사람은 싫어요',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      8.height,
                      AppTextField(
                        controller: dislikeController,
                        textFieldType: TextFieldType.MULTILINE,
                        decoration:
                            buildInputDecoration(hintText: '자유롭게 작성해주세요'),
                        maxLines: 4,
                      ),
                      4.height,
                      if (dislikeLength.value > 0)
                        Text(
                          dislikeLength.value < 10
                              ? '${10 - dislikeLength.value}글자 더 작성해주세요!'
                              : '충분히 작성되었습니다.',
                          style: secondaryTextStyle(
                              color: dislikeLength.value < 10
                                  ? Colors.red
                                  : Colors.green),
                        ),
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
                    onTap: isButtonEnabled.value
                        ? () {
                            profileNotifer.update(
                              (state) => state.copyWith(
                                likes: likeController.text,
                                dislikes: dislikeController.text,
                              ),
                            );
                            context.go(
                                '/profile_set_information/profile_set_mbti_body/profile_set_introduce/profile_set_preference/profile_set_pick_image');
                          }
                        : () {
                            toast("더 입력해주세요");
                          }, // Disable button action when form is incomplete
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
