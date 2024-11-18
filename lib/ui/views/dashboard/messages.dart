
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:limpia/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../../../state.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';


class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        onModelReady: (viewModel) {
          // viewModel.init();
        },
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                      height: 150,
                      width: 150,
                      'assets/images/limpiarblue.png'
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                          'Message'
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Padding(
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
                            'assets/images/pp.png'),
                      ),
                      horizontalSpaceMedium,
                      // User name and role
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emelie Message you',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Are you coming today',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
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
                            'assets/images/pp.png'),
                      ),
                      horizontalSpaceMedium,
                      // User name and role
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tosin Message you',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'hi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
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
                            'assets/images/pp.png'),
                      ),
                      horizontalSpaceMedium,
                      // User name and role
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Message you',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Im on my way',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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