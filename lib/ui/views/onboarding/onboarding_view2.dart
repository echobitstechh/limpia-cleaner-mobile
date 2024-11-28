import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../components/empty_state.dart';

class OnboardingView2 extends StatelessWidget {
  const OnboardingView2({Key? key}) : super(key: key);

  get widget => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          return Column(
            children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/images/onboarding.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                                height: screenHeight * 0.5
                            ),
                          ),
                        ],
                      ),
              // Text section
              verticalSpaceSmall,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Work On Your Schedule',
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      'Find Cleaning Jobs, Manage Your Tasks, Get Paid Quickly',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Buttons at the bottom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        locator<NavigationService>().clearStackAndShow(Routes.authView, arguments: const AuthViewArguments(isLogin: false));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: kcPrimaryColor,
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    TextButton(
                      onPressed: () {
                        locator<NavigationService>().clearStackAndShow(Routes.authView, arguments: const AuthViewArguments(isLogin: true));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: kcPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void gotoRegister() {
    widget.updateIsLogin(false);
  }

  void gotologin() {
    widget.updateIsLogin(false);
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    // locator<LocalStorage>().save(LocalStorageDir.onboarded, true);
  }

  @override
  void dispose() {
    // Dispose of the video controller to release resources
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 28,
                              color: kcSecondaryColor,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Panchang",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Panchang",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: EmptyState(
                            animation: item.imageUrl,
                            label: "",
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Page indicator (counter)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages.map((item) {
                  int index = widget.pages.indexOf(item);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: _currentPage == index ? 30 : 8,
                    height: 8,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color:  kcBlackColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  );
                }).toList(),
              ),
              // Bottom buttons
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        widget.onSkip?.call();
                        locator<NavigationService>().clearStackAndShow(Routes.homeView);
                      },
                      child: const Text("Skip", style: TextStyle(color: kcBlackColor),),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          widget.onFinish?.call();
                          locator<NavigationService>().clearStackAndShow(Routes.homeView);
                        } else {
                          _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1
                                ? "Finish"
                                : "Next",
                            style: TextStyle(color: kcBlackColor),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == widget.pages.length - 1
                                ? Icons.done
                                : Icons.arrow_forward,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });
}













