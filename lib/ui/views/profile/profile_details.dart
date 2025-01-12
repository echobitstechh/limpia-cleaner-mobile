import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:path/path.dart' as path;
import '../../../app/app.locator.dart';
import '../../../core/data/models/profile.dart';
import '../../../core/data/repositories/repository.dart';
import '../../../core/network/api_response.dart';
import '../../../state.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/profile_picture.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  bool loading = false;
  final repo = locator<Repository>();
  String shippingId = "";
  bool makingDefault = false;
  bool isUpdating = false;
  final snackBar = locator<SnackbarService>();

  void updateProfilePicture() async {
    setState(() {
      isUpdating = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // Check if an image is selected
    if (image == null) {
      setState(() {
        isUpdating = false;
      });
      print('No image selected.');
      return;
    }

    print('Selected image path: ${image.path}');
    print('Selected image length: ${await File(image.path).length()} bytes');

  }


  void getProfile() async {
    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }
        // Otherwise return null to set default track color
        // for remaining states such as when the switch is
        // hovered, focused, or disabled.
        return null;
      },
    );

    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );

    return Scaffold(
      backgroundColor: uiMode.value == AppUiModes.dark
          ? kcDarkGreyColor
          : kcWhiteColor,
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: kcPrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0)
            )
        ),
        toolbarHeight: 200.0,
        title: Center(
          child: Container(
            padding:
            const EdgeInsets.only(left: 7, right: 7, bottom: 7, top: 7),
            decoration: BoxDecoration(
              color: uiMode.value == AppUiModes.dark
                  ? kcPrimaryColor.withOpacity(0.7)
                  : kcPrimaryColor  .withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kcPrimaryColor, width: 0),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                      alignment: Alignment.center,
                      'assets/images/limpiarlogo.png'
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          // barrierColor: Colors.black.withAlpha(50),
                          // backgroundColor: Colors.transparent,
                          backgroundColor:
                          Colors.black.withOpacity(0.7),
                          builder: (BuildContext context) {
                            return const FractionallySizedBox(
                              heightFactor:
                              1.0, // 70% of the screen's height
                              child: ProfileScreen(),
                            );
                          },
                        );
                        // viewModel.updateProfilePicture();
                      },
                      child: ProfilePicture(
                        size: 100,
                        url: profile.value.profilePic?.url,
                      ),
                    ),
                    // horizontalSpaceLarge,
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          // barrierColor: Colors.black.withAlpha(50),
                          // backgroundColor: Colors.transparent,
                          backgroundColor:
                          Colors.black.withOpacity(0.7),
                          builder: (BuildContext context) {
                            return const FractionallySizedBox(
                              heightFactor:
                              1.0, // 70% of the screen's height
                              child: ProfileScreen(),
                            );
                          },
                        );
                        // viewModel.updateProfilePicture();
                      },
                      child: Container(
                        width: 30, // Width and height of the circle
                        height: 30,
                        decoration: BoxDecoration(
                          color:
                          kcPrimaryColor, // Background color of the circle
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                            kcWhiteColor, // Border color of the circle
                            width: 2, // Border width
                          ),
                        ),
                        child: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: kcWhiteColor, // Icon color
                          size: 18, // Icon size
                        ),
                      ),
                    ),
                  ],
                ),
                horizontalSpaceMedium,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${profile.value.firstName} ${profile.value.lastName}",
                      style: const TextStyle(
                        color: kcPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${profile.value.role}",
                      style: const TextStyle(
                        color: kcPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(profile.value.username ?? "")
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), // Add padding inside the card
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: const Text(
                                'Location:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: '• ',
                                      style: TextStyle(fontSize: 20, color: Colors.black26),
                                      children: <TextSpan>[
                                        TextSpan(text: '${profile.value.address ?? ''}, ${profile.value.countryAndState ?? ''}'),
                                        // TextSpan(text: '\n• '),
                                        // TextSpan(text: '13 banga Distric'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: const Text(
                                'Service Type Offered:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 20, color: Colors.black26),
                                      children: profile.value.services?.asMap().entries.map<TextSpan>((entry) {
                                        int index = entry.key;
                                        String service = entry.value;
                                        return TextSpan(
                                          text: '• $service${index < profile.value.services!.length - 1 ? '\n' : ''}',
                                          style: TextStyle(fontSize: 20, color: Colors.black26),
                                        );
                                      }).toList() ?? [
                                        TextSpan(text: '- No services offered -'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: const Text(
                                'Availability:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: '• ',
                                      style: TextStyle(fontSize: 20, color: Colors.black26),
                                      children: <TextSpan>[
                                        TextSpan(text: 'Days: ${profile.value.availability?.join(', ') ?? ''}'),
                                        TextSpan(text: '\n• '),
                                        TextSpan(text: 'Times: ${profile.value.availabilityTime?.join(', ') ?? ''}'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: const Text(
                                'Completed Jobs:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      // text: '• ',
                                      style: TextStyle(fontSize: 20, color: Colors.black26),
                                      children: <TextSpan>[
                                        TextSpan(text: '- No Completed Jobs Yet -'),
                                        // TextSpan(text: '\n• '),
                                        // TextSpan(text: '1 Rejected'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // ... Other widgets can go here
                    ],
                  ),
                  horizontalSpaceMedium,

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Column(
                      children: [

                      ],
                    ),
                  ),
                  horizontalSpaceLarge,
                ]),
          ),
        ],
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  final String address;
  final String phone;

  const AddressTile({super.key, required this.address, required this.phone});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Address'),
      subtitle: Text(address),
      trailing: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.edit),
          SizedBox(height: 4),
          Icon(Icons.delete),
        ],
      ),
    );
  }
}
