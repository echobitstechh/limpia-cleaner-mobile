import 'dart:io';

import 'package:limpia/app/app.bottomsheets.dart';
import 'package:limpia/app/app.dialogs.dart';
import 'package:limpia/app/app.locator.dart';
import 'package:limpia/core/utils/config.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/common/app_strings.dart';
import 'package:limpia/ui/views/dashboard/dashboard_view.dart';
import 'package:limpia/ui/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/raffle_cart_item.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';
import '../bookings/booking_view.dart';
import '../dashboard/messages.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();


  int selectedBarTab = 0;

  @override
  void dispose() {
    // Don't forget to remove the listener when the view model is disposed.
    currentModuleNotifier.removeListener(notifyListeners);
    super.dispose();
  }


  // Pages for the Shop dashboard
  List<Widget> shopPages = [
     DashboardView(),
     const BookingView(),
    const Messages(),
    const ProfileView()
  ];

  HomeViewModel() {
    currentModuleNotifier.addListener(notifyListeners);
  }


  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;
  int selectedTab = 0;

  AppModules selectedModule = AppModules.raffle;

  // void toggleModule(bool isRafflesSelected) {
  //   selectedModule = isRafflesSelected ? AppModules.raffle : AppModules.shop;
  //   notifyListeners();
  // }

  void toggleModule(bool isRafflesSelected) {
    currentModuleNotifier.value = isRafflesSelected ? AppModules.raffle : AppModules.shop;
    notifyListeners();
  }

  //for test
  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void changeSelected(int index, AppModules module) {
    // if (index != 0 && !userLoggedIn.value) {
    //   showModalBottomSheet(
    //       context: StackedService.navigatorKey!.currentState!.context,
    //       shape: const RoundedRectangleBorder(
    //           borderRadius: BorderRadius.only(
    //               topRight: Radius.circular(20), topLeft: Radius.circular(20))),
    //       builder: (ctx) {
    //         return Container(
    //           padding: const EdgeInsets.all(30),
    //           height: 200,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               const Text("You need to login to continue"),
    //               verticalSpaceMedium,
    //               SubmitButton(
    //                 isLoading: false,
    //                 label: "Login",
    //                 submit: () {
    //                   locator<NavigationService>().replaceWithAuthView();
    //                 },
    //                 color: kcSecondaryColor,
    //               )
    //             ],
    //           ),
    //         );
    //       });
    //   return;
    //}

      selectedBarTab = index;
      notifyListeners();
  }


  Widget get currentPage {
    return shopPages[selectedBarTab];
  }

  void _showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }



  void showUpdateCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/update.svg',
                  height: 94,
                ),
                const ListTile(
                  title: Text('App Updates', style: TextStyle(fontSize: 22,
                    fontFamily: "Panchang", fontWeight: FontWeight.bold, color: kcSecondaryColor)),
                  subtitle: Text('A new version of Limpia is now available.'
                      ' download now to enjoy our lastest features.', style: TextStyle(fontSize: 13,
                    fontFamily: "Panchang",)),
                ),
                ButtonBar(
                  children: <Widget>[

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Future<void> fetchOnlineCart() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.cartList();
      if (res.statusCode == 200) {
        // Access the 'items' from the response 'data'
        List<dynamic> items = res.data["data"]["items"];

        print('online cart is:  $items');

        // Map the items list to List<RaffleCartItem>
        List<RaffleCartItem> onlineItems = items
            .map((item) => RaffleCartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        // Sync online items with the local cart
        raffleCart.value = onlineItems;

        // Update local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to load cart from server: $e");
    } finally {
      setBusy(false);
    }
  }
}
