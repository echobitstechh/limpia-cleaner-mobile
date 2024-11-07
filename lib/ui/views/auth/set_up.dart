import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:limpia/core/data/models/country.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/components/submit_button.dart';
import 'package:limpia/ui/components/text_field_widget.dart';
import 'package:limpia/ui/views/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:limpia/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:csc_picker/csc_picker.dart';
import '../../common/ui_helpers.dart';

class SetUp extends StatefulWidget {
  const SetUp({Key? key}) : super(key: key);

  @override
  State<SetUp> createState() => _RegisterState();
}

class _RegisterState extends State<SetUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Country> countries = [];
  final List<String> genderOptions = ['Kaduna', 'Abuja'];

  bool? loadingCountries = false;
  String? countryValue;
  String? stateValue;
  String? cityValue;

  // List of cleaning services
  final List<String> cleaningServices = [
    'House Cleaning',
    'Office Cleaning',
    'Carpet Cleaning',
    'Deep Cleaning',
    'Window Cleaning',
    'Kitchen Cleaning',
    'Window Cleaning',
  ];

  // List to store selected services
  List<String> selectedServices = [];

  @override
  void initState() {
    loadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, model, child) => loadingCountries == true
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/images/limpiar_purple.png',
                height: 60,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Set Your Work Preferences",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpaceSmall,
                  Text(
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    "Help cleaners to understand they are tailoring the Job opportunities to their own needs",
                  ),
                  verticalSpaceMedium,
                  CSCPicker(
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                    showStates: true,
                    showCities: true,
                    countryDropdownLabel: "Choose Country",
                    stateDropdownLabel: "Choose State",
                    cityDropdownLabel: "Choose City",
                    selectedItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                    disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    searchBarRadius: 10.0,
                  ),
                  verticalSpaceMedium,
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
                          "Select Services You Offer",
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline_outlined),
                          onPressed: () {
                            _showCleaningServicesDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  // Display selected services
                  if (selectedServices.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: selectedServices
                          .map((service) => Chip(
                        label: Text(service),
                      ))
                          .toList(),
                    ),
                  Text(
                    "Choose Your Availability",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "Weekdays",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "Weekends",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "Morning",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "Afternoon",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "Evening",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Text(
                    "Schedule  Date (Optional)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  verticalSpaceMedium,
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Choose your preferred job Type',
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 13),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFCC9933)),
                      ),
                    ),
                    value: model.selectedGender,
                    onSaved: (String? newValue) {
                      model.selectedGender = newValue!;
                    },
                    onChanged: (String? newValue) {
                      model.selectedGender = newValue!;
                    },
                    items: genderOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a job type' : null,
                  ),
                  verticalSpaceMedium,
                  Text(
                    "Set Your Travel Distance (Optional)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  verticalSpaceMedium,
                  SubmitButton(
                    isLoading: model.isBusy,
                    label: "Save",
                    submit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeView()),

                      );
                    },
                    color: kcPrimaryColor,
                    boldText: true,
                  ),
                  verticalSpaceLarge,
                  const SizedBox(height: 50),
                  verticalSpaceMassive,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to show the dialog box with the list of cleaning services
  void _showCleaningServicesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Cleaning Services'),
              content: SizedBox(
                height: 250.0,
                width: double.maxFinite,
                child: GridView.builder(
                  itemCount: cleaningServices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Display two services per row
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio: 2.5, // Adjust this ratio to control the height/width of the containers
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
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isSelected ? kcPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: isSelected ? kcPrimaryColor : Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            service,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
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
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }


  void loadCountries() async {
    try {
      setState(() {
        loadingCountries = true;
      });
      countries = await loadCountryList();
    } catch (error) {
      print('Error loading countries: $error');
    } finally {
      setState(() {
        loadingCountries = false;
      });
    }
  }

  loadCountryList() {}
}












