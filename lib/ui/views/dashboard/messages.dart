
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:limpia/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../../../state.dart';
import '../../common/app_colors.dart';


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
            actions: [
            ],
            // backgroundColor: kcSecondaryColor,
            // // shape: RoundedRectangleBorder(
            // //     borderRadius: BorderRadius.only(
            // //         topLeft: Radius.circular(25.0),
            // //         topRight: Radius.circular(25.0),
            // //         bottomLeft: Radius.circular(25.0),
            // //         bottomRight: Radius.circular(25.0)
            // //     )
            // // ),
            // toolbarHeight: 100.0,
            // title: Center(
            //   child: Container(
            //     padding:
            //         const EdgeInsets.only(left: 7, right: 7, bottom: 7, top: 7),
            //     decoration: BoxDecoration(
            //       color: uiMode.value == AppUiModes.dark
            //           ? kcWhiteColor.withOpacity(0.7)
            //           : kcWhiteColor.withOpacity(0.9),
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(color: kcSecondaryColor, width: 0),
            //     ),
            //     child: Builder(
            //       builder: (context) {
            //         final TabController tabController =
            //             DefaultTabController.of(context);
            //         return Row(
            //           mainAxisSize: MainAxisSize.min,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             // Draws Button
            //             buildOption(
            //               context: context,
            //               text: 'Draws',
            //               icon: 'ticket_star.svg',
            //               isSelected: tabController.index ==
            //                   0, // Selected if on the first tab
            //               onTap: () {
            //                 viewModel.togglePage(
            //                     true); // Updates the view model state
            //                 tabController
            //                     .animateTo(0); // Switch to the first tab
            //                 viewModel.notifyListeners(); // Rebuild on tap
            //               },
            //             ),
            //             // Winners Button
            //             buildOption(
            //               context: context,
            //               text: 'Winners',
            //               icon: 'star.svg',
            //               isSelected: tabController.index ==
            //                   1, // Selected if on the second tab
            //               onTap: () {
            //                 tabController
            //                     .animateTo(1); // Switch to the second tab
            //                 viewModel.notifyListeners(); // Rebuild on tap
            //               },
            //             ),
            //           ],
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
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