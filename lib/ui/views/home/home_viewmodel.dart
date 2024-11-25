import 'package:limpia/app/app.bottomsheets.dart';
import 'package:limpia/app/app.dialogs.dart';
import 'package:limpia/app/app.locator.dart';
import 'package:limpia/ui/common/app_strings.dart';
import 'package:limpia/ui/views/dashboard/dashboard_view.dart';
import 'package:limpia/ui/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
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

}
