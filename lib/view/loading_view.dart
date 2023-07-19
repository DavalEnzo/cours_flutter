import 'dart:async';

import 'package:cours_flutter/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({super.key});

  @override
  State<MyLoading> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  // variable
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentIndex < 3) {
        currentIndex++;
      } else {
        timer.cancel();
      }
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    super.initState();
  }

  Widget dots(int index) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SmoothPageIndicator(
          controller: pageController,
          onDotClicked: (index) => pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
          count: 4,
          effect: const ExpandingDotsEffect(
            dotColor: Colors.black,
            activeDotColor: Colors.deepOrange,
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 2,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // pageview permet de slider entre les pages
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  Center(
                    child: Lottie.asset("assets/animation_lk9qcpqw.json"),
                  ),
                  Center(
                    child: Lottie.asset("assets/animation_lk9qeg0e.json"),
                  ),
                  Center(
                    child: Lottie.asset("assets/animation_lk9qeg0e.json"),
                  ),
                  const MyHomePage(title: "Connexion / Inscription"),
                ],
              ),
              dots(currentIndex),
            ],
          ),
        ),
      ),
    );
  }
}
