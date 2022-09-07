import 'package:english_card/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/app_assets.dart';
import '../values/app_styles.dart';
import '../values/share_key.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initDefaultValue();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKeys.couter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        title: Text(
          'Your control',
          style: AppStyle.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt(ShareKeys.couter, sliderValue.toInt());
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Spacer(),
            Text('How much a number word at once?',
                style: AppStyle.h4
                    .copyWith(color: AppColors.lightGrey, fontSize: 18)),
            Spacer(),
            Text('${sliderValue.toInt()}',
                style: AppStyle.h1.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 150,
                    fontWeight: FontWeight.bold)),
            Slider(
                value: sliderValue,
                min: 5,
                max: 100,
                divisions: 95,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  print('$value');
                  setState(() {
                    sliderValue = value;
                  });
                }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.centerLeft,
              child: Text('slide to set',
                  style: AppStyle.h5.copyWith(color: AppColors.textColor)),
            ),
            Spacer(),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
