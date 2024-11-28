import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/common/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limpia/utils/booking_assignment_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:top_bottom_sheet_flutter/top_bottom_sheet_flutter.dart';
import '../../../core/data/models/booking.dart';
import '../../../state.dart';
import '../../../utils/bookings_card.dart';
import '../../../utils/date_time_utils.dart';
import '../../components/empty_state.dart';
import 'dashboard_viewmodel.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  DashboardView({Key? key}) : super(key: key);

  final List<Profile> profiles = [
    Profile(
      name: 'SQFT: 2500',
      rating: '5 starts',
      description: 'Address: 8 Magodo, Califona USA',
      date: '22 Oct, 2024',
      price: '\$50',
      profileImage: 'assets/images/man.png',
    ),
    Profile(
      name: 'SQFT: 2500',
      rating: '5 starts',
      description: 'Address: 8 Magodo, Califona USA',
      date: '20 Oct, 2024',
      price: '\$60',
      profileImage: 'assets/images/man.png',
    ),
  ];


  final List<String> cleaningTypes = [
    'Regular cleaning ',
    'Standard cleaning',
    'Deeep cleaning ',
    'moving cleaning ',
    'Hybrid cleaning '
  ];

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/limpiador_logo.png",
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 16.0), // Adds padding to actions
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _notificationIcon(3, context, viewModel),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await viewModel.refreshData();
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () async {
                          await viewModel.refreshData();
                        },
                        child: Card(
                          color: kcPrimaryColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                top: 8.0,
                                right: 16.0,
                                bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/images/man.png'),
                                    ),
                                    horizontalSpaceSmall,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    RatingBarIndicator(
                                                      rating: 4.5,
                                                      // Replace with dynamic rating
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      itemCount: 5,
                                                      itemSize: 10.0,
                                                    ),
                                                    horizontalSpaceTiny,
                                                    Text(
                                                      "4.5",
                                                      style: TextStyle(
                                                        color: Colors.amber,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${profile.value.firstName ?? ''} ${profile.value.lastName ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            horizontalSpaceTiny,
                                          ],
                                        ),
                                        Text(
                                          "${profile.value.role ?? ''}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed:
                                          () {}, // Define navigation or action
                                      icon: Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Current Work:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    viewModel.activebookingInfo != null
                                        ? GestureDetector(
                                            onTap:
                                                () {}, // Define edit job action
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 6.0),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                "Edit Job",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Text(
                                  viewModel.activebookingInfo != null
                                      ? "Address: "
                                      "${viewModel.activebookingInfo?.booking.property?.address ?? viewModel.activebookingInfo?.booking.address}, ${viewModel.activebookingInfo?.booking.property?.state ?? viewModel.activebookingInfo?.booking?.state}"
                                      : "No Active work...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                verticalSpaceSmall,
                                viewModel.activebookingInfo != null
                                    ? Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              horizontalSpaceTiny,
                                              Text(
                                                "${formatDateString(viewModel.activebookingInfo?.booking.date[0]) ?? ''}",                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          horizontalSpaceMedium,
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              horizontalSpaceTiny,
                                              Text(
                                                "${viewModel.activebookingInfo?.booking.time[0] ?? ''}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                                color: kcPrimaryColor,
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
                              label: 'Active Bookings',
                            ),
                            SegmentTab(
                              backgroundColor: Colors.transparent,
                              label: 'Combo Jobs',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height -
                            460, // Adjust height as necessary
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
                                : viewModel.pendingBookinginfos.isEmpty && !viewModel.isBusy
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
                                            viewModel.pendingBookinginfos.length,
                                        itemBuilder: (context, index) {
                                          return BookingAssignmentCard(
                                            bookingInfo: viewModel
                                                .pendingBookinginfos[index],
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
                                : viewModel.pendingBookinginfos.isEmpty && !viewModel.isBusy
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
                              viewModel.activebookingInfos.length,
                              itemBuilder: (context, index) {
                                return BookingAssignmentCard(
                                  bookingInfo: viewModel
                                      .activebookingInfos[index],
                                  context: context,
                                  isBusy: viewModel.isBusy,
                                );
                              },
                            ),
                            Column(
                              children: [
                                Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                width: 60,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                    fit: BoxFit.cover,
                                                    'assets/images/rectangle.png'),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                        "James Team Request",
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      RatingBar.builder(
                                                        initialRating: 4.5,
                                                        // Replace with the user's average rating
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        itemCount: 5,
                                                        itemSize: 7.0,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          // Handle rating update, if needed
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    "Address: 8 Magodo, Califona USA",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  verticalSpaceTiny,
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color:
                                                                    Colors.red),
                                                            child: const Text(
                                                              "Reject",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      horizontalSpaceSmall,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .green),
                                                            child: const Text(
                                                              "Accepted",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        'Feb, 27, 10:00'),
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
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                width: 60,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                    fit: BoxFit.cover,
                                                    'assets/images/rectangle.png'),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$/hr",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    "Address: 8 Magodo, Califona USA",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  verticalSpaceTiny,
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color:
                                                                    Colors.red),
                                                            child: const Text(
                                                              "Reject",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      horizontalSpaceSmall,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .green),
                                                            child: const Text(
                                                              "Accepted",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        'Feb, 27, 10:00'),
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
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                width: 60,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                    fit: BoxFit.cover,
                                                    'assets/images/rectangle.png'),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$/hr",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    "Address: 8 Magodo, Califona USA",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  verticalSpaceTiny,
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .orangeAccent),
                                                            child: const Text(
                                                              "Currently Working",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      kcWhiteColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        'Feb, 27, 10:00'),
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
        ));
  }

  @override
  void onDispose(DashboardViewModel viewModel) {
    viewModel.dispose();
  }

  @override
  void onViewModelReady(DashboardViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}

Widget _notificationIcon(
    int unreadCount, BuildContext context, DashboardViewModel viewModel) {
  print('notif count is $unreadCount');
  return Stack(
    children: [
      IconButton(
          icon: SvgPicture.asset(
            uiMode.value == AppUiModes.dark
                ? "assets/images/dashboard_otification_white.svg" // Dark mode logo
                : "assets/images/dashboard_otification.svg",
            width: 22,
            height: 22,
          ),
          onPressed: () {
            _showNotificationSheet(context, viewModel);
          }),
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

void _showNotificationSheet(
    BuildContext context, DashboardViewModel viewModel) {
  TopModalSheet.show(
      context: context,
      isShowCloseButton: true,
      closeButtonRadius: 20.0,
      closeButtonBackgroundColor: kcPrimaryColor,
      child: Container(
        color: kcWhiteColor,
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Text("Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    trailing: notification.unread
                        ? Icon(Icons.circle, color: Colors.red, size: 10)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ));
}

class Profile {
  final String name;
  final String description;
  final String rating;
  final String date;
  final String price;
  final String profileImage;

  Profile({
    required this.name,
    required this.description,
    required this.rating,
    required this.date,
    required this.price,
    required this.profileImage,
  });
}
