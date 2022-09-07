import 'package:english_card/pages/home_page.dart';
import 'package:english_card/values/app_assets.dart';
import 'package:english_card/values/app_colors.dart';
import 'package:english_card/values/app_styles.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Welcome to',
              style: AppStyle.h3,
            ),
          )),
          Expanded(
              child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, //căn điều các phần tử và 2 widget đầu cuối là cận rìa của widget cha
              children: [
                Text(
                  'English',
                  style: AppStyle.h2.copyWith(
                      color: AppColors.blackGrey, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    'Qoutes”',
                    style: AppStyle.h4.copyWith(height: 0.5),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 72),
              child: RawMaterialButton(
                  shape: const CircleBorder(),
                  fillColor: AppColors.lighBlue,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false);
                  },
                  child: Image.asset(AppAssets.rightArrow)),
            ),
          )
        ]),
      ),
    );
  }
}
