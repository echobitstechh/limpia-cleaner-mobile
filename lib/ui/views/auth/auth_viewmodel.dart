import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.logger.dart';
import 'package:limpia/app/app.router.dart';
import 'package:limpia/core/data/repositories/repository.dart';
import 'package:limpia/core/network/api_response.dart';
import 'package:limpia/core/utils/local_store_dir.dart';
import 'package:limpia/core/utils/local_stotage.dart';
import 'package:limpia/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:multi_date_picker/multi_date_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/country.dart';
import '../../../core/data/models/profile.dart';
import '../../common/app_colors.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


enum RegistrationResult { success, failure }

enum AvailabilityDay { weekdays, weekends }

enum AvailabilityTime { morning, afternoon, evening }

class AuthViewModel extends BaseViewModel {
  final log = getLogger("AuthViewModel");
  final repo = locator<Repository>();
  final snackBar = locator<SnackbarService>();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final serviceController = TextEditingController();
  final cityController = TextEditingController();



  String? selectedJobType;
  late String phoneValue = "";
  late PhoneNumber phoneNumber;
  late String countryId = "";
  final password = TextEditingController();
  final cPassword = TextEditingController();
  bool obscure = true;
  bool terms = false;
  bool remember = false;

  final List<String> preferedJobTypes = ['One Time', 'Reoccurring'];

  bool? loadingCountries = false;
  String? countryValue;
  String? addressValue;
  String? cityValue;

  bool isSpecificDateSelected = false;
  List<DateTime> selectedDates = [];
  List<AvailabilityDay> selectedDays = [];
  List<AvailabilityTime> selectedTimes = [];

  // List of cleaning services
  final List<String> cleaningServices = [
    'House Cleaning',
    'Office Cleaning',
    'Carpet Cleaning',
    'Deep Cleaning',
    'Window Cleaning',
    'Kitchen Cleaning',
  ];

  // List to store selected services
  List<String> selectedServices = [];



  init() async {


    String? token = await locator<LocalStorage>().fetch(LocalStorageDir.authToken);
    String? lastEmail = await locator<LocalStorage>().fetch(LocalStorageDir.lastEmail);



    // If remember me is true and we have a token, validate it
    if (token != null && JwtDecoder.isExpired(token)) {
      // bool isValidToken = await validateToken(token);
      // if (isValidToken) {
        userLoggedIn.value = true;
        // Retrieve and set user profile from saved JSON in local storage
        String? userJson =
        await locator<LocalStorage>().fetch(LocalStorageDir.authUser);
        if (userJson != null) {
          profile.value = Profile.fromJson(jsonDecode(userJson));
        }
        locator<NavigationService>().clearStackAndShow(Routes.homeView);
        return;
      // }
    }

    if( token != null && !JwtDecoder.isExpired(token)){
      await locator<LocalStorage>()
          .delete(LocalStorageDir.authToken);
      userLoggedIn.value = false;
    }

    // Set the lastEmail if remember me is true
    if (remember) {
      String? lastEmail =
      await locator<LocalStorage>().fetch(LocalStorageDir.lastEmail);
      if (lastEmail != null) {
        email.text = lastEmail;
      }
    }


    if (lastEmail != null) {
      email.text = lastEmail;
    }
    rebuildUi();
  }

