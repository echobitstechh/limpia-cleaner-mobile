import  'package:limpia/core/data/models/country.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/components/submit_button.dart';
import 'package:limpia/ui/components/text_field_widget.dart';
import 'package:limpia/ui/views/auth/auth_viewmodel.dart';
import 'package:limpia/ui/views/auth/set_up.dart';
import 'package:limpia/utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:stacked/stacked.dart';
import 'package:lottie/lottie.dart' as lot;
import '../../../app/app.locator.dart';
import '../../../core/data/models/place_prediction.dart';
import '../../../core/service/location_service.dart';
import '../../../core/utils/maps_util.dart';
import 'package:location/location.dart' as locationLib;
import '../../common/ui_helpers.dart';


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
  List<Country> countries = [];
  final List<String> genderOptions = ['Male', 'Female'];
  final TextEditingController houseAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
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

          Form(
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
                        : buildAutocompleteResults(false, model.addressController),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SetUp()));
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


  Widget buildAutocompleteResults(bool isFullScreen, TextEditingController controller) {
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
                setState(() {
                    _selectedAddress = updatedPrediction;
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

  Widget buildLoadingAnimation() {
    return Center(
      child: lot.Lottie.asset(
        'assets/animations/loading_location.json',
        width: 100,
        height: 100,
        repeat: true,
      ),
    );
  }

}
