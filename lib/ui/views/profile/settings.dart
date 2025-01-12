import 'package:flutter_svg/svg.dart';
import 'package:limpia/ui/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limpia/ui/views/profile/profile_details.dart';

import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';
import '../auth/auth_view.dart';
import '../onboarding/onboarding_view2.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  bool _isDarkTheme = false;
  bool isSalesNotificationEnabled = true;
  bool isNewArrivalsNotificationEnabled = false;
  bool isDeliveryStatusNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Image.asset(
            alignment: Alignment.center,
            'assets/images/limpiarlogo.png'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Settings",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            ),
            verticalSpaceMedium,
            Text(
              "Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Profile"),
                  ),
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Security"),
                  ),
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Notification"),
                  ),
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Privacy"),
                  ),
                ],
              ),
            ),
            verticalSpaceSmall,
            Text(
              "Support & About",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Help & Support"),
                  ),
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Terms and Policies"),
                  ),
                ],
              ),
            ),
            verticalSpaceSmall,
            Text(
              "Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Report a problem"),
                  ),
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor:
                            1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Add account"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnboardingView2(),
                        ),
                      );
                    },
                    leading: SvgPicture.asset(
                      'assets/images/person.svg', // Replace with your SVG file path
                      color: kcPrimaryColor,        // Set the color for the icon
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Log out"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value, {bool hasIcon = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 16)),
              if (hasIcon)

                GestureDetector(
                  onTap: () => _showBottomSheet(context),
                  child: Text(
                    'Change',
                    style: TextStyle(color: kcPrimaryColor),
                  ),
                ),

            ],
          ),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    final newPassword = TextEditingController();
    final oldPassword = TextEditingController();
    final repeatPassword = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Change Password', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              TextFieldWidget(
                hint: "Enter Old Password",
                controller: oldPassword,
              ),
              verticalSpaceMedium,
              TextFieldWidget(
                hint: "New Password",
                controller: newPassword,
              ),
              verticalSpaceMedium,
              TextFieldWidget(
                hint: "Repeat new Password",
                controller: repeatPassword,
              ),
              verticalSpaceMedium,
              SubmitButton(
                isLoading: false,
                label: "Save Password",
                submit: () {},
                boldText: true,
                color: kcPrimaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
