import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.logger.dart';
import 'package:limpia/core/data/repositories/repository.dart';
import 'package:limpia/core/network/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';

class EnterEmailViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log= getLogger("EnterEmailViewModel");
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final password = TextEditingController();
  final cPassword = TextEditingController();
  final snackBar =  locator<SnackbarService>();
  bool obscure = true;
  bool codeSent = false;

  void toggleObscure() {
    obscure = !obscure;
    rebuildUi();
  }

  void sendCode() async{
    setBusy(true);

    try{
      ApiResponse res=  await repo.forgotPassword({
        "email": emailController.text
      });
      if(res.statusCode == 201){
        snackBar.showSnackbar(message: "Code sent to ${emailController.text}");
        codeSent = true;
      }
    }catch(e){
      snackBar.showSnackbar(message: "Unable to send code");
      throw Exception(e);
    }

    setBusy(false);

  }

  void resetPassword() async{
    setBusy(true);

    try{
      ApiResponse res=  await repo.newPassword({
        "email": emailController.text,
        "otp": codeController.text,
        "password": password.text,
        "confirm_password": cPassword.text
      });
      if(res.statusCode == 201){
        snackBar.showSnackbar(message: "Password Successfully changed");
        locator<NavigationService>()
            .clearStackAndShow(Routes.authView);
      }
    }catch(e){
      throw Exception(e);
    }

    setBusy(false);


  }
}
