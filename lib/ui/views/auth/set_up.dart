import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limpia/core/data/models/country.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/components/submit_button.dart';
import 'package:limpia/ui/components/text_field_widget.dart';
import 'package:limpia/ui/views/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:limpia/ui/views/home/home_view.dart';
import 'package:multi_date_picker/multi_date_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:csc_picker/csc_picker.dart';
import '../../common/ui_helpers.dart';

class SetUp extends StatefulWidget {
  const SetUp({Key? key}) : super(key: key);

  @override
  State<SetUp> createState() => _RegisterState();
}

enum AvailabilityDay { weekdays, weekends }

enum AvailabilityTime { morning, afternoon, evening }

class _RegisterState extends State<SetUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Country> countries = [];
  final List<String> preferedJobTypes = ['One Time', 'Reoccurring'];

  bool? loadingCountries = false;
  String? countryValue;
  String? stateValue;
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
                        // CSCPicker(
                        //   onCountryChanged: (value) {
                        //     setState(() {
                        //       countryValue = value;
                        //     });
                        //   },
                        //   onStateChanged: (value) {
                        //     setState(() {
                        //       stateValue = value;
                        //     });
                        //   },
                        //   onCityChanged: (value) {
                        //     setState(() {
                        //       cityValue = value;
                        //     });
                        //   },
                        //   showStates: true,
                        //   showCities: true,
                        //   countryDropdownLabel: "Choose Country",
                        //   stateDropdownLabel: "Choose State",
                        //   cityDropdownLabel: "Choose City",
                        //   selectedItemStyle: const TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 14,
                        //   ),
                        //   dropdownDecoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     border: Border.all(
                        //       width: 1,
                        //     ),
                        //   ),
                        //   disabledDropdownDecoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     color: Colors.grey.shade300,
                        //     border: Border.all(
                        //       color: Colors.grey.shade300,
                        //       width: 1,
                        //     ),
                        //   ),
                        //   searchBarRadius: 10.0,
                        // ),
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
                                  _showCleaningServicesDialog();
                                },
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceSmall,
                        if (selectedServices.isNotEmpty)
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: selectedServices
                                .map(
                                  (service) => Chip(
                                    label: Text(service),
                                    deleteIcon:
                                        const Icon(Icons.close), // Remove icon
                                    onDeleted: () {
                                      setState(() {
                                        selectedServices.remove(
                                            service); // Remove the service
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        verticalSpaceMedium,
                        buildAvailabilitySection(),
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
                                  const BorderSide(color: Color(0xFFCC9933)),
                            ),
                          ),
                          value: model.selectedGender,
                          onSaved: (String? newValue) {
                            model.selectedGender = newValue!;
                          },
                          onChanged: (String? newValue) {
                            model.selectedGender = newValue!;
                          },
                          items: preferedJobTypes
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

  void _showCleaningServicesDialog() {
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
      setState(() {}); // Refresh parent state after modal is closed
    });
  }

  void _showMultiDatePicker(BuildContext context) {
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
                setState(() {
                  isSpecificDateSelected = true;
                  selectedDates = dates;
                  selectedDays.clear();
                  selectedTimes.clear();
                });
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


  Widget buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSpecificDateSelected)
          const Text(
            "Choose Your Availability",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        verticalSpaceSmall,

        // Weekdays/Weekends Selection
        if (!isSpecificDateSelected)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedDays.contains(AvailabilityDay.weekdays)) {
                        selectedDays.remove(AvailabilityDay.weekdays);
                      } else {
                        selectedDays.add(AvailabilityDay.weekdays);
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
                        color: selectedDays.contains(AvailabilityDay.weekdays)
                            ? kcPrimaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Weekdays",
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedDays.contains(AvailabilityDay.weekdays)
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
                      if (selectedDays.contains(AvailabilityDay.weekends)) {
                        selectedDays.remove(AvailabilityDay.weekends);
                      } else {
                        selectedDays.add(AvailabilityDay.weekends);
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
                        color: selectedDays.contains(AvailabilityDay.weekends)
                            ? kcPrimaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Weekends",
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedDays.contains(AvailabilityDay.weekends)
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
        if (!isSpecificDateSelected)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedTimes.contains(AvailabilityTime.morning)) {
                        selectedTimes.remove(AvailabilityTime.morning);
                      } else {
                        selectedTimes.add(AvailabilityTime.morning);
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
                        color: selectedTimes.contains(AvailabilityTime.morning)
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
                                selectedTimes.contains(AvailabilityTime.morning)
                                    ? kcPrimaryColor
                                    : Colors.black,
                          ),
                        ),
                        Text(
                          "6AM-12PM",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                selectedTimes.contains(AvailabilityTime.morning)
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
                      if (selectedTimes.contains(AvailabilityTime.afternoon)) {
                        selectedTimes.remove(AvailabilityTime.afternoon);
                      } else {
                        selectedTimes.add(AvailabilityTime.afternoon);
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
                            selectedTimes.contains(AvailabilityTime.afternoon)
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
                            color: selectedTimes
                                    .contains(AvailabilityTime.afternoon)
                                ? kcPrimaryColor
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "12PM-6PM",
                          style: TextStyle(
                            fontSize: 14,
                            color: selectedTimes
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
                      if (selectedTimes.contains(AvailabilityTime.evening)) {
                        selectedTimes.remove(AvailabilityTime.evening);
                      } else {
                        selectedTimes.add(AvailabilityTime.evening);
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
                        color: selectedTimes.contains(AvailabilityTime.evening)
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
                                selectedTimes.contains(AvailabilityTime.evening)
                                    ? kcPrimaryColor
                                    : Colors.black,
                          ),
                        ),
                        Text(
                          "6PM-12AM",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                selectedTimes.contains(AvailabilityTime.evening)
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
                onTap: () => _showMultiDatePicker(context),
                child: const Icon(Icons.calendar_today)),
          ],
        ),
        // Display Selected Dates Below the Row
        if (selectedDates.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: selectedDates
                .map((date) => Chip(
              label: Text(
                "${date.day}-${date.month}-${date.year}",
                style: const TextStyle(fontSize: 12),
              ),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  selectedDates.remove(date);

                  // Enable availability section if no dates are selected
                  if (selectedDates.isEmpty) {
                    isSpecificDateSelected = false;
                  }
                });
              },
            ))
                .toList(),
          ),
      ],
    );
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
