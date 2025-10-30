import 'package:flutter/material.dart';
import 'package:octalian_task1/core/routes/route_names.dart';
import 'package:octalian_task1/core/widgets/custom_onboarding_view.dart';
import 'package:octalian_task1/core/widgets/custom_page_indicator.dart';
import 'package:octalian_task1/presentation/onboarding/model/onboarding_model.dart';
import '../../../core/constants/colors.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  late final PageController _pageController;
  int _currentPageIndex = 0;
  final int _numPages = 3;

  final List<OnboardingModel> _onboardings = [
    OnboardingModel(
      image: 'assets/onboarding/onboarding1.png',
      title: 'Smarter Care Starts\nWith AI',
      description:
      'Track health, behavior, and\nemotions - powered by intelligent\ninsights.',
    ),
    OnboardingModel(
      image: 'assets/onboarding/onboarding2.png',
      title: 'Your One-Stop\nPet Shop',
      description:
      'Discover the products your pet will\nlove - Delivered to your door',
    ),
    OnboardingModel(
      image: 'assets/onboarding/onboarding3.png',
      title: 'Connect with the\nPet-Loving World',
      description:
      'Meet other pet parents, explore\nservices, and share joyful\nmoments.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    Navigator.pushReplacementNamed(context, RouteNames.signup);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              itemCount: _onboardings.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final onboarding = _onboardings[index];
                return CustomOnboardingView(
                  text: onboarding.title,
                  description: onboarding.description,
                  image: onboarding.image,
                  isLast: index == _numPages - 1,
                  pageController: _pageController,
                  numPages: _numPages,
                  onGetStarted: _onGetStarted,
                );
              },
            ),
            Positioned(
              bottom: 30,
              child: CustomPageIndicator(
                controller: _pageController,
                numPages: _numPages,
              ),
            )
          ],
        ),
      ),
    );
  }
}
