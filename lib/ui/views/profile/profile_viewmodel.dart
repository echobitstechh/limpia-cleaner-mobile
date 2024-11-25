import 'dart:io';

import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.logger.dart';
import 'package:limpia/core/data/models/profile.dart';
import 'package:limpia/core/data/repositories/repository.dart';
import 'package:limpia/core/network/api_response.dart';
import 'package:limpia/state.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart' as path;
import 'package:stacked_services/stacked_services.dart';

import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';

class ProfileViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("ProfileViewModel");
  bool showChangePP = false;
  final snackBar = locator<SnackbarService>();

  void toggleShowChangePP() {
    showChangePP = !showChangePP;
    rebuildUi();
  }

  void updateProfilePicture() async {
    setBusy(true);
    //pick photo
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    String oldPath = image!.path;
    String newPath = '${path.withoutExtension(oldPath)}.png';
    File inputFile = File(oldPath);
    File outputFile = File(newPath);


    setBusy(false);
  }

  void getProfile() async {

    final localProfileJson = await locator<LocalStorage>().fetch(LocalStorageDir.profileView);
    if (localProfileJson != null) {
      profile.value = Profile.fromJson(localProfileJson);
      rebuildUi();
    }

    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value = Profile.fromJson(Map<String, dynamic>.from(res.data["data"]));
        await locator<LocalStorage>().save(LocalStorageDir.profileView, res.data["data"]); // Cache updated profile
        rebuildUi(); // Update UI with fresh data
      }
    } catch (e) {
      log.e(e);
    }

    setBusy(false);
  }

  void togglePage(bool bool) {}


  // void getProfile() async {
  //   setBusy(true);
  //   try {
  //     ApiResponse res = await repo.getProfile();
  //     if (res.statusCode == 200) {
  //       profile.value =
  //           Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
  //       rebuildUi();
  //     }
  //   } catch (e) {
  //     log.e(e);
  //   }
  //   setBusy(false);
  // }


}
