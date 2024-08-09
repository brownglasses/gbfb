import 'package:gfbf/test_ui/screen/PurchaseButton.dart';
import 'package:gfbf/test_ui/utils/DAColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PurchaseMoreScreen extends StatefulWidget {
  const PurchaseMoreScreen({super.key});

  @override
  _PurchaseMoreScreenState createState() => _PurchaseMoreScreenState();
}

class _PurchaseMoreScreenState extends State<PurchaseMoreScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //setStatusBarColor(primaryColor);
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'PurChase More Screen',
        center: true,
        textColor: white,
        color: primaryColor,
      ),
      body: SizedBox(
        width: context.width(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                decoration: boxDecorationDefault(shape: BoxShape.circle),
                child: Image.asset(
                  'images/dating/appLogo.jpg',
                  height: 180,
                )),
            22.height,
            Text(
              'This is the lite version of the dating app',
              style: boldTextStyle(size: 22),
              textAlign: TextAlign.center,
            ),
            16.height,
            PurchaseButton(),
          ],
        ),
      ).paddingAll(16),
    );
  }
}
