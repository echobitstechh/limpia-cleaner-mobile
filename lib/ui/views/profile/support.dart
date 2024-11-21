import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:limpia/state.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app.locator.dart';
import '../../common/ui_helpers.dart';

class Ratings extends StatefulWidget {
  const Ratings({Key? key}) : super(key: key);

  @override
  State<Ratings> createState() => _SupportState();
}

class _SupportState extends State<Ratings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.asset(
                  height: 150, width: 150, 'assets/images/limpiarblue.png'),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 5; i >= 1; i--)
                      Row(
                        children: [
                          Text('$i'),
                          SizedBox(width: 8),
                          Icon(Icons.star, color: Colors.blueAccent, size: 16),
                          SizedBox(width: 4),
                          Container(
                            width: 100,
                            height: 8,
                            color: Colors.blueAccent.withOpacity(i / 5),
                          ),
                        ],
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '4.5',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < 4 ? Colors.orange : Colors.orange[200],
                          size: 24,
                        ),
                      ),
                    ),
                    Text(
                      '52 Reviews',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/pp.png'),
                  horizontalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Courtney Henry'),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: 4.5, // Replace with dynamic rating
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 14.0,
                          ),
                          horizontalSpaceTiny,
                          Text('2 mins ago')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                  'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua'),
            ],
          ),
          spacedDivider,
          verticalSpaceSmall,
          Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/pp.png'),
                  horizontalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cameron Williamson'),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: 4.5, // Replace with dynamic rating
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 14.0,
                          ),
                          horizontalSpaceTiny,
                          Text('2 mins ago')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                  'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua'),
            ],
          ),
          spacedDivider,
          verticalSpaceSmall,
          Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/pp.png'),
                  horizontalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jane Cooper'),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: 3, // Replace with dynamic rating
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 14.0,
                          ),
                          horizontalSpaceTiny,
                          Text('2 mins ago')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                  'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua'),
            ],
          ),
          spacedDivider,
          verticalSpaceSmall,
          // SupportOption(
          //   icon: Icons.email_outlined,
          //   title: "Email Us",
          //   //subtitle: "support@afriprize.com",
          //   onTap: () async {
          //     sendEmail("support@afriprize.com", context);
          //   },
          // ),
          // SupportOption(
          //   icon: Icons.help_outline,
          //   title: "FAQs",
          //   subtitle: "",
          //   onTap: () {
          //     goToFaqs('https://afriprize.com/faq');
          //   },
          // ),
        ],
      ),
    );
  }
}

Future<void> sendEmail(String emailAddress, BuildContext context) async {
  EmailContent email = EmailContent(
    to: [
      emailAddress,
    ],
    bcc: ['dev@afriprize.com'],
  );

  OpenMailAppResult result = await OpenMailApp.composeNewEmailInMailApp(
      nativePickerTitle: 'Select email app to compose', emailContent: email);
  if (!result.didOpen && !result.canOpen) {
    showNoMailAppsDialog(context);
  } else if (!result.didOpen && result.canOpen) {
    showDialog(
      context: context,
      builder: (_) => MailAppPickerDialog(
        mailApps: result.options,
        emailContent: email,
      ),
    );
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Open Mail App"),
        content: const Text("No mail apps installed"),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

// Future<void> _makePhoneCall(String phoneNumber) async {
//   final Uri launchUri = Uri(
//     scheme: 'tel',
//     path: phoneNumber,
//   );
//   await launchUrl(launchUri);
// }

Future<void> goToFaqs(String url) async {
  final Uri toLaunch =
      Uri(scheme: 'https', host: 'www.afriprize.com', path: '/faq');

  if (!await launchUrl(toLaunch, mode: LaunchMode.inAppBrowserView)) {
    throw Exception('Could not launch $url');
  }
}

// Future<void> chatOnWhatsApp(String phoneNumber) async {
//   // Format the phone number for WhatsApp URL
//   String formattedPhoneNumber = phoneNumber.replaceAll('+', '').replaceAll(' ', '');
//   final Uri whatsappUri = Uri.parse("https://wa.me/$formattedPhoneNumber");
//
//   if (!await launchUrl(whatsappUri, mode: LaunchMode.inAppBrowserView)) {
//     locator<SnackbarService>().showSnackbar(message: "WhatsApp not installed");
//   }
// }

Future<void> _launch(Uri url) async {
  await canLaunchUrl(url)
      ? await launchUrl(url)
      : locator<SnackbarService>().showSnackbar(message: "No app found");
}

class SupportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap; // Callback for tap event

  const SupportOption({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle = "",
    this.onTap, // Accept the onTap callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use the onTap callback when the item is tapped
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: uiMode.value == AppUiModes.dark
              ? kcDarkGreyColor
              : kcWhiteColor, // Replace with your color
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.orange), // Replace with your color
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600, // Replace with your color
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/images/Arrow - Right.svg',
              color: uiMode.value == AppUiModes.dark
                  ? kcWhiteColor
                  : kcPrimaryColor,
              height: 28, // Icon size
            )
          ],
        ),
      ),
    );
  }
}
