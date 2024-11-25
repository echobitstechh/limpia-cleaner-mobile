import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:limpia/core/utils/config.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/common/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../state.dart';
import '../../../utils/booking_assignment_card.dart';
import '../../../utils/bookings_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'booking_viewmodel.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingsViewModel>.reactive(
      viewModelBuilder: () => BookingsViewModel(),
      onModelReady: (viewModel) {
        viewModel.init();
      },
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          leading: null, 
          automaticallyImplyLeading: false,
          title: Container(
            child: Image.asset(
                height: 150,
                width: 150,
                'assets/images/limpiarblue.png'
            ),
          ),
          centerTitle: false,
          actions: [
            InkWell(
              onTap: (){
                _showWorkCalendar(context, viewModel);
              },
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Icon(Icons.date_range_outlined, color: kcPrimaryColor, size: 15,),
                    Text('work \n calender', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: kcPrimaryColor),)
                  ],
                ),
              ),
            )

          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      verticalSpaceTiny,
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SegmentedTabControl(
                          splashColor: Colors.transparent,
                          indicatorDecoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2.0,
                              ),
                            ),
                          ),
                          tabTextColor: Colors.black,
                          selectedTabTextColor: Colors.black,
                          tabs: [
                            SegmentTab(
                              backgroundColor: Colors.transparent,
                              label: 'Bookings',
                            ),
                            SegmentTab(
                              backgroundColor: Colors.transparent,
                              label: 'History',
                            ),
                            SegmentTab(
                              backgroundColor: Colors.transparent,
                              label: 'Combo Jobs',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 700, // Adjust height as necessary
              
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            viewModel.isBusy
                                ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 50, // Search bar height
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                                : viewModel.pendingAssignments.isEmpty && !viewModel.isBusy
                                ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 26.0, right: 16.0),
                              child: Image.asset(
                                "assets/images/no_booking.png",
                                fit: BoxFit.scaleDown,
                              ),
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              viewModel.pendingAssignments.length,
                              itemBuilder: (context, index) {
                                return BookingAssignmentCard(
                                  bookingAssignment: viewModel
                                      .pendingAssignments[index],
                                  context: context,
                                  isBusy: viewModel.isBusy,
                                );
                              },
                            ),
                            viewModel.isBusy
                                ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 50, // Search bar height
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                                : viewModel.pendingAssignments.isEmpty && !viewModel.isBusy
                                ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 26.0, right: 16.0),
                              child: Image.asset(
                                "assets/images/no_booking.png",
                                fit: BoxFit.scaleDown,
                              ),
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              viewModel.activeAssignments.length,
                              itemBuilder: (context, index) {
                                return BookingAssignmentCard(
                                  bookingAssignment: viewModel
                                      .activeAssignments[index],
                                  context: context,
                                  isBusy: viewModel.isBusy,
                                );
                              },
                            ),
                            Column(
                              children: [
                                Card(
                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                width: 60,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey.shade300, width: 1),
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                    fit: BoxFit.cover,
                                                    'assets/images/rectangle.png'
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "James Team Request",
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      RatingBar.builder(
                                                        initialRating: 4.5, // Replace with the user's average rating
                                                        minRating: 1,
                                                        direction: Axis.horizontal,
                                                        itemCount: 5,
                                                        itemSize: 7.0,
                                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                        itemBuilder: (context, _) => Icon(
                                                          Icons.star,
              
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate: (rating)
                                                        {
                                                          // Handle rating update, if needed
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    "Address: 8 Magodo, Califona USA",
                                                    style: TextStyle(
                                                      fontSize: 14, ),
                                                  ),
                                                  verticalSpaceTiny,
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                color: Colors.red),
                                                            child: const Text(
                                                              "Reject",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      horizontalSpaceSmall,
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                color: Colors.green),
                                                            child: const Text(
                                                              "Accepted",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomRight,
                                                    child: Text(
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        'Feb, 27, 10:00'
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                width: 60,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey.shade300, width: 1),
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                    fit: BoxFit.cover,
                                                    'assets/images/rectangle.png'
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                                  //   children: [
                                                  //     Container(
                                                  //       padding: const EdgeInsets.symmetric(
                                                  //         horizontal: 12.0,
                                                  //       ),
                                                  //       decoration: BoxDecoration(
                                                  //           borderRadius:
                                                  //           BorderRadius.circular(10.0),
                                                  //           color: Colors.yellow),
                                                  //       child: const Text(
                                                  //         "processing",
                                                  //         style: TextStyle(
                                                  //             fontSize: 16,
                                                  //             color: kcWhiteColor),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Tosin Team Job offer",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$/hr",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    "Address: 8 Magodo, Califona USA",
                                                    style: TextStyle(
                                                      fontSize: 14, ),
                                                  ),
                                                  verticalSpaceTiny,
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                color: Colors.red),
                                                            child: const Text(
                                                              "Reject",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      horizontalSpaceSmall,
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                color: Colors.green),
                                                            child: const Text(
                                                              "Accepted",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomRight,
                                                    child: Text(
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        'Feb, 27, 10:00'
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                width: 60,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey.shade300, width: 1),
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                    fit: BoxFit.cover,
                                                    'assets/images/rectangle.png'
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                                  //   children: [
                                                  //     Container(
                                                  //       padding: const EdgeInsets.symmetric(
                                                  //         horizontal: 12.0,
                                                  //       ),
                                                  //       decoration: BoxDecoration(
                                                  //           borderRadius:
                                                  //           BorderRadius.circular(10.0),
                                                  //           color: Colors.yellow),
                                                  //       child: const Text(
                                                  //         "processing",
                                                  //         style: TextStyle(
                                                  //             fontSize: 16,
                                                  //             color: kcWhiteColor),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Tosin Team Next Job",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$/hr",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    "Address: 8 Magodo, Califona USA",
                                                    style: TextStyle(
                                                      fontSize: 14, ),
                                                  ),
                                                  verticalSpaceTiny,
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                color: Colors.orangeAccent),
                                                            child: const Text(
                                                              "Currently Working",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomRight,
                                                    child: Text(
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        'Feb, 27, 10:00'
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkCalendar(BuildContext context, BookingsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              return viewModel.getEventsForDay(day);
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: kcPrimaryColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: kcSecondaryColor,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              viewModel.onDaySelected(selectedDay);
            },
            selectedDayPredicate: (day) {
              return isSameDay(viewModel.selectedDay, day);
            },
          ),
        );
      },
    );
  }


  Widget buildOption({
    required BuildContext context,
    required String text,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color:(uiMode.value == AppUiModes.dark && isSelected)
              ? kcDarkGreyColor
              : Colors.transparent, // Interior color remains transparent
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected ? kcSecondaryColor : Colors.transparent,
            width: 2.0, // Set the width as needed
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/$icon',
              color: isSelected ? kcSecondaryColor : kcLightGrey,
              height: 20,
            ),
            // Icon(icon, color: isSelected ? kcSecondaryColor : kcPrimaryColor),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                  color: (uiMode.value == AppUiModes.dark && isSelected)
                      ? kcWhiteColor
                      : kcLightGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Panchang",
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}


// Helper method to build a shimmer card
Widget _buildShimmerCard() {
  return Shimmer.fromColors(
    baseColor: uiMode.value == AppUiModes.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!,
    highlightColor: uiMode.value == AppUiModes.dark
        ? Colors.grey[300]!
        : Colors.grey[100]!,
    child: Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: uiMode.value == AppUiModes.dark
            ? Colors.grey[700]!
            : Colors.grey[300]!,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}


