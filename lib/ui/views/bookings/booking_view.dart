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
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../state.dart';
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
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: viewModel.activeBookings.length,
                                    itemBuilder: (context, index) {
                                      return BookingCard(
                                        booking: viewModel.activeBookings[index],
                                        context: context,
                                        isActiveBooking: true,
                                      );
                                    },
                                  ),
                                ],
                              ),
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
                                                        "SQFT: 2500",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$/hr",
                                                        style: TextStyle(
                                                          fontSize: 14,
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
                                                        "SQFT: 2500",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$/hr",
                                                        style: TextStyle(
                                                          fontSize: 14,
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
                                                                color: Colors.green),
                                                            child: const Text(
                                                              "Active Booking",
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

class DrawsCard extends StatelessWidget {
  final Raffle raffle;
  final BookingsViewModel viewModel;
  final Winner? winner;
  final int index;
  final bool isWinner;

  const DrawsCard({
    required this.raffle,
    super.key,
    required this.viewModel,
    required this.index,
    required this.isWinner,
    this.winner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      // height: 400,
      decoration: BoxDecoration(
        color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
        borderRadius: BorderRadius.circular(10),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0, // Make the loader thinner
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  kcSecondaryColor), // Change the loader color
                            ),
                          ),
                          imageUrl: raffle.media?.first.location ??
                              'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          height: 182,
                          width: double.infinity,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeOutDuration: const Duration(milliseconds: 300),
                        ),
                        Container(
                          // width: screenWidth, // Set the width to the screen width
                          height: 40.0,
                          color:
                              kcSecondaryColor, // Set the background color to blue
                          padding: const EdgeInsets.all(7.0),
                          child: Marquee(
                            text: !isWinner
                                ? 'SOLD OUT SOLD OUT SOLD OUT'
                                : 'WINNER WINNER WINNER WINNER', // Your text here
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                fontFamily: "Panchang"),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 20.0,
                            velocity: 100.0,
                            pauseAfterRound: const Duration(milliseconds: 50),
                            startPadding: 10.0,
                            accelerationDuration: const Duration(seconds: 2),
                            accelerationCurve: Curves.linear,
                            decelerationDuration:
                                const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isWinner)
                      Text(
                        'Win!!!',
                        style: TextStyle(
                            fontSize: 22,
                            color: uiMode.value == AppUiModes.light
                                ? kcSecondaryColor
                                : kcWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Panchang"),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (!isWinner)
                      Text(
                        raffle.name ?? 'Product Name',
                        style: TextStyle(
                            fontSize: 20,
                            color: uiMode.value == AppUiModes.light
                                ? kcPrimaryColor
                                : kcSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Panchang"),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (isWinner)
                      Text(
                        '${winner?.user?.firstName} ${winner?.user?.lastName}' ??
                            'Product Name',
                        style: TextStyle(
                            fontSize: 20,
                            color: uiMode.value == AppUiModes.light
                                ? kcPrimaryColor
                                : kcSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Panchang"),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300]?.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (raffle == null)
                                      ? ""
                                      : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(raffle.endDate ?? DateTime.now().toIso8601String()))}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  const url = AppConfig.youtubeOfficial;
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/youtube.svg',
                                    height: 20, // Icon size
                                  ),
                                ),
                              ),
                              horizontalSpaceTiny,
                              InkWell(
                                onTap: () async {
                                  const url = AppConfig.instagramOfficial;
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/instagram.svg',
                                    height: 20, // Icon size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    if (!isWinner)
                      const Text(
                        'Raffle dates subject to change. Follow us on s'
                        'ocial media for updates and live draw events. '
                        'Your big win awaits!',
                        style: TextStyle(fontSize: 10),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget liveDrawsWidget(BuildContext context, List<DrawEvent> drawEvents) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Previous Live Draws",
        style: GoogleFonts.bricolageGrotesque(
          textStyle:  TextStyle(
            fontSize: 15, // Custom font size
            fontWeight: FontWeight.bold, // Custom font weight
            color: uiMode.value == AppUiModes.dark ? kcLightGrey : kcBlackColor, // Custom text color (optional)
          ),
        ),
      ),
      verticalSpaceMedium,
      Container(
        height: 104, // Adjust height according to your design
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: drawEvents.length,
          itemBuilder: (context, index) {
            final event = drawEvents[index];
            return GestureDetector(
              onTap: () async {
                final Uri uri = Uri.parse(event.link);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  print('Could not launch ${event.link}');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    width: 80, // Adjust width according to your design
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            event.media.isNotEmpty
                                ? event.media[0].url!
                                : 'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            DateFormat('dd MMM, yyyy h:mm a').format(
                                DateTime.parse(event.raffle.endDate ??
                                    DateTime.now().toString())),
                            style: GoogleFonts.redHatDisplay(
                              textStyle: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
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

Widget _buildRaffleCard(Raffle raffle, BookingsViewModel viewModel, int index) {
  return Container(
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            viewModel.filteredRaffle[index].media?.first.url ??
                'https://via.placeholder.com/150',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        // Tint overlay for better readability
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color:
                Colors.black.withOpacity(0.6), // Dark semi-transparent overlay
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        // Raffle details positioned on top of the image
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kcWhiteColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              viewModel.filteredRaffle[index].formattedTicketPrice ?? '',
              style: const TextStyle(
                  color: kcPrimaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'roboto'),
            ),
          ),
        ),
        Positioned(
          top: 33,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kcSecondaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Ticket Price',
              style: TextStyle(
                fontSize: 7,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'WIN Prize in ${viewModel.filteredRaffle[index].endDate != null && viewModel.filteredRaffle[index].endDate!.isNotEmpty ? DateFormat('yyyy-MM-dd').format(DateTime.tryParse(viewModel.filteredRaffle[index].endDate!) ?? DateTime.now()) : 'Invalid Date'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                viewModel.filteredRaffle[index].name ?? '',
                style: const TextStyle(
                  color: kcSecondaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              buildParticipantsAvatars(viewModel.filteredRaffle[index].participants ??
                  []), // Show participants' avatars
              // Row(
              //   children: [
              //     Image.asset(
              //       "assets/images/partcipant_icon.png",
              //       width: 35,
              //     ),
              //     const SizedBox(width: 4),
              //     Text(
              //       '${viewModel.filteredRaffle[index].participants?.length ?? 0} Participants',
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 10,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildWinnerCard(Winner winner, BookingsViewModel viewModel, int index) {
  return Container(
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: uiMode.value == AppUiModes.dark ? kcDarkGreyColor : kcWhiteColor,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            viewModel.raffleWinnerList[index].raffle?.media?.first.url ??
                'https://via.placeholder.com/150',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        // Tint overlay for better readability
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color:
                Colors.black.withOpacity(0.6), // Dark semi-transparent overlay
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        // Raffle details positioned on top of the image

        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kcSecondaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  size: 12,
                  color: Colors.white,
                ),
                Text('Draw completed',
                    style: GoogleFonts.redHatDisplay(
                      textStyle: const TextStyle(
                        fontSize: 9,
                        color: kcBlackColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 35,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kcSecondaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('WINNER',
                style: GoogleFonts.redHatDisplay(
                  textStyle:  TextStyle(
                    fontSize: 9,
                    color: kcBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kcWhiteColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                    '${viewModel.raffleWinnerList[index].user?.firstName?.substring(0, 1).toUpperCase() ?? ''}${viewModel.raffleWinnerList[index].user?.firstName?.substring(1).toLowerCase() ?? ''} ${viewModel.raffleWinnerList[index].user?.lastName?.substring(0, 1).toUpperCase() ?? ''}${viewModel.raffleWinnerList[index].user?.lastName?.substring(1).toLowerCase() ?? ''}',
                    style: GoogleFonts.redHatDisplay(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: kcBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildParticipantsAvatars(List<Participant> participants) {
  return SizedBox(
    height: 20, // Adjust the size to match the avatar size
    child: Stack(
      children: participants.asMap().entries.map((entry) {
        int index = entry.key;
        Participant participant = entry.value;
        double overlapOffset = 17.0; // Control the overlap amount
        return Positioned(
          left: index * overlapOffset,
          child: participant.profilePic?.url != null
              ? ClipOval(
            child: Image.network(
              participant.profilePic!.url!,
              width: 20,
              height: 20,
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
    radius: 10, // Adjust the size if needed
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


