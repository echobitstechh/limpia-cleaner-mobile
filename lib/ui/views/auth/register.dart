import 'package:flutter/cupertino.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/components/submit_button.dart';
import 'package:limpia/ui/components/text_field_widget.dart';
import 'package:limpia/ui/views/auth/auth_view.dart';
import 'package:limpia/ui/views/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lottie/lottie.dart' as lot;
import '../../../app/app.locator.dart';
import '../../../core/data/models/place_prediction.dart';
import '../../../core/service/location_service.dart';
import '../../../core/utils/maps_util.dart';
import 'package:location/location.dart' as locationLib;
import '../../common/ui_helpers.dart';
import '../home/home_view.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


class Register extends StatefulWidget {
  // final TabController controller;
  final Function(bool) updateIsLogin;
  const Register({Key? key, required this.updateIsLogin}) : super(key: key);



  @override
  State<Register> createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final locationLib.Location location = locationLib.Location();
  final LocationService _locationService = locator<LocationService>();
  locationLib.LocationData? _locationData;
  List<PlacePrediction>? _autocompleteResults = [];
  PlacePrediction? _selectedAddress;


  @override
  void initState() {
    getService();
    super.initState();
  }

  Future<void> getService() async {
    _locationData = await _locationService.getCurrentLocation();
    if (_locationData != null) {
      setState(() {
        // _setInitialUserMarker();
        // _animateToUserLocation();
      });
      // _fetchCountryCode(_locationData!.latitude!, _locationData!.longitude!);
      var address = await MapsUtils().getAddressFromLatLng(
          _locationData!.latitude!, _locationData!.longitude!);
      var autocompleteresult =
      await MapsUtils().placeAutoComplete(address, _locationData);
      var countryName = await MapsUtils().getCountryFromLatLng(
          _locationData!.latitude!, _locationData!.longitude!);
      setState(() {
        _autocompleteResults = autocompleteresult;
        // _countryName = countryName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, model, child) =>
      _currentPage == 0 ?
          SafeArea(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "roboto"
                        ),
                      ),
                    ],
                  ),
            
                  verticalSpaceMedium,
                  verticalSpaceMedium,
                  TextFieldWidget(
                    labelIcon:  Icon(Icons.person_2_outlined, color: Colors.black),
                    hint: "Name",
                    controller: model.firstname,
                    inputType: TextInputType.name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'required';
                      }
                      return null; // Return null to indicate no validation error
                    },
                  ),
                  verticalSpaceMedium,
                  TextFieldWidget(
                    labelIcon:  Icon(Icons.email_outlined, color: Colors.black),
                    hint: "Email Address",
                    controller: model.email,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'required';
                      }
                      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                        return 'Invalid email address';
                      }
                      return null; // Return null to indicate no validation error
                    },
                  ),
                  verticalSpaceMedium,
                  TextFieldWidget(
                    labelIcon:  Icon(Icons.password_outlined, color: Colors.black),
                    inputType: TextInputType.visiblePassword,
                    hint: "Password",
                    controller: model.password,
                    obscureText: model.obscure,
                    suffix: InkWell(
                      onTap: () {
                        model.toggleObscure();
                      },
                      child:
                          Icon(model.obscure ? Icons.visibility_off : Icons.visibility),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return 'Password must contain at least one lowercase letter';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Password must contain at least one digit';
                      }
                      if (!RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                        return 'Password must contain at least one special character';
                      }
                      return null; // Return null to indicate no validation error
                    },
                  ),
                  verticalSpaceMedium,
                  TextFieldWidget(
                    labelIcon:  Icon(Icons.password_outlined, color: Colors.black),
                    hint: "Confirm password",
                    controller: model.cPassword,
                    obscureText: model.obscure,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password confirmation is required';
                      }
                      if (value != model.password.text) {
                        return 'Passwords do not match';
                      }
                      return null; // Return null to indicate no validation error
                    },
                    suffix: InkWell(
                      onTap: () {
                        model.toggleObscure();
                      },
                      child:
                          Icon(model.obscure ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  verticalSpace(30),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildSearchField("Enter Address", model.addressController, false,
                          false, _selectedAddress),
                      (_autocompleteResults == null || _autocompleteResults!.isEmpty)
                          ? SizedBox()
                          : buildAutocompleteResults(false, model.addressController, model),
                    ],
                  ),
                  verticalSpace(30),
                  Row(
                    children: [
                      horizontalSpaceSmall,
                      Row(
                          children:  [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                gotoLogin();
                              },
                              child: const Text(
                                "login",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kcPrimaryColor,
                                ),
                              ),
                            )
            
                          ]
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  SubmitButton(
                    isLoading: model.isBusy,
                    label: "Continue",
                    submit: () {
                      setState(() {
                        _currentPage = 1;
                      });
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => SetUp()));
                    },
                    color: kcPrimaryColor,
                    boldText: true,
                  ),
                  verticalSpaceLarge,
                  const SizedBox(
                    height: 50,
                  ),
                  verticalSpaceMassive
                ],
              ),
            ),
          ) : buildSetUpPage(model),
    );
  }

  void gotoLogin() {
    widget.updateIsLogin(true);
  }

  Widget buildSearchField(String hintText, TextEditingController controller,
      bool showCurrentLocationIcon, bool disable, PlacePrediction? place) {
    return TextField(
      controller: controller,
      enabled: !disable,
      onChanged: (value) async {
        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> calling click on search');
        var autocompleteResults =
        await MapsUtils().placeAutoComplete(value, _locationData);
        print(
            '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>. auto complete is: $autocompleteResults');
        setState(() {
          _autocompleteResults = autocompleteResults;
        });
      },
      readOnly: false,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.location_city_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }


  Widget buildAutocompleteResults(bool isFullScreen, TextEditingController controller, AuthViewModel model) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _autocompleteResults?.length,
        itemBuilder: (context, index) {
          final prediction = _autocompleteResults?[index];
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(prediction?.mainText ?? ''),
            subtitle: Text(prediction?.secondaryText ?? ''),
            onTap: () async {
              final updatedPrediction =
              await MapsUtils().getPlaceDetails(prediction!);
              if (updatedPrediction != null) {
                final secondaryTextParts = updatedPrediction.secondaryText.split(',');


                if (secondaryTextParts.isNotEmpty) {
                  model.cityValue = secondaryTextParts.first.trim();
                  model.countryValue = secondaryTextParts.last.trim();
                  model.addressValue = updatedPrediction.mainText;
                }

                setState(() {
                    _selectedAddress = updatedPrediction;
                    print("selected address main is: ${_selectedAddress?.mainText}");
                    print("selected address secondary is: ${_selectedAddress?.secondaryText}");
                    print("selected address description is: ${_selectedAddress?.description}");
                    controller.text = updatedPrediction.description;
                    _autocompleteResults = [];
                  FocusScope.of(context).unfocus();
                });
              }
            },
          );
        },
      ),
    );
  }

  Widget buildSetUpPage(AuthViewModel model) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  setState(() {
                    _currentPage = 0;
                  });
                }, icon: const Icon(Icons.arrow_back)),
                const Text(
                  "Set Your Work Preferences",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            verticalSpaceSmall,
            Text(
              style: TextStyle(
                fontSize: 12,
              ),
              "Help cleaners to understand they are tailoring the Job opportunities to their own needs",
            ),
            verticalSpaceMedium,
            Text(
              "Select Services You Offer",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 1.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pick service",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(
                        Icons.add_circle_outline_outlined),
                    onPressed: () {
                      model.showCleaningServicesDialog(context);
                    },
                  ),
                ],
              ),
            ),
            verticalSpaceSmall,
            if (model.selectedServices.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: model.selectedServices
                    .map(
                      (service) => Chip(
                    label: Text(service),
                    deleteIcon:
                    const Icon(Icons.close), // Remove icon
                    onDeleted: () {
                      setState(() {
                        model.selectedServices.remove(
                            service); // Remove the service
                      });
                    },
                  ),
                )
                    .toList(),
              ),
            verticalSpaceMedium,
            buildAvailabilitySection(model),
            verticalSpaceMedium,
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Choose your preferred job Type',
                labelStyle: const TextStyle(
                    color: Colors.black, fontSize: 13),
                floatingLabelStyle:
                const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                  const BorderSide(color: Colors.grey),
                ),
              ),
              value: model.selectedJobType,
              onSaved: (String? newValue) {
                model.selectedJobType = newValue!;
              },
              onChanged: (String? newValue) {
                model.selectedJobType = newValue!;
              },
              items: model.preferedJobTypes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) =>
              value == null ? 'Please select a job type' : null,
            ),
            verticalSpaceMedium,
            Text(
              "Set Your Travel Distance (Optional)",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SubmitButton(
                    isLoading: model.isBusy,
                    label: "Go back",
                    submit: () {
                      setState(() {
                        _currentPage = 0;
                      });
                    },
                    color: kcPrimaryColor,
                    boldText: true,
                  ),
                ),
                horizontalSpaceSmall,
                Expanded(
                  child: SubmitButton(
                    isLoading: model.isBusy,
                    label: "Save",
                    submit: () async {
                      RegistrationResult registrationResult = await model.register();
                      if (registrationResult == RegistrationResult.success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthView(isLogin: true)),
                        );
                      }
                    },
                    color: kcPrimaryColor,
                    boldText: true,
                  ),
                ),
              ],
            ),
            verticalSpaceLarge,
            const SizedBox(height: 50),
            verticalSpaceMassive,
          ],
        ),
      ),
    );
  }


  Widget buildAvailabilitySection(AuthViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!model.isSpecificDateSelected)
          const Text(
            "Choose Your Availability",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        verticalSpaceSmall,

        // Weekdays/Weekends Selection
        if (!model.isSpecificDateSelected)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (model.selectedDays.contains(AvailabilityDay.weekdays)) {
                        model.selectedDays.remove(AvailabilityDay.weekdays);
                      } else {
                        model.selectedDays.add(AvailabilityDay.weekdays);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: model.selectedDays.contains(AvailabilityDay.weekdays)
                            ? kcPrimaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Weekdays",
                      style: TextStyle(
                        fontSize: 16,
                        color: model.selectedDays.contains(AvailabilityDay.weekdays)
                            ? kcPrimaryColor
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (model.selectedDays.contains(AvailabilityDay.weekends)) {
                        model.selectedDays.remove(AvailabilityDay.weekends);
                      } else {
                        model.selectedDays.add(AvailabilityDay.weekends);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: model.selectedDays.contains(AvailabilityDay.weekends)
                            ? kcPrimaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Weekends",
                      style: TextStyle(
                        fontSize: 16,
                        color: model.selectedDays.contains(AvailabilityDay.weekends)
                            ? kcPrimaryColor
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        verticalSpaceSmall,

        // Time Slots Selection
        if (!model.isSpecificDateSelected)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (model.selectedTimes.contains(AvailabilityTime.morning)) {
                        model.selectedTimes.remove(AvailabilityTime.morning);
                      } else {
                        model.selectedTimes.add(AvailabilityTime.morning);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: model.selectedTimes.contains(AvailabilityTime.morning)
                            ? kcPrimaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Morning",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                            model.selectedTimes.contains(AvailabilityTime.morning)
                                ? kcPrimaryColor
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "6AM-12PM",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                            model.selectedTimes.contains(AvailabilityTime.morning)
                                ? kcPrimaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (model.selectedTimes.contains(AvailabilityTime.afternoon)) {
                        model.selectedTimes.remove(AvailabilityTime.afternoon);
                      } else {
                        model.selectedTimes.add(AvailabilityTime.afternoon);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                        model.selectedTimes.contains(AvailabilityTime.afternoon)
                            ? kcPrimaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Afternoon",
                          style: TextStyle(
                            fontSize: 16,
                            color: model.selectedTimes
                                .contains(AvailabilityTime.afternoon)
                                ? kcPrimaryColor
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "12PM-6PM",
                          style: TextStyle(
                            fontSize: 14,
                            color: model.selectedTimes
                                .contains(AvailabilityTime.afternoon)
                                ? kcPrimaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (model.selectedTimes.contains(AvailabilityTime.evening)) {
                        model.selectedTimes.remove(AvailabilityTime.evening);
                      } else {
                        model.selectedTimes.add(AvailabilityTime.evening);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: model.selectedTimes.contains(AvailabilityTime.evening)
                            ? kcPrimaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Evening",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                            model.selectedTimes.contains(AvailabilityTime.evening)
                                ? kcPrimaryColor
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "6PM-12AM",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                            model.selectedTimes.contains(AvailabilityTime.evening)
                                ? kcPrimaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        verticalSpaceMedium,

        // Schedule Specific Date Section
        Row(
          children: [
            Text(
              "Schedule Date (Optional)",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            horizontalSpaceSmall,
            GestureDetector(
                onTap: () => model.showMultiDatePicker(context),
                child: const Icon(Icons.calendar_today)),
          ],
        ),
        // Display Selected Dates Below the Row
        if (model.selectedDates.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: model.selectedDates
                .map((date) => Chip(
              label: Text(
                "${date.day}-${date.month}-${date.year}",
                style: const TextStyle(fontSize: 12),
              ),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  model.selectedDates.remove(date);

                  // Enable availability section if no dates are selected
                  if (model.selectedDates.isEmpty) {
                    model.isSpecificDateSelected = false;
                  }
                });
              },
            ))
                .toList(),
          ),
      ],
    );
  }


}
