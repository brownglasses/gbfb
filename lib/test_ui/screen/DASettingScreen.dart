import 'package:gfbf/test_ui/model/DatingAppModel.dart';
import 'package:gfbf/test_ui/utils/DAColors.dart';
import 'package:gfbf/test_ui/utils/DADataGenerator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DASettingScreen extends StatefulWidget {
  const DASettingScreen({super.key});

  @override
  DASettingScreenState createState() => DASettingScreenState();
}

class DASettingScreenState extends State<DASettingScreen> {
  List<DatingAppModel> list = getSettingData();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Setting', titleTextStyle: boldTextStyle(size: 25)),
      body: Column(
        children: [
          16.height,
          ...list.map(
            (e) {
              return Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: grey)),
                width: context.width(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.name!, style: boldTextStyle()),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ).onTap(() {
                e.widget != null
                    ? Navigator.push(
                        context, MaterialPageRoute(builder: (_) => e.widget!))
                    : const SizedBox();
              }, splashColor: white, highlightColor: white);
            },
          ),
          16.height,
          AppButton(
            width: context.width(),
            color: primaryColor,
            onTap: () {
              showConfirmDialog(context, 'Do you want to logout from the app?');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Logout',
                    style: boldTextStyle(color: white),
                    textAlign: TextAlign.center),
                const Icon(Icons.logout, color: white),
              ],
            ),
          ),
        ],
      ).paddingOnly(left: 16, right: 16),
    );
  }
}
