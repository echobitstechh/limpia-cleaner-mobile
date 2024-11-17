import 'package:flutter/widgets.dart';
import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.router.dart';
import 'package:limpia/core/utils/local_store_dir.dart';
import 'package:limpia/core/utils/local_stotage.dart';
import 'package:limpia/state.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/common/ui_helpers.dart';
import 'package:limpia/ui/components/profile_picture.dart';
import 'package:limpia/ui/views/profile/order_list.dart';
import 'package:limpia/ui/views/profile/profile_details.dart';
import 'package:limpia/ui/views/profile/refferal.dart';
import 'package:limpia/ui/views/profile/settings.dart';
import 'package:limpia/ui/views/profile/support.dart';
import 'package:limpia/ui/views/profile/ticket_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) {
        viewModel.getProfile();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
            appBar: AppBar(
              leading: null,
              automaticallyImplyLeading: false,
              backgroundColor: kcPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0)
                  )
              ),
              toolbarHeight: 200.0,
              title: Center(
                child: Container(
                  padding:
                  const EdgeInsets.only(left: 7, right: 7, bottom: 7, top: 7),
                  decoration: BoxDecoration(
                    color: uiMode.value == AppUiModes.dark
                        ? kcPrimaryColor.withOpacity(0.7)
                        : kcPrimaryColor  .withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kcPrimaryColor, width: 0),
                  ),
                  child: Center(
                    child: Image.asset(
                        alignment: Alignment.center,
                        'assets/images/settings_dor.png'
                    ),
                  ),
                ),
              ),
            ),
            body: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Profile picture
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: profile.value.profilePic?.url != null
                                      ? NetworkImage(profile.value.profilePic!.url!)
                                  as ImageProvider
                                      : const AssetImage(
                                      'assets/images/default_user.png'),
                                ),
                                horizontalSpaceMedium,
                                // User name and role
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${profile.value.firstname ?? 'User'} ${profile.value.lastname ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: kcPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Cleaner',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: kcPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      viewModel.showChangePP
                          ? Column(
                              children: [
                                verticalSpaceMedium,
                                InkWell(
                                  onTap: () {
                                    viewModel.updateProfilePicture();
                                  },
                                  child: const Text(
                                    "Change Profile Picture",
                                    style: TextStyle(
                                      color: kcSecondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                verticalSpaceMedium,
                                ProfileMenuItem(
                                  icon: 'assets/images/person.svg',
                                  label: 'Profile',
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
                                ),
                                verticalSpaceSmall,
                                ProfileMenuItem(
                                  icon: 'assets/images/wallet.svg',
                                  label: 'Wallet',
                                  onTap: () {
                                    // Navigate to Wallet Page
                                  },
                                ),
                                verticalSpaceSmall,
                                ProfileMenuItem(
                                  icon: 'assets/images/settings.svg',
                                  label: 'Settings',
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (c) {
                                      return Settings();
                                    }));

                                  },
                                ),
                                verticalSpaceSmall,
                                ProfileMenuItem(
                                  icon: 'assets/images/star.svg',
                                  label: 'Ratings',
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (c) {
                                      return const Support();
                                    }));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // verticalSpaceMedium,
                      // Center(
                      //   child: Opacity(
                      //     opacity: 0.4,
                      //     child: GestureDetector(
                      //       onTap: () async {
                      //         locator<NavigationService>()
                      //             .navigateToDeleteAccountView();
                      //       },
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize
                      //             .min, // Ensures the Row takes only the space of its children
                      //         children: [
                      //           Icon(
                      //             Icons.delete,
                      //             color: Colors.red,
                      //           ),
                      //           SizedBox(
                      //               width:
                      //                   8), // Spacing between the icon and text
                      //           Text(
                      //             "Delete Account",
                      //             style: TextStyle(color: Colors.red),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ));
      },
    );
  }

  // @override
  // void onViewModelReady(ProfileViewModel viewModel) {
  //    viewModel.getProfile();
  //   super.onViewModelReady(viewModel);
  // }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();



  Widget buildOption({
    required BuildContext context,
    required String text,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color:(uiMode.value == AppUiModes.dark && isSelected)
              ? kcDarkGreyColor
              : Colors.transparent, // Interior color remains transparent
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected ? kcSecondaryColor : Colors.transparent,
            width: 2.0, // Set the width as needed
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/$icon',
              color: isSelected ? kcSecondaryColor : kcLightGrey,
              height: 20,
            ),
            // Icon(icon, color: isSelected ? kcSecondaryColor : kcPrimaryColor),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                  color: (uiMode.value == AppUiModes.dark && isSelected)
                      ? kcWhiteColor
                      : kcLightGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Panchang",
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 24,
              width: 24,
              color: kcPrimaryColor,
            ),
            horizontalSpaceMedium,
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kcPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
