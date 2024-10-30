import 'dart:async';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/raffle_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_bottom_sheet_flutter/top_bottom_sheet_flutter.dart';
import '../../../app/app.locator.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/project.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../widget/AdventureDialog.dart';
import '../notification/projectDetailsPage.dart';
import 'dashboard_viewmodel.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

class DashboardView extends StackedView<DashboardViewModel> {
  DashboardView({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.onboarded == false && viewModel.showDialog && !viewModel.modalShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.modalShown = true; // Set this to true to prevent showing the modal again
        showDialog(
          barrierColor: Colors.black.withOpacity(0.9),
          context: context,
          builder: (BuildContext context) {
            return const AdventureModal();
          },
        ).then((_) {
          // Once the modal is dismissed, update the onboarded status
          locator<LocalStorage>().save(LocalStorageDir.onboarded, true);
          viewModel.showDialog = false;
          viewModel.modalShown = false; // Reset it in case the user reopens the view later
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: uiMode,
          builder: (context, AppUiModes mode, child) {
            return SvgPicture.asset(
              uiMode.value == AppUiModes.dark
                  ? "assets/images/dashboard_logo_white.svg" // Dark mode logo
                  : "assets/images/dashboard_logo.svg",
              width: 150,
              height: 40,
            );
          },
        ),
        centerTitle: false,
        actions: _buildAppBarActions(context, viewModel.appBarLoading, viewModel)

      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshData();
        },
        child: ListView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
          children: [
            _buildShimmerOrContent(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.bricolageGrotesque(
            textStyle:  TextStyle(
              fontSize: 15, // Custom font size
              fontWeight: FontWeight.bold, // Custom font weight
              color: uiMode.value == AppUiModes.dark
                  ? Colors.white // Dark mode logo
                  : Colors.black,


              // Custom text color (optional)
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 60, // Adjust height according to your design
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // First Container
              GestureDetector(
                onTap: () {
                  locator<NavigationService>().navigateToDrawsView();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 110, // Adjust width according to your design
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/images/raffles.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // Second Container
              GestureDetector(
                onTap: () {
                  print('there is the second click');
                  locator<NavigationService>().navigateToNotificationView();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 110, // Adjust width according to your design
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/images/donations.svg', // Second image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // Third Container
              GestureDetector(
                onTap: () {
                  // Action for the third container
                  print('Coming Soon clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 110, // Adjust width according to your design
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/images/shop.svg', // Third image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget doMoreOnAfriprize(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Do More On Afriprize",
          style: GoogleFonts.bricolageGrotesque(
            textStyle: TextStyle(
              fontSize: 15, // Custom font size
              fontWeight: FontWeight.bold, // Custom font weight
              color: uiMode.value == AppUiModes.dark
                  ? Colors.white // Dark mode logo
                  : Colors.black, // Custom text color (optional)
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Setting a fixed height for the ListView to avoid unbounded height issues
        Container(
          height: 80, // You can adjust the height as necessary
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  locator<NavigationService>().navigateToWallet();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: uiMode.value == AppUiModes.dark
                          ? Color(0xFF2E2E2E)
                          : Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: uiMode.value == AppUiModes.dark
                              ? Colors.transparent
                              : kcLightGrey,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // Added padding around the content of the container
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Colored Circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kcSecondaryColor, // Customize the color
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8), // Space between the circle and the text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Instant Wallet Credit",
                                style: GoogleFonts.redHatDisplay(
                                  textStyle: TextStyle(
                                    fontSize: 14, // Custom font size
                                    fontWeight: FontWeight.bold, // Custom font weight
                                    color: uiMode.value == AppUiModes.dark
                                        ? Colors.white
                                        : Colors.black, // Custom text color
                                  ),
                                ),
                              ),
                              verticalSpaceTiny,
                              Text(
                                'Value equal to the ticket\'s value!',
                                style: GoogleFonts.redHatDisplay(
                                  textStyle: TextStyle(
                                    fontSize: 10,
                                    color: uiMode.value == AppUiModes.dark
                                        ? kcWhiteColor
                                        : kcBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Second GestureDetector for Donate to Non-profits
              GestureDetector(
                onTap: () {
                  locator<NavigationService>().navigateToNotificationView();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: uiMode.value == AppUiModes.dark
                          ? Color(0xFF2E2E2E)
                          : Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: uiMode.value == AppUiModes.dark
                              ? Colors.transparent
                              : kcLightGrey,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kcSecondaryColor, // Customize the color
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8), // Space between the circle and the text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Donate to Non-profits",
                                style: GoogleFonts.redHatDisplay(
                                  textStyle: TextStyle(
                                    fontSize: 14, // Custom font size
                                    fontWeight: FontWeight.bold, // Custom font weight
                                    color: uiMode.value == AppUiModes.dark
                                        ? kcWhiteColor
                                        : kcBlackColor,
                                  ),
                                ),
                              ),
                              verticalSpaceTiny,
                              Text(
                                'Supported by our partners',
                                style: GoogleFonts.redHatDisplay(
                                  textStyle: TextStyle(
                                    fontSize: 10,
                                    color: uiMode.value == AppUiModes.dark
                                        ? kcWhiteColor
                                        : kcBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget popularDrawsSlider(BuildContext context, List<Raffle> raffles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Popular Draws",
                  style: GoogleFonts.bricolageGrotesque(
                    textStyle:  TextStyle(
                      fontSize: 16, // Custom font size
                      fontWeight: FontWeight.w700, // Custom font weight
                      color:  uiMode.value == AppUiModes.dark
                          ? kcWhiteColor : kcBlackColor, // Custom text color (optional)
                    ),
                  ),
                ),
                Text(
                  "Explore our most sought-after draws",
                  style: GoogleFonts.redHatDisplay(
                    textStyle: TextStyle(
                      fontSize: 11, // Custom font size
                      fontWeight: FontWeight.w400, // Custom font weight
                      color:  uiMode.value == AppUiModes.dark
                          ? kcWhiteColor : kcWhiteColor, // Custom text color (optional)
                    ),
                  ),
                ),
              ],
            ),
            // Explore Capsule
            InkWell(
              onTap: () {
                locator<NavigationService>().navigateToDrawsView();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kcSecondaryColor
                      .withOpacity(0.2), // Capsule background color
                  borderRadius:
                      BorderRadius.circular(20), // Rounded capsule shape
                ),
                child: Row(
                  children: [
                    Text(
                      "Explore",
                      style: GoogleFonts.redHatDisplay(
                        textStyle: TextStyle(
                          fontSize: 12, // Custom font size
                          color: kcBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: kcSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: raffles.length,
            itemBuilder: (context, index) {
              final raffle = raffles[index];
              final imageUrl = raffle.media?.isNotEmpty == true
                  ? raffle.media![0].url
                  : 'https://via.placeholder.com/150';
              // final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss')
              final formattedEndDate = DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(raffle.endDate ?? ''));

              final endDate = DateTime.parse(raffle.endDate ?? '');
              final now = DateTime.now();
              final remainingDuration = endDate.difference(now);

              double cardHeight = 250; // Default height
              if (index % 3 == 1) {
                cardHeight = 200; // Shorter card
              } else if (index % 3 == 2) {
                cardHeight = 300; // Full-height card
              }

              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                    ),
                    // barrierColor: Colors.black.withAlpha(50),
                    // backgroundColor: Colors.transparent,
                    backgroundColor: Colors.black.withOpacity(0.7),
                    builder: (BuildContext context) {
                      return RaffleDetail(raffle: raffle);
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: cardHeight,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Image covering the entire card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl!,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Tint overlay for better readability
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color:  uiMode.value == AppUiModes.dark
                                ? Colors.black.withOpacity(
                                0.8) : Colors.black.withOpacity(
                                0.6),
                             // Dark semi-transparent overlay
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        // Raffle details positioned on top of the image
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: uiMode.value == AppUiModes.dark
                                  ? kcVeryLightGrey : kcWhiteColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              raffle.formattedTicketPrice ?? '',
                              style: const TextStyle(
                                color: kcPrimaryColor,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 33,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: kcSecondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Ticket Price',
                              style: TextStyle(
                                fontSize: 10,
                                color: kcPrimaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'WIN Prize in',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SlideCountdown(
                                    duration: remainingDuration,
                                    decoration: const BoxDecoration(
                                      // color: kcPrimaryColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    separator: ':',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    onDone: () {
                                      print('Countdown finished!');
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                raffle.name ?? '',
                                style: const TextStyle(
                                  color: kcSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // buildParticipantsAvatars(raffle.participants ?? []),


                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/partcipant_icon.png",
                                    width: 40,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${raffle.participants?.length ?? 0} Participants',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildParticipantsAvatars(List<Participant> participants) {
    return SizedBox(
      height: 25, // Adjust the size to match the avatar size
      child: Stack(
        children: participants.asMap().entries.map((entry) {
          int index = entry.key;
          Participant participant = entry.value;
          double overlapOffset = 20.0; // Control the overlap amount
          return Positioned(
            left: index * overlapOffset,
            child: participant.profilePic?.url != null
                ? ClipOval(
              child: Image.network(
                participant.profilePic!.url!,
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
            )
                : _buildInitialsCircle(participant), // Show initials if no image
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInitialsCircle(Participant participant) {
    String initials = _getInitials(participant);
    return CircleAvatar(
      radius: 12, // Adjust the size if needed
      backgroundColor: kcSecondaryColor, // Customize background color
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white, // Text color for initials
          fontSize: 12, // Adjust the font size if needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(Participant participant) {
    String firstName = participant.firstname?.isNotEmpty == true ? participant.firstname! : '';
    String lastName = participant.lastname?.isNotEmpty == true ? participant.lastname! : '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
  }

  Widget donationsSlider(BuildContext context, List<ProjectResource> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Popular Draws Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Donations",
                  style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                      fontSize: 16, // Custom font size
                      fontWeight: FontWeight.w700, // Custom font weight
                      color: uiMode.value == AppUiModes.dark
                          ? Colors.white // Dark mode logo
                          : Colors.black, // Custom text color (optional)
                    ),
                  ),
                ),
                Text(
                  "Empower Change with Your Points",
                  style: GoogleFonts.redHatDisplay(
                    textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: uiMode.value == AppUiModes.dark
                          ? Colors.white // Dark mode logo
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            // Explore Capsule
            InkWell(
              onTap: () {
                locator<NavigationService>().navigateToNotificationView();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kcSecondaryColor.withOpacity(0.2), // Capsule background color
                  borderRadius: BorderRadius.circular(20), // Rounded capsule shape
                ),
                child: const Row(
                  children: [
                    Text(
                      "Explore",
                      style: TextStyle(
                        color: kcBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: kcSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250, // Adjust height to match the size of your cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index].project;
              final members = projects[index].members;
              final imageUrl = project?.media?.isNotEmpty == true
                  ? project?.media![0].url
                  : 'https://via.placeholder.com/150';

              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailsPage(
                          project: projects[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 222,
                    decoration: BoxDecoration(
                      color: uiMode.value == AppUiModes.dark
                          ? Colors.transparent // Dark mode logo
                          : kcWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      color: uiMode.value == AppUiModes.dark
                          ? kcDarkGreyColor // Dark mode logo
                          : kcWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            child: Image.network(
                              imageUrl!,
                              width: double.infinity, // or specify a width
                              height: 124, // or specify a height
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                            child: Text(
                              project?.projectTitle ?? 'service title',
                              style: GoogleFonts.redHatDisplay(
                                fontSize: 16,
                                color: uiMode.value == AppUiModes.dark
                                    ? kcWhiteColor // Dark mode logo
                                    : kcBlackColor,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 0, 8.0, 8.0),
                            child: Text(
                              project?.projectDescription ?? '',
                              style: GoogleFonts.redHatDisplay(
                                fontSize: 12,
                                color: uiMode.value == AppUiModes.dark
                                    ? kcWhiteColor // Dark mode logo
                                    : kcBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: buildMembersAvatars(members ?? []),
                            // Row(
                            //   children: [
                            //     Image.asset(
                            //       "assets/images/partcipant_icon.png",
                            //       width: 40,
                            //     ),
                            //     const SizedBox(width: 4),
                            //     Text(
                            //       '${members?.length ?? 0} Participants',
                            //       style: GoogleFonts.redHatDisplay(
                            //         fontSize: 10,
                            //         color: uiMode.value == AppUiModes.dark
                            //             ? kcWhiteColor // Dark mode logo
                            //             : kcBlackColor,
                            //         fontWeight: FontWeight.w400,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildMembersAvatars(List<Member> participants) {
    double avatarSize = 20.0;
    double overlapOffset = 15.0; // Adjust the overlap amount

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Constrain the Stack with a specific width
        SizedBox(
          height: avatarSize,
          width: participants.length * overlapOffset + avatarSize, // Ensure a finite width
          child: Stack(
            children: participants.asMap().entries.map((entry) {
              int index = entry.key;
              Member participant = entry.value;

              return Positioned(
                left: index * overlapOffset,
                child: ClipOval(
                  child: participant.profilePic?.url != null
                      ? Image.network(
                    participant.profilePic!.url!,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                  )
                      : _buildMembersInitialsCircle(participant),
                ),
              );
            }).toList(),
          ),
        ),
          Text(
            ' ${participants.length} Participants',
            style: GoogleFonts.redHatDisplay(
              fontSize: 10,
              color: uiMode.value == AppUiModes.dark
                  ? kcWhiteColor // Dark mode logo
                  : kcBlackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }


  Widget _buildMembersInitialsCircle(Member participant) {
    String initials = _getMemberInitials(participant);
    return CircleAvatar(
      radius: 10, // Adjust the size if needed
      backgroundColor: kcSecondaryColor, // Customize background color
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white, // Text color for initials
          fontSize: 10, // Adjust the font size if needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getMemberInitials(Member participant) {
    String firstName = participant.firstname?.isNotEmpty == true ? participant.firstname! : '';
    String lastName = participant.lastname?.isNotEmpty == true ? participant.lastname! : '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
  }

  Widget _buildShimmerOrContent(
      BuildContext context, DashboardViewModel viewModel) {
    if (viewModel.raffleList.isEmpty && viewModel.isBusy) {
      return Column(
        children: [
          _buildShimmerContainer(), // shimmer for video player placeholder
          verticalSpaceSmall,
          _buildShimmerQuickActions(), // shimmer for quick actions
          verticalSpaceMedium,
          _buildShimmerQuickActions(), // shimmer for quick actions
          verticalSpaceMedium,
          _buildShimmerSlider(), // shimmer for raffle list
          verticalSpaceMedium,
          _buildShimmerSlider(), // shimmer for donations
        ],
      );
    } else {
      return Column(
        children: [
          _buildAdsSlideshow(viewModel),
          verticalSpaceSmall,
          quickActions(context),
          verticalSpaceMedium,
          doMoreOnAfriprize(context),
          verticalSpaceMedium,
          popularDrawsSlider(context, viewModel.raffleList),
          verticalSpaceMedium,
          donationsSlider(context, viewModel.projectResources),
        ],
      );
    }
  }

  Widget _buildAdsSlideshow(DashboardViewModel viewModel) {
    if (viewModel.adsList.isEmpty) {
      return Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: kcSecondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: SvgPicture.asset(
          uiMode.value == AppUiModes.dark
              ? "assets/images/dashboard_logo_white.svg" // Dark mode logo
              : "assets/images/dashboard_logo.svg",
          width: 500,
          height: 200,
        )),
      );
    }

    return CarouselSlider.builder(
      itemCount: viewModel.adsList.length,
      itemBuilder: (context, index, realIndex) {
        final ad = viewModel.adsList[index];
        return _buildAdItem(ad);
      },
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1,
        autoPlayInterval: Duration(seconds: 5),
        onPageChanged: (index, reason) {
          // Optionally handle page change event
        },
      ),
    );
  }

  Widget _buildAdItem(Ads ad) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: kcSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          ad.url ?? '',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildShimmerContainer() {
    return Shimmer.fromColors(
      baseColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[700]!
          : Colors.grey[300]!,
      highlightColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[300]!
          : Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: kcSecondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildShimmerQuickActions() {
    return Shimmer.fromColors(
      baseColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[700]!
          : Colors.grey[300]!,
      highlightColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[300]!
          : Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildShimmerSlider() {
    return Shimmer.fromColors(
      baseColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[700]!
          : Colors.grey[300]!,
      highlightColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[300]!
          : Colors.grey[100]!,
      child: Container(
        height: 300, // Adjust the height as per your design
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildVideContainer() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: kcSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _notificationIcon(int unreadCount, BuildContext context, DashboardViewModel viewModel) {
    print('notif count is $unreadCount');
    return Stack(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            uiMode.value == AppUiModes.dark
                ? "assets/images/dashboard_otification_white.svg" // Dark mode logo
                : "assets/images/dashboard_otification.svg", width: 30, height: 30,),
          onPressed: (){_showNotificationSheet(context, viewModel);}
        ),
        if (unreadCount > 0)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: BoxConstraints(minWidth: 10, minHeight: 10),
              child: Text(
                unreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 6),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showNotificationSheet(BuildContext context, DashboardViewModel viewModel) {
    viewModel.markAllNotificationsAsRead();

    TopModalSheet.show(
        context: context,
        isShowCloseButton: true,
        closeButtonRadius: 20.0,
        closeButtonBackgroundColor: kcSecondaryColor,
        child: Container(
          color: kcWhiteColor,
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Text("Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.value.length,
                  itemBuilder: (context, index) {
                    final notification = notifications.value[index];
                    return ListTile(
                      minLeadingWidth: 10,
                      leading: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: SvgPicture.asset(
                          'assets/icons/ticket_out.svg',
                          height: 28,
                        ),
                      ),
                      title: Text(
                        notification.subject,
                        style: GoogleFonts.redHatDisplay(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        notification.message,
                        style: GoogleFonts.redHatDisplay(
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: kcDarkGreyColor,
                          ),
                        ),
                      ),
                      trailing: notification.unread ? Icon(Icons.circle, color: Colors.red, size: 10) : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }




  List<Widget> _buildAppBarActions(BuildContext context, bool isLoading, DashboardViewModel viewModel) {
    if (isLoading) {
      // Display the shimmer effect while loading
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 0.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      width: 80,  // Adjust width for the shimmer
                      height: 20,  // Adjust height for the shimmer
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ];
    } else {
      // Normal display when data is loaded
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (userLoggedIn.value == true) ...[
                _notificationIcon(unreadCount.value, context, viewModel),
                const SizedBox(width: 3),
                InkWell(
                  onTap: () {
                    locator<NavigationService>().navigateTo(Routes.wallet);
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 0.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: kcPrimaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          '${profile.value.accountPoints} points',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/images/dashboard_wallet.svg",
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                InkWell(
                  onTap: () {
                    locator<NavigationService>().navigateTo(Routes.authView);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: kcSecondaryColor.withOpacity(0.2), // Capsule background color
                      borderRadius: BorderRadius.circular(10), // Rounded capsule shape
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: kcBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        )
      ];
    }
  }





  @override
  void onViewModelReady(DashboardViewModel viewModel) {

    super.onViewModelReady(viewModel);
    viewModel.initialise();
    Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= viewModel.featuredRaffle.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onDispose(DashboardViewModel viewModel) {
    viewModel.dispose();
    _pageController.dispose();
  }

  Widget _indicator(bool selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? kcWhiteColor : kcMediumGrey,
      ),
    );
  }

  Future<Color?> _updateTextColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );

    // Calculate the brightness of the dominant color
    final Color dominantColor = paletteGenerator.dominantColor!.color;
    final double luminance = dominantColor.computeLuminance();

    // Decide text color based on luminance
    return luminance < 0.1 ? Colors.white : Colors.black;
  }

  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel();
}

class RaffleRow extends StatelessWidget {
  final Raffle raffle;
  final DashboardViewModel viewModel;
  final int index;

  const RaffleRow({
    required this.raffle,
    super.key,
    required this.viewModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.raffleList.isEmpty || index >= viewModel.raffleList.length) {
      return Container();
    }
    CountdownTimerController controller = CountdownTimerController(endTime: 0);
    int remainingStock = 0;
    int remainingDays = 0;
    int endTime = 0;
    // final int stockTotal = raffle.stockTotal ?? 0;
    // final int verifiedSales = raffle.verifiedSales ?? 0;
    // remainingStock = stockTotal - verifiedSales;

    DateTime now = DateTime.now();
    DateTime drawDate = DateFormat("yyyy-MM-dd")
        .parse(raffle.endDate ?? '2024-02-04T00:00:00.000Z');
    // DateTime drawDate = DateFormat("yyyy-MM-dd").parse("2024-02-04T00:00:00.000Z");
    Duration timeDifference = drawDate.difference(now);
    remainingDays = timeDifference.inDays;
// Adding the current time to the timeDifference to get the future end time
    endTime = now.add(timeDifference).millisecondsSinceEpoch;
    controller =
        CountdownTimerController(endTime: endTime, onEnd: viewModel.onEnd);

    // Check conditions to set the color and text
    Color containerColor = Colors.transparent; // Default color
    String bannerText = ''; // Default text
    if (remainingDays <= 5) {
      containerColor = Colors.blue;
      bannerText = 'Coming soon in';
    } else if (remainingStock <= 10) {
      containerColor = Colors.red;
      bannerText = 'Sold out soon \n $remainingStock item left';
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      // height: 400,
      decoration: BoxDecoration(
        color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kcSecondaryColor),
        boxShadow: [
          BoxShadow(
            color: kcBlackColor.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Stack(
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   margin: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(12),
              //     ),
              //     child: CachedNetworkImage(
              //       placeholder: (context, url) => const Center(
              //         child: CircularProgressIndicator(
              //           strokeWidth: 2.0, // Make the loader thinner
              //           valueColor: AlwaysStoppedAnimation<Color>(
              //               kcSecondaryColor), // Change the loader color
              //         ),
              //       ),
              //       imageUrl: raffle.pictures?.first.location ??
              //           'https://via.placeholder.com/150',
              //       fit: BoxFit.cover,
              //       height: 182,
              //       width: double.infinity,
              //       errorWidget: (context, url, error) =>
              //           const Icon(Icons.error),
              //       fadeInDuration: const Duration(milliseconds: 500),
              //       fadeOutDuration: const Duration(milliseconds: 300),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Win!!!',
              //         style: TextStyle(
              //             fontSize: 22,
              //             color: uiMode.value == AppUiModes.light
              //                 ? kcSecondaryColor
              //                 : kcWhiteColor,
              //             fontWeight: FontWeight.bold,
              //             fontFamily: "Panchang"),
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       Text(
              //         raffle.ticketName ?? 'raffle Name',
              //         style: TextStyle(
              //             fontSize: 20,
              //             color: uiMode.value == AppUiModes.light
              //                 ? kcPrimaryColor
              //                 : kcSecondaryColor,
              //             fontWeight: FontWeight.bold,
              //             fontFamily: "Panchang"),
              //         maxLines: 3,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 11, vertical: 7),
              //             decoration: BoxDecoration(
              //               color: Colors.grey[300]?.withOpacity(0.2),
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Text(
              //               'Buy \$5 Afriprize Card',
              //               style: TextStyle(
              //                   color: uiMode.value == AppUiModes.light
              //                       ? kcBlackColor
              //                       : kcWhiteColor,
              //                   fontSize: 12,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //           Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 16, vertical: 10),
              //             decoration: BoxDecoration(
              //               color: uiMode.value == AppUiModes.light
              //                   ? kcPrimaryColor
              //                   : kcSecondaryColor,
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Column(
              //               children: [
              //                 Text(
              //                   'Shopping Card',
              //                   style: TextStyle(
              //                       color: uiMode.value == AppUiModes.light
              //                           ? kcWhiteColor
              //                           : kcBlackColor,
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 10),
              //                 ),
              //                 Row(
              //                   children: [
              //                     SvgPicture.asset(
              //                       'assets/icons/card_icon.svg',
              //                       height: 20, // Icon size
              //                     ),
              //                     horizontalSpaceTiny,
              //                     RichText(
              //                       text: TextSpan(
              //                         children: [
              //                           TextSpan(
              //                             text: '\$5',
              //                             style: TextStyle(
              //                               fontSize:
              //                                   18, // Size for the dollar amount
              //                               fontWeight: FontWeight.bold,
              //                               color:
              //                                   uiMode.value == AppUiModes.light
              //                                       ? kcSecondaryColor
              //                                       : kcBlackColor,
              //                             ),
              //                           ),
              //                           TextSpan(
              //                             text:
              //                                 '.00', // Assuming you want the decimal part smaller
              //                             style: TextStyle(
              //                               fontSize: 13, // Size for the cents
              //                               fontWeight: FontWeight.bold,
              //                               color:
              //                                   uiMode.value == AppUiModes.light
              //                                       ? kcSecondaryColor
              //                                       : kcBlackColor,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     )
              //                   ],
              //                 )
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Expanded(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     SvgPicture.asset(
              //                       'assets/icons/loader.svg',
              //                       height: 20, // Icon size
              //                     ),
              //                     horizontalSpaceTiny,
              //                     Column(
              //                       children: [
              //                         Text(
              //                           "${raffle.verifiedSales} sold out of ${raffle.stockTotal}",
              //                           overflow: TextOverflow.ellipsis,
              //                           maxLines: 3,
              //                           style: const TextStyle(
              //                             fontSize: 12,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: 95,
              //                           child: LinearProgressIndicator(
              //                             value: (raffle.verifiedSales !=
              //                                         null &&
              //                                     raffle.stockTotal != null &&
              //                                     raffle.stockTotal! > 0)
              //                                 ? raffle.verifiedSales! /
              //                                     raffle.stockTotal!
              //                                 : 0.0, // Default value in case of null or invalid stock
              //                             backgroundColor:
              //                                 kcSecondaryColor.withOpacity(0.3),
              //                             valueColor:
              //                                 const AlwaysStoppedAnimation(
              //                                     kcSecondaryColor),
              //                           ),
              //                         ),
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //                 verticalSpaceTiny,
              //                 Container(
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 7, vertical: 4),
              //                   decoration: BoxDecoration(
              //                     color: Colors.grey[300]?.withOpacity(0.2),
              //                     borderRadius: BorderRadius.circular(4),
              //                   ),
              //                   child: Text(
              //                     (raffle == null)
              //                         ? ""
              //                         : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(raffle.endDate ?? DateTime.now().toIso8601String()))}",
              //                     overflow: TextOverflow.ellipsis,
              //                     maxLines: 3,
              //                     style: const TextStyle(
              //                         fontSize: 12,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Column(
              //             // crossAxisAlignment: CrossAxisAlignment.end,
              //             children: [
              //               userLoggedIn.value == false
              //                   ? const SizedBox()
              //                   : ValueListenableBuilder<List<RaffleCartItem>>(
              //                       valueListenable: raffleCart,
              //                       builder: (context, value, child) {
              //                         // Determine if raffle is in cart
              //                         bool isInCart = value.any((item) =>
              //                             item.raffle?.id == raffle.id);
              //                         RaffleCartItem? cartItem = isInCart
              //                             ? value.firstWhere((item) =>
              //                                 item.raffle?.id == raffle.id)
              //                             : null;
              //
              //                         return isInCart && cartItem != null
              //                             ? Row(
              //                                 children: [
              //                                   InkWell(
              //                                     onTap: () => viewModel
              //                                         .decreaseRaffleQuantity(
              //                                             cartItem),
              //                                     child: Container(
              //                                       height: 30,
              //                                       width: 30,
              //                                       decoration: BoxDecoration(
              //                                         border: Border.all(
              //                                             color: kcLightGrey),
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 5),
              //                                       ),
              //                                       child: const Center(
              //                                         child: Icon(Icons.remove,
              //                                             size: 18),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   horizontalSpaceSmall,
              //                                   Text("${cartItem.quantity}"),
              //                                   horizontalSpaceSmall,
              //                                   InkWell(
              //                                     onTap: () => viewModel
              //                                         .increaseRaffleQuantity(
              //                                             cartItem),
              //                                     child: Container(
              //                                       height: 30,
              //                                       width: 30,
              //                                       decoration: BoxDecoration(
              //                                         border: Border.all(
              //                                             color: kcLightGrey),
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 5),
              //                                       ),
              //                                       child: const Align(
              //                                         alignment:
              //                                             Alignment.center,
              //                                         child: Icon(Icons.add,
              //                                             size: 18),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               )
              //                             : SizedBox(
              //                                 width:
              //                                     150, // Adjust width to your preference
              //                                 height: 35,
              //                                 child: SubmitButton(
              //                                   isLoading: false,
              //                                   label: "Buy Ticket",
              //                                   submit: () => viewModel
              //                                       .addToRaffleCart(raffle),
              //                                   color: kcSecondaryColor,
              //                                   boldText: true,
              //                                   iconColor: Colors.black,
              //                                   borderRadius: 10.0,
              //                                   textSize: 12,
              //                                   svgFileName: "ticket.svg",
              //                                 ),
              //                               );
              //                       },
              //                     ),
              //             ],
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          if (containerColor != Colors.transparent)
            Positioned(
              top: 0, // Adjust the positioning as you see fit
              left: 22, // Adjust the positioning as you see fit
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                containerColor, // Blue color for the "Closing Soon" banner
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                bannerText,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Panchang",
                                    fontSize: 11),
                              ),
                              if (remainingDays <= 5)
                                CountdownTimer(
                                  controller: controller,
                                  onEnd: viewModel.onEnd,
                                  endTime: endTime,
                                  widgetBuilder:
                                      (_, CurrentRemainingTime? time) {
                                    if (time == null) {
                                      return const Text('in stock');
                                    }

                                    String dayText = '';
                                    if (time.days != null) {
                                      if (time.days! > 0) {
                                        dayText =
                                            '${time.days} ${time.days == 1 ? 'day' : 'days'}, ';
                                      }
                                    }
                                    String formattedHours =
                                        '${time.hours ?? 0}'.padLeft(2, '0');
                                    String formattedMin =
                                        '${time.min ?? 0}'.padLeft(2, '0');
                                    String formattedSec =
                                        '${time.sec ?? 0}'.padLeft(2, '0');

                                    return Text(
                                      '$dayText$formattedHours : $formattedMin : $formattedSec',
                                      style: const TextStyle(
                                          color: kcWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Panchang",
                                          fontSize: 11),
                                    );
                                  },
                                ),
                            ],
                          )),
                    ],
                  )),
            ),
        ],
      ),
    );
  }

  Future<Color?> _updateTextColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );

    // Calculate the brightness of the dominant color
    final Color dominantColor = paletteGenerator.dominantColor!.color;
    final double luminance = dominantColor.computeLuminance();

    // Decide text color based on luminance
    return luminance < 0.1 ? Colors.white : Colors.black;
  }
}
