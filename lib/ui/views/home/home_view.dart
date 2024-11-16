import 'dart:ui';

import 'package:limpia/app/app.router.dart';
import 'package:limpia/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import 'home_viewmodel.dart';
import 'module_switch.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {
    viewModel.checkForUpdates(context);

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

              // Floating Cart Button
              ValueListenableBuilder<List<dynamic>>(
                valueListenable: raffleCart, // Replace with your cart notifier
                builder: (context, cartItems, _) {
                  if (raffleCart.value.isNotEmpty && viewModel.selectedRafflesTab != 3) {

                    // Calculate total number of tickets and total amount
                    int totalTickets = raffleCart.value.fold(0, (sum, item) => sum + (item.quantity ?? 0));
                    int totalAmount = raffleCart.value.fold(0, (sum, item) => sum + ((item.quantity ?? 0) * (item.raffle?.ticketPrice ?? 0)));

                    return Positioned(
                      bottom: 20, // Adjust the value to control how high above the bottom it should be
                      left: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to cart page
                          locator<NavigationService>().navigateToCartView();
                        },
                        child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: kcSecondaryColor,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Bag.svg', // Replace with your cart icon
                                    height: 24,
                                    color: kcBlackColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Go to Cart',
                                        style: const TextStyle(
                                          color: kcPrimaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${cartItems.length} Raffle, $totalTickets Tickets.',
                                        style: const TextStyle(
                                          color: kcPrimaryColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      color: kcPrimaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '₦$totalAmount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
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
    if(userLoggedIn.value == true){
      viewModel.fetchOnlineCart();
    }
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
        Color selectedColor = kcSecondaryColor;

        List<BottomNavigationBarItem> items = [
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/home_outline.svg',
            label: "Home",
            isSelected: viewModel.selectedShopTab == 0,
          ),
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/book',
            label: "Book",
            isSelected: viewModel.selectedShopTab == 1,
          ),
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/message-square',
            label: "Messages",
            isSelected: viewModel.selectedShopTab == 2,
          ),
          _buildBottomNavigationBarItem(
            iconPath: 'assets/icons/settings',
            label: "Settings",
            isSelected: viewModel.selectedShopTab == 3,
          ),
        ];

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(color: selectedColor),
          selectedItemColor: selectedColor,
          unselectedItemColor: iconColor,
          onTap: (index) => viewModel.changeSelected(index, currentModule),
          currentIndex: viewModel.selectedShopTab,
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
        '$iconPath${isSelected ? '_selected' : ''}.svg',
        color: isSelected ? kcSecondaryColor : Colors.grey,
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
