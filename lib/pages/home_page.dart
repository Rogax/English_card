// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_card/models/english_today.dart';
import 'package:english_card/packages/quote/qoute_model.dart';
import 'package:english_card/packages/quote/quote.dart';
import 'package:english_card/pages/all_page.dart';
import 'package:english_card/pages/all_words_page.dart';
import 'package:english_card/pages/control_page.dart';
import 'package:english_card/values/app_assets.dart';
import 'package:english_card/values/app_colors.dart';
import 'package:english_card/values/app_styles.dart';
import 'package:english_card/values/share_key.dart';
import 'package:english_card/widgets/app_button.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int _currentIndex = 0;
  late PageController _pageController;
  List<EnglishToday> words = [];
  String quote = Quotes().getRandom().content!;
  List<int> fixedListRamdom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKeys.couter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRamdom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });
    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    getEnglishToday();
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: size.height * 1 / 10,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerLeft,
              child: Text(
                '"$quote"',
                style: AppStyle.h5.copyWith(
                  fontSize: 16,
                  color: AppColors.textColor,
                ),
              ),
            ),
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: words.length > 5 ? 6 : words.length,
                itemBuilder: (context, index) {
                  String firstLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  firstLetter = firstLetter.substring(0, 1);
                  String leftLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  leftLetter = leftLetter.substring(1, leftLetter.length);
                  String quoteDefault =
                      "Think of all the beauty still left around you and be happy";
                  String qoute = words[index].quote != null
                      ? words[index].quote!
                      : quoteDefault;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: AppColors.primaryColor,
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            words[index].isFavorite = !words[index].isFavorite;
                          });
                        },
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        child: index >= 5
                            ? Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AllWordsPage(
                                            words: this.words,
                                          ),
                                        ));
                                  },
                                  child: Center(
                                    child: Text(
                                      'Show more...',
                                      style: AppStyle.h3.copyWith(shadows: [
                                        BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(2, 3),
                                            blurRadius: 6)
                                      ]),
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    child: LikeButton(
                                      onTap: (isLiked) async {
                                        setState(() {
                                          words[index].isFavorite =
                                              !words[index].isFavorite;
                                        });
                                        return words[index].isFavorite;
                                      },
                                      isLiked: words[index].isFavorite,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      size: 42,
                                      circleColor: CircleColor(
                                          start:
                                              Color.fromARGB(255, 255, 0, 119),
                                          end: Color.fromARGB(255, 204, 0, 37)),
                                      bubblesColor: BubblesColor(
                                        dotPrimaryColor:
                                            Color.fromARGB(255, 255, 0, 119),
                                        dotSecondaryColor:
                                            Color.fromARGB(255, 204, 0, 37),
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return ImageIcon(
                                          AssetImage(AppAssets.heart),
                                          color: isLiked
                                              ? Colors.red
                                              : Colors.white,
                                        );
                                      },
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.all(16),
                                  //   alignment: Alignment.centerRight,
                                  //   child: Image.asset(
                                  //     AppAssets.heart,
                                  // color: words[index].isFavorite
                                  //     ? Colors.red
                                  //     : Colors.white,
                                  //   ),
                                  // ),
                                  Container(
                                    padding: EdgeInsets.only(left: 12),
                                    child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      text: TextSpan(
                                          text: firstLetter.toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: FontFamily.sen,
                                              fontSize: 89,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    offset: Offset(3, 6),
                                                    blurRadius: 6)
                                              ]),
                                          children: [
                                            TextSpan(
                                              text: leftLetter,
                                              style: TextStyle(
                                                  fontFamily: FontFamily.sen,
                                                  fontSize: 56,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    BoxShadow(blurRadius: 0)
                                                  ]),
                                            )
                                          ]),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 24, right: 12, left: 12),
                                      child: AutoSizeText(
                                        '"$qoute"',
                                        style: AppStyle.h4.copyWith(
                                            color: AppColors.textColor,
                                            letterSpacing: 1),
                                      ))
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _currentIndex >= 5
                ? Container()
                : Container(
                    height: 12,
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    alignment: Alignment.center,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return buildIndicator(index == _currentIndex, size);
                      },
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          // ignore: avoid_print
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lighBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Your mind',
                  style: AppStyle.h3.copyWith(color: AppColors.textColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppButton(
                    label: 'Favorites',
                    onTap: () {
                      print('Favorites');
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppButton(
                    label: 'Your control',
                    onTap: () {
                      print('Your control');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ControlPage(),
                          ));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lighBlue : AppColors.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }

  Widget buildShowMore() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        borderRadius: BorderRadius.circular(24),
        elevation: 4,
        color: AppColors.primaryColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllWordsPage(
                    words: this.words,
                  ),
                ));
          },
          splashColor: Colors.black38,
          borderRadius: BorderRadius.circular(24),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Show more',
                style: AppStyle.h5,
              )),
        ),
      ),
    );
  }
}
