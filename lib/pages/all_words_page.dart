import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_card/models/english_today.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_styles.dart';

class AllWordsBoxPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsBoxPage({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        title: Text(
          'English today',
          style: AppStyle.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: words
              .map((e) => Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      maxLines: 1,
                      e.noun ?? '',
                      style: AppStyle.h3.copyWith(shadows: [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(2, 3),
                            blurRadius: 6)
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
