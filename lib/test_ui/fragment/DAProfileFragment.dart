import 'package:gfbf/test_ui/model/DatingAppModel.dart';
import 'package:gfbf/test_ui/screen/DAProfileViewAllScreen.dart';
import 'package:gfbf/test_ui/screen/DASettingScreen.dart';
import 'package:gfbf/test_ui/screen/DAZoomingScreen.dart';
import 'package:gfbf/test_ui/screen/PurchaseMoreScreen.dart';
import 'package:gfbf/test_ui/utils/DAColors.dart';
import 'package:gfbf/test_ui/utils/DADataGenerator.dart';
import 'package:gfbf/test_ui/utils/DAWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DAProfileFragment extends StatefulWidget {
  const DAProfileFragment({super.key});

  @override
  DAProfileFragmentState createState() => DAProfileFragmentState();
}

class DAProfileFragmentState extends State<DAProfileFragment> {
  List<DatingAppModel> list = getAllListData();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    list.shuffle();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Profile',
        center: true,
        titleTextStyle: boldTextStyle(size: 25),
        showBack: false,
        actions: [
          const Icon(Icons.settings).paddingOnly(right: 16).onTap(() {
            DASettingScreen().launch(context);
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                16.height,
                commonCachedNetworkImage(
                  'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.6.jpg',
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ).cornerRadiusWithClipRRect(75),
                16.height,
                Text('Eren Turkmen', style: boldTextStyle()),
                8.height,
                Text('UI/UX Designer', style: secondaryTextStyle()),
                16.height,
                AppButton(
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    DASettingScreen().launch(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.wifi_tethering_rounded, color: white),
                      Text('Upgrade your profile',
                          style: boldTextStyle(color: white),
                          textAlign: TextAlign.center),
                      const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            16.height,
            Text('Biography', style: boldTextStyle(size: 25)),
            16.height,
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s.',
              style: secondaryTextStyle(),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gallery', style: boldTextStyle()),
                Text('View All', style: primaryTextStyle(color: primaryColor))
                    .onTap(() {
                  const PurchaseMoreScreen().launch(context);
                }),
              ],
            ),
            16.height,
            Wrap(
              runSpacing: 16,
              spacing: 16,
              children: list.take(12).map((e) {
                return commonCachedNetworkImage(
                  e.image,
                  fit: BoxFit.cover,
                  height: 100,
                  width: (context.width() / 3) - 22,
                ).cornerRadiusWithClipRRect(10).onTap(() {
                  DAZoomingScreen(img: e.image).launch(context);
                }, highlightColor: white, splashColor: white);
              }).toList(),
            ),
          ],
        ).paddingOnly(left: 16, right: 16, bottom: 16),
      ),
    );
  }
}