  void showCleaningServicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Text(
                'Select Cleaning Multiple Services',
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              content: SizedBox(
                height: 300.0,
                width: double.maxFinite,
                child: cleaningServices.isEmpty
                    ? Center(
                  child: Text(
                    'No cleaning services available.',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
                    : GridView.builder(
                  itemCount: cleaningServices.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two services per row
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 2.0, // Adjust height/width ratio
                  ),
                  itemBuilder: (context, index) {
                    final service = cleaningServices[index];
                    final isSelected = selectedServices.contains(service);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedServices.remove(service);
                          } else {
                            selectedServices.add(service);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color:
                          isSelected ? kcPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color:
                            isSelected ? kcPrimaryColor : Colors.grey,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            service,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true, // Ensure wrapping
                            maxLines: 2, // Limit to 2 lines
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
     notifyListeners();
    });
  }

  void showMultiDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Dates',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite, // Make the dialog take up available width
            height: 400.0, // Set a fixed height to avoid intrinsic dimensions
            child: MultiDatePicker(
              calendarStartDate: DateTime.now(),
              calendarEndDate: DateTime(2100),
              enableMultiSelect: true,
              onDateSelected: (List<DateTime> dates) {

                  isSpecificDateSelected = true;
                  selectedDates = dates;
                  selectedDays.clear();
                  selectedTimes.clear();
                  notifyListeners();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }


  void toggleRemember() {
    remember = !remember;
    rebuildUi();
  }

  void toggleObscure() {
    obscure = !obscure;
    rebuildUi();
  }

  void toggleTerms() {
    terms = !terms;
    rebuildUi();
  }


  void login() async {
    setBusy(true);

    try {
      ApiResponse res = await repo.login({
        "email": email.text,
        "password": password.text
      });
      if (res.statusCode == 200) {
        print('login response: ${res.data['cleaner']}');
        userLoggedIn.value = true;
        profile.value = Profile.fromJson(Map<String, dynamic>.from(res.data['cleaner']));
        locator<LocalStorage>().save(LocalStorageDir.authToken, res.data['token']);
        locator<LocalStorage>().save(LocalStorageDir.authRefreshToken, res.data['refreshToken']);
        locator<LocalStorage>().save(LocalStorageDir.authUser, jsonEncode(res.data['cleaner']));
        locator<LocalStorage>().save(LocalStorageDir.remember, remember);

        if (remember) {
          locator<LocalStorage>().save(LocalStorageDir.lastEmail, email.text);
        } else {
          locator<LocalStorage>().delete(LocalStorageDir.lastEmail);
        }
        locator<NavigationService>().clearStackAndShow(Routes.homeView);
      } else {
        snackBar.showSnackbar(message: res.data["message"]);
      }
    } catch (e) {
      log.i(e);
    }

    setBusy(false);
  }



  Future<RegistrationResult> register() async {

    // if (!terms) {
    //   snackBar.showSnackbar(message: "Accept terms to continue");
    //   return RegistrationResult.failure;
    // }
    setBusy(true);

    List<String> availabilityTime = [];
    String availability = "";

    if (isSpecificDateSelected) {
      availability = "specific";
      availabilityTime = selectedDates.map((date) {
        return "${date.year}-${date.month}-${date.day}";
      }).toList();
    } else {

      if (selectedDays.contains(AvailabilityDay.weekdays)) {
        availability = "weekdays";
      }
      if (selectedDays.contains(AvailabilityDay.weekends)) {
        availability = availability.isEmpty ? "weekends" : "both";
      }

      // Handle time slots (morning, afternoon, evening)
      availabilityTime = selectedTimes.map((time) {
        switch (time) {
          case AvailabilityTime.morning:
            return "morning";
          case AvailabilityTime.afternoon:
            return "afternoon";
          case AvailabilityTime.evening:
            return "evening";
        }
      }).toList();
    }


    //   {
  //     "firstName": "Jane",
  //   "lastName": "Smith",
  //   "email": "cleaner@domain.com",
  //   "password": "securePassword456",
  //   "address": "456 Oak St, Anytown, USA",
  //   "city": "Anytown",
  //   "countryAndState": "USA, CA",
  //   "preferredLocations": [
  //   "Downtown"
  //   ],
  //   "services": [
  //   "House Cleaning"
  //   ],
  //   "availability": "weekdays",
  //   "availabilityTime": [
  // {
  //   "period": "morning",
  //   "start": "8am",
  //   "end": "12pm"
  // }
  //   ],
  //   "preferredJobType": "part-time"
  // }

    try {
      ApiResponse res = await repo.register({
        "firstName": firstname.text.split(' ').first,
        "lastName": firstname.text.split(' ').length > 1 ? firstname.text.split(' ').sublist(1).join(' ') : '',
        "email": email.text,
        "password": password.text,
        "address": addressValue,
        "city": cityValue,
        "countryAndState": countryValue,
        "preferredLocations": ["Downtown"], // Placeholder for now
        "services": selectedServices,
        "availability": [availability],
        "availabilityTime": availabilityTime,
        "preferredJobType": selectedJobType
      });
      if (res.statusCode == 201) {
        snackBar.showSnackbar(message: res.data["message"]);

        locator<NavigationService>().replaceWithOtpView(email: email.text);
        firstname.text = "";
        lastname.text = "";
        email.text = "";
        phone.text = "";
        password.text = "";
        terms = false;
        setBusy(false);
        return RegistrationResult.success;
      } else {
        setBusy(false);

        if (res.data["message"] is String) {
          snackBar.showSnackbar(message: res.data["message"]);
          return RegistrationResult.failure; // Return failure since it's an error message
        }
        else if (res.data["message"] is List<String>) {
          snackBar.showSnackbar(message: res.data["message"].join('\n'));
          return RegistrationResult.failure; // Return failure since it's an error message
        }
        else if (res.data["message"] is List) {
          snackBar.showSnackbar(message: res.data["message"].join('\n'));
          return RegistrationResult.failure; // Return failure since it's an error message
        } else {
          // Handle unexpected data type (e.g., it's not a string or list)
          snackBar.showSnackbar(message: "Unexpected response format");
          return RegistrationResult.failure;
        }

      }
    } catch (e) {
      log.e(e);
      setBusy(false);
      return RegistrationResult.failure;

    }

  }
}
