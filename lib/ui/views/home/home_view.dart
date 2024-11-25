import 'dart:ui';
import 'package:limpia/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {

    return ValueListenableBuilder<AppModules>(
      valueListenable: currentModuleNotifier, // Your ValueNotifier
      builder: (context, currentModule, child) {
        return Scaffold(
          backgroundColor: currentModuleNotifier.value == AppModules.shop
              ? const Color(0xFFFFF3DB)
              : null,
          body: Stack(
            children: [
              viewModel.currentPage, // Assuming you have separate getters for pages in your viewModel
            ],
          ),
          bottomNavigationBar: BottomNavBar(viewModel: viewModel),
        );
      },
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }
}

class BottomNavBar extends StatelessWidget {
  final HomeViewModel viewModel;

  BottomNavBar({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppModules>(
      valueListenable: currentModuleNotifier,
      builder: (context, currentModule, _) {
        Color iconColor = Colors.grey;
        Color selectedColor = kcPrimaryColor;

        List<BottomNavigationBarItem> items = [
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/home_outline.svg',
            label: "Home",
            isSelected: viewModel.selectedBarTab == 0,
          ),
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/book.svg',
            label: "Book",
            isSelected: viewModel.selectedBarTab == 1,
          ),
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/message-square.svg',
            label: "Messages",
            isSelected: viewModel.selectedBarTab == 2,
          ),
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/settings.svg',
            label: "Settings",
            isSelected: viewModel.selectedBarTab == 3,
          ),
        ];

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(color: selectedColor),
          selectedItemColor: selectedColor,
          unselectedItemColor: iconColor,
          onTap: (index) => viewModel.changeSelected(index, currentModule),
          currentIndex: viewModel.selectedBarTab,
          items: items,
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        '$iconPath',
        color: isSelected ? kcPrimaryColor : Colors.grey,
        height: 24,
      ),
      label: label,
    );
  }






// Widget _navBarItemWithCounter(String icon, bool isSelected, ValueListenable<List<dynamic>> counterListenable, Color color) {
  //   return ValueListenableBuilder<List<dynamic>>(
  //     valueListenable: counterListenable,
  //     builder: (context, value, child) {
  //       return Stack(
  //         clipBehavior: Clip.none,
  //         children: [
  //           _navBarItemIcon(icon, isSelected, color),
  //           if (value.isNotEmpty)
  //             Positioned(
  //               right: -6,
  //               top: -6,
  //               child: Container(
  //                 padding: const EdgeInsets.all(4),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.red,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: Text(
  //                   '${value.length}',
  //                   style: const TextStyle(color: Colors.white, fontSize: 12),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
