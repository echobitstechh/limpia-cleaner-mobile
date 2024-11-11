import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/common/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../state.dart';
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

  final List<String> names = [
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
                "assets/images/limpiar_purple.png",
                height: 30,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                  width: 8), // Adds some space between the images if needed
              SvgPicture.asset(
                "assets/images/Limpiador.svg",
                height: 10,
                fit: BoxFit.fitHeight,
                color: kcPrimaryColor,
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
                GestureDetector(
                  onTap: () {
                    // Define the action when the icon is tapped
                  },
                  child: Icon(
                    Icons.notifications_active_outlined,
                    size: 25,
                    color: kcPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await viewModel.refreshData();
                },
                child: SingleChildScrollView(
                  child: Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: kcPrimaryColor,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset('assets/images/pp.png')
                                                  ],
                                                ),
                                                horizontalSpaceTiny,
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating: 4.5, // Replace with the user's average rating
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      itemCount: 5,
                                                      itemSize: 15.0,
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
                                                    Text(
                                                      "${profile.value.firstname} ${profile.value.lastname}",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Cleaner',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                horizontalSpaceMedium,
                                                Container(
                                                  child: Image.asset(
                                                    width: 50,
                                                      height: 50,
                                                      'assets/images/shape.png'
                                                  )
                                                ),
                                                Container(
                                                  child: Image.asset(
                                                    width: 30,
                                                      height: 30,
                                                      'assets/images/arrow-right.png'
                                                  )
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Current Work:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: kcWhiteColor,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                                horizontalSpaceTiny,
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Edit Job',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: kcWhiteColor,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  style: TextStyle(
                                                    fontSize:20,
                                                    color: Colors.lightBlueAccent
                                                  ),
                                                    'Address: 8 Magodo, Califonia USA'
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today,
                                                      color: Colors.white,
                                                    ),
                                                    horizontalSpaceTiny,
                                                    Container(
                                                      child: Text(
                                                        'Sunday, 12 June',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                horizontalSpaceTiny,
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    horizontalSpaceTiny,
                                                    Container(
                                                      child: Text(
                                                        '11:00 - 12:00AM',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(right: 8.0),
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.only(
                                      //         topLeft: Radius.circular(15),
                                      //         topRight: Radius.circular(15),
                                      //       ),
                                      //       image: DecorationImage(
                                      //         image: AssetImage(
                                      //             "assets/images/woman.png"),
                                      //         fit: BoxFit.cover,
                                      //       ),
                                      //     ),
                                      //     height: 150,
                                      //     width: 130,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Categories',
                        //         style: TextStyle(fontSize: 16),
                        //       ),
                        //       Text(
                        //         'See all',
                        //         style: TextStyle(fontSize: 14, color: kcPrimaryColor),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.all(16.0),
                        //   child: SingleChildScrollView(
                        //     scrollDirection: Axis.horizontal,
                        //     child: Row(
                        //       children: List.generate(names.length, (index) {
                        //         return GestureDetector(
                        //           onTap: () {
                        //             viewModel.selectedIndex = index;
                        //           },
                        //           child: Container(
                        //             padding: EdgeInsets.symmetric(
                        //                 vertical: 8.0, horizontal: 16.0),
                        //             margin: EdgeInsets.symmetric(horizontal: 4.0),
                        //             decoration: BoxDecoration(
                        //               color: viewModel.selectedIndex == index
                        //                   ? Colors.white
                        //                   : kcPrimaryColor.withOpacity(0.7),
                        //               border: Border.all(color: Colors.grey),
                        //               borderRadius: BorderRadius.circular(8.0),
                        //             ),
                        //             child: Column(
                        //               children: [
                        //                 // Circular image holder
                        //                 CircleAvatar(
                        //                   radius: 40, // Adjust size as needed
                        //                   backgroundImage:
                        //                       AssetImage('assets/images/image.png'),
                        //                 ),
                        //                 SizedBox(
                        //                     height:
                        //                         8.0), // Space between image and text
                        //                 Text(
                        //                   names[index],
                        //                   style: TextStyle(
                        //                       color: viewModel.selectedIndex == index
                        //                           ? kcPrimaryColor
                        //                           : Colors.white,
                        //                       fontSize: 14),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         );
                        //       }),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
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
                        height: 800, // Adjust height as necessary

                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
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
                                                        "SQFT:2500",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                        "SQFT:2500",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                        "SQFT:2500",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      horizontalSpaceLarge,
                                                      Text(
                                                        "Price:50\$",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                // Card(
                                //   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                //   elevation: 5,
                                //   color: Colors.white,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15),
                                //   ),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(16.0),
                                //     child: Column(
                                //       children: [
                                //         Row(
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: [
                                //             ClipRRect(
                                //               borderRadius: BorderRadius.circular(8),
                                //               child: Container(
                                //                 width: 60,
                                //                 height: 70,
                                //                 decoration: BoxDecoration(
                                //                   border: Border.all(
                                //                       color: Colors.grey.shade300, width: 1),
                                //                   borderRadius: BorderRadius.circular(8),
                                //                   boxShadow: [
                                //                     BoxShadow(
                                //                       color: Colors.black.withOpacity(0.1),
                                //                       spreadRadius: 1,
                                //                       blurRadius: 3,
                                //                       offset: Offset(0, 2),
                                //                     ),
                                //                   ],
                                //                 ),
                                //                 child: Image.asset(
                                //                     'assets/images/rectangle.png'
                                //                 ),
                                //               ),
                                //             ),
                                //             SizedBox(width: 16),
                                //             Expanded(
                                //               child: Column(
                                //                 crossAxisAlignment: CrossAxisAlignment.start,
                                //                 children: [
                                //                   Row(
                                //                     children: [
                                //                       Text(
                                //                         "Marvin Tracy",
                                //                         style: TextStyle(
                                //                           fontSize: 16,
                                //                           fontWeight: FontWeight.bold,
                                //                         ),
                                //                       ),
                                //                       horizontalSpaceLarge,
                                //
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     children: [
                                //                       Text(
                                //                         "Rating:",
                                //                         style: TextStyle(fontSize: 12, color: Colors.black),
                                //                       ),
                                //                       SizedBox(width: 4), // Add some space between text and stars
                                //                       Row(
                                //                         children: [
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star_half, color: Colors.amber, size: 16),
                                //                         ],
                                //                       ),
                                //                       SizedBox(width: 4), // Space between stars and the rating text
                                //                       Text(
                                //                         "(4.8/5)", // Display the rating value if needed
                                //                         style: TextStyle(fontSize: 12, color: Colors.black),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     children: [
                                //                       Expanded(
                                //                         child: Text(
                                //                           "Experience: 5 years in residential and commercial cleaning",
                                //                           style: TextStyle(fontSize: 12, color: Colors.black),
                                //                         ),
                                //                       ),
                                //                       Text(
                                //                         "\$120",
                                //                         style: TextStyle(fontSize: 12, color: Colors.purple),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     children: [
                                //                       Icon(
                                //                         Icons.location_on, // Use a location icon
                                //                         size: 16, // Adjust icon size as needed
                                //                         color: Colors.blueGrey, // Set the icon color
                                //                       ),
                                //                       SizedBox(width: 4), // Add some spacing between the icon and the text
                                //                       Expanded(
                                //                         child: Text(
                                //                           "Location: California",
                                //                           style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                                //                         ),
                                //                       ),
                                //                       Row(
                                //                         children: [
                                //                           Icon(
                                //                             Icons.location_on, // Choose an icon that represents tracking
                                //                             size: 16, // Adjust icon size as needed
                                //                             color: Colors.blue, // Set the icon color to match the text
                                //                           ),
                                //                           SizedBox(width: 4), // Add some spacing between the icon and the text
                                //                           Text(
                                //                             "Track cleaner",
                                //                             style: TextStyle(fontSize: 12, color: Colors.blue),
                                //                           ),
                                //                         ],
                                //                       )
                                //
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     mainAxisAlignment: MainAxisAlignment.end,
                                //                     crossAxisAlignment: CrossAxisAlignment.end,
                                //                     children: [
                                //                       Text(
                                //                         "Expected Time: Feb 27, 10:00AM",
                                //                         style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                                //                       ),
                                //                     ],
                                //                   ),
                                //
                                //
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
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
                                // Card(
                                //   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                //   elevation: 5,
                                //   color: Colors.white,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15),
                                //   ),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(16.0),
                                //     child: Column(
                                //       children: [
                                //         Row(
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: [
                                //             ClipRRect(
                                //               borderRadius: BorderRadius.circular(8),
                                //               child: Container(
                                //                 width: 60,
                                //                 height: 70,
                                //                 decoration: BoxDecoration(
                                //                   border: Border.all(
                                //                       color: Colors.grey.shade300, width: 1),
                                //                   borderRadius: BorderRadius.circular(8),
                                //                   boxShadow: [
                                //                     BoxShadow(
                                //                       color: Colors.black.withOpacity(0.1),
                                //                       spreadRadius: 1,
                                //                       blurRadius: 3,
                                //                       offset: Offset(0, 2),
                                //                     ),
                                //                   ],
                                //                 ),
                                //                 child: Image.asset(
                                //                     'assets/images/rectangle.png'
                                //                 ),
                                //               ),
                                //             ),
                                //             SizedBox(width: 16),
                                //             Expanded(
                                //               child: Column(
                                //                 crossAxisAlignment: CrossAxisAlignment.start,
                                //                 children: [
                                //                   Row(
                                //                     children: [
                                //                       Text(
                                //                         "Marvin Tracy",
                                //                         style: TextStyle(
                                //                           fontSize: 16,
                                //                           fontWeight: FontWeight.bold,
                                //                         ),
                                //                       ),
                                //                       horizontalSpaceLarge,
                                //
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     children: [
                                //                       Text(
                                //                         "Rating:",
                                //                         style: TextStyle(fontSize: 12, color: Colors.black),
                                //                       ),
                                //                       SizedBox(width: 4), // Add some space between text and stars
                                //                       Row(
                                //                         children: [
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star, color: Colors.amber, size: 16),
                                //                           Icon(Icons.star_half, color: Colors.amber, size: 16),
                                //                         ],
                                //                       ),
                                //                       SizedBox(width: 4), // Space between stars and the rating text
                                //                       Text(
                                //                         "(4.8/5)", // Display the rating value if needed
                                //                         style: TextStyle(fontSize: 12, color: Colors.black),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     children: [
                                //                       Expanded(
                                //                         child: Text(
                                //                           "Experience: 5 years in residential and commercial cleaning",
                                //                           style: TextStyle(fontSize: 12, color: Colors.black),
                                //                         ),
                                //                       ),
                                //                       Text(
                                //                         "\$120",
                                //                         style: TextStyle(fontSize: 12, color: Colors.purple),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     children: [
                                //                       Icon(
                                //                         Icons.location_on, // Use a location icon
                                //                         size: 16, // Adjust icon size as needed
                                //                         color: Colors.blueGrey, // Set the icon color
                                //                       ),
                                //                       SizedBox(width: 4), // Add some spacing between the icon and the text
                                //                       Expanded(
                                //                         child: Text(
                                //                           "Location: California",
                                //                           style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                                //                         ),
                                //                       ),
                                //                       Row(
                                //                         children: [
                                //                           Icon(
                                //                             Icons.location_on, // Choose an icon that represents tracking
                                //                             size: 16, // Adjust icon size as needed
                                //                             color: Colors.blue, // Set the icon color to match the text
                                //                           ),
                                //                           SizedBox(width: 4), // Add some spacing between the icon and the text
                                //                           Text(
                                //                             "Track cleaner",
                                //                             style: TextStyle(fontSize: 12, color: Colors.blue),
                                //                           ),
                                //                         ],
                                //                       )
                                //
                                //                     ],
                                //                   ),
                                //                   verticalSpaceSmall,
                                //                   Row(
                                //                     mainAxisAlignment: MainAxisAlignment.end,
                                //                     crossAxisAlignment: CrossAxisAlignment.end,
                                //                     children: [
                                //                       Text(
                                //                         "Expected Time: Feb 27, 10:00AM",
                                //                         style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                                //                       ),
                                //                     ],
                                //                   ),
                                //
                                //
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            verticalSpaceSmall,
                            // DefaultTabController(
                            //   length: 2,
                            //   child: SingleChildScrollView(
                            //     child: Column(
                            //       children: [
                            //         verticalSpaceTiny,
                            //         Padding(
                            //           padding: const EdgeInsets.all(6.0),
                            //           child: SegmentedTabControl(
                            //             splashColor: Colors.transparent,
                            //             indicatorDecoration: BoxDecoration(
                            //               color: kcPrimaryColor,
                            //               borderRadius: BorderRadius.circular(10),
                            //             ),
                            //             tabTextColor: Colors.black,
                            //             selectedTabTextColor: Colors.black,
                            //             tabs: [
                            //               SegmentTab(
                            //                 backgroundColor: Colors.transparent,
                            //                 label: 'Airtime',
                            //               ),
                            //               SegmentTab(
                            //                 backgroundColor: Colors.transparent,
                            //                 label: 'Data Bundle',
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           height: 500,
                            //           child: TabBarView(
                            //             physics: const BouncingScrollPhysics(),
                            //             children: [
                            //               Expanded(
                            //                 child: Container(
                            //                   alignment: Alignment.center,
                            //                   height: 150,
                            //                   child: SingleChildScrollView(
                            //                     child: Column(
                            //                       children: [
                            //                         Row(
                            //                           mainAxisAlignment:
                            //                           MainAxisAlignment
                            //                               .spaceEvenly,
                            //                           children: [
                            //                             // First Container
                            //
                            //                             // GestureDetector(
                            //                             //   onTap: () {
                            //                             //     locator<NavigationService>()
                            //                             //         .navigateToDrawsView();
                            //                             //   },
                            //                             //   child: Padding(
                            //                             //     padding:
                            //                             //     const EdgeInsets
                            //                             //         .only(
                            //                             //         left: 0.0,
                            //                             //         right: 8.0),
                            //                             //     child: ClipRRect(
                            //                             //       borderRadius:
                            //                             //       BorderRadius
                            //                             //           .circular(
                            //                             //           10.0),
                            //                             //       child: Container(
                            //                             //         width:
                            //                             //         80, // Adjust width according to your design
                            //                             //
                            //                             //         decoration:
                            //                             //         BoxDecoration(
                            //                             //           color: Colors
                            //                             //               .grey[200],
                            //                             //           boxShadow: [
                            //                             //             const BoxShadow(
                            //                             //               color: Colors
                            //                             //                   .black12,
                            //                             //               blurRadius:
                            //                             //               5.0,
                            //                             //               spreadRadius:
                            //                             //               1.0,
                            //                             //               offset:
                            //                             //               Offset(
                            //                             //                   0,
                            //                             //                   3),
                            //                             //             ),
                            //                             //           ],
                            //                             //         ),
                            //                             //
                            //                             //         child:
                            //                             //         Image.asset(
                            //                             //           'assets/images/glo.png',
                            //                             //           fit: BoxFit
                            //                             //               .cover,
                            //                             //         ),
                            //                             //       ),
                            //                             //     ),
                            //                             //   ),
                            //                             // ),
                            //
                            //                             // Second Container
                            //                             verticalSpaceSmall,
                            //                             // GestureDetector(
                            //                             //   onTap: () {
                            //                             //     print(
                            //                             //         'there is the second click');
                            //                             //
                            //                             //     locator<NavigationService>()
                            //                             //         .navigateToNotificationView();
                            //                             //   },
                            //                             //   child: Padding(
                            //                             //     padding:
                            //                             //     const EdgeInsets
                            //                             //         .only(
                            //                             //         left: 0.0,
                            //                             //         right: 8.0),
                            //                             //     child: ClipRRect(
                            //                             //       borderRadius:
                            //                             //       BorderRadius
                            //                             //           .circular(
                            //                             //           10.0),
                            //                             //       child: Container(
                            //                             //         width:
                            //                             //         80, // Adjust width according to your design
                            //                             //
                            //                             //         decoration:
                            //                             //         BoxDecoration(
                            //                             //           color: Colors
                            //                             //               .grey[200],
                            //                             //           boxShadow: [
                            //                             //             const BoxShadow(
                            //                             //               color: Colors
                            //                             //                   .black12,
                            //                             //               blurRadius:
                            //                             //               5.0,
                            //                             //               spreadRadius:
                            //                             //               1.0,
                            //                             //               offset:
                            //                             //               Offset(
                            //                             //                   0,
                            //                             //                   3),
                            //                             //             ),
                            //                             //           ],
                            //                             //         ),
                            //                             //
                            //                             //         child:
                            //                             //         Image.asset(
                            //                             //           'assets/images/mtn.png',
                            //                             //           fit: BoxFit
                            //                             //               .cover,
                            //                             //         ),
                            //                             //       ),
                            //                             //     ),
                            //                             //   ),
                            //                             // ),
                            //
                            //                             // Third Container
                            //                             verticalSpaceSmall,
                            //
                            //                             // GestureDetector(
                            //                             //   onTap: () {
                            //                             //     // Action for the third container
                            //                             //
                            //                             //     print(
                            //                             //         'Coming Soon clicked!');
                            //                             //
                            //                             //     // You can navigate or perform other actions here
                            //                             //   },
                            //                             //   child: Padding(
                            //                             //     padding:
                            //                             //     const EdgeInsets
                            //                             //         .only(
                            //                             //         left: 0.0,
                            //                             //         right: 8.0),
                            //                             //     child: ClipRRect(
                            //                             //       borderRadius:
                            //                             //       BorderRadius
                            //                             //           .circular(
                            //                             //           10.0),
                            //                             //       child: Container(
                            //                             //         width:
                            //                             //         80, // Adjust width according to your design
                            //                             //
                            //                             //         decoration:
                            //                             //         BoxDecoration(
                            //                             //           color: Colors
                            //                             //               .grey[200],
                            //                             //           boxShadow: [
                            //                             //             const BoxShadow(
                            //                             //               color: Colors
                            //                             //                   .black12,
                            //                             //               blurRadius:
                            //                             //               5.0,
                            //                             //               spreadRadius:
                            //                             //               1.0,
                            //                             //               offset:
                            //                             //               Offset(
                            //                             //                   0,
                            //                             //                   3),
                            //                             //             ),
                            //                             //           ],
                            //                             //         ),
                            //                             //
                            //                             //         child:
                            //                             //         Image.asset(
                            //                             //           'assets/images/airtel.png',
                            //                             //           fit: BoxFit
                            //                             //               .cover,
                            //                             //         ),
                            //                             //       ),
                            //                             //     ),
                            //                             //   ),
                            //                             // ),
                            //                             verticalSpaceSmall,
                            //
                            //                             GestureDetector(
                            //                               onTap: () {
                            //                                 // Action for the third container
                            //
                            //                                 print(
                            //                                     'Coming Soon clicked!');
                            //
                            //                                 // You can navigate or perform other actions here
                            //                               },
                            //                               child: Padding(
                            //                                 padding:
                            //                                 const EdgeInsets
                            //                                     .only(
                            //                                     left: 0.0,
                            //                                     right: 8.0),
                            //                                 child: ClipRRect(
                            //                                   borderRadius:
                            //                                   BorderRadius
                            //                                       .circular(
                            //                                       10.0),
                            //                                   child: Container(
                            //                                     width:
                            //                                     80, // Adjust width according to your design
                            //
                            //                                     decoration:
                            //                                     BoxDecoration(
                            //                                       color: Colors
                            //                                           .grey[200],
                            //                                       boxShadow: [
                            //                                         const BoxShadow(
                            //                                           color: Colors
                            //                                               .black12,
                            //                                           blurRadius:
                            //                                           5.0,
                            //                                           spreadRadius:
                            //                                           1.0,
                            //                                           offset:
                            //                                           Offset(
                            //                                               0,
                            //                                               3),
                            //                                         ),
                            //                                       ],
                            //                                     ),
                            //
                            //                                     child:
                            //                                     Image.asset(
                            //                                       'assets/images/etisalat.png',
                            //                                       fit: BoxFit
                            //                                           .cover,
                            //                                     ),
                            //                                   ),
                            //                                 ),
                            //                               ),
                            //                             ),
                            //                           ],
                            //                         ),
                            //                         verticalSpaceMedium,
                            //                         // Container(
                            //                         //   alignment: Alignment.bottomRight,
                            //                         //   child: Text(
                            //                         //     textAlign: TextAlign.left,
                            //                         //     'No beneficiary',
                            //                         //   ),
                            //                         // ),
                            //                         // TextFieldWidget(
                            //                         //   hint: "Mobile number",
                            //                         //   controller:
                            //                         //   _phoneNumberController,
                            //                         // ),
                            //                         // verticalSpaceMedium,
                            //                         // TextFieldWidget(
                            //                         //   hint: "Amount",
                            //                         //   controller:
                            //                         //   _amountNumberController,
                            //                         // ),
                            //                         // verticalSpaceMedium,
                            //                         // Container(
                            //                         //   alignment: Alignment.bottomLeft,
                            //                         //   child: Text(
                            //                         //       textAlign: TextAlign.left,
                            //                         //       'Select amount'),
                            //                         // ),
                            //                         // Row(
                            //                         //   mainAxisAlignment:
                            //                         //   MainAxisAlignment
                            //                         //       .spaceBetween,
                            //                         //   children: [
                            //                         //     Card(
                            //                         //         child: Padding(
                            //                         //           padding:
                            //                         //           const EdgeInsets
                            //                         //               .all(8.0),
                            //                         //           child: Text('NGN 200'),
                            //                         //         )),
                            //                         //     horizontalSpaceMedium,
                            //                         //     Card(
                            //                         //         child: Padding(
                            //                         //           padding:
                            //                         //           const EdgeInsets
                            //                         //               .all(8.0),
                            //                         //           child: Text('NGN 500'),
                            //                         //         )),
                            //                         //     horizontalSpaceMedium,
                            //                         //     Card(
                            //                         //         child: Padding(
                            //                         //           padding:
                            //                         //           const EdgeInsets
                            //                         //               .all(8.0),
                            //                         //           child: Text('NGN 1000'),
                            //                         //         )),
                            //                         //   ],
                            //                         // ),
                            //                         // verticalSpaceMedium,
                            //                         // SubmitButton(
                            //                         //   isLoading: false,
                            //                         //   boldText: true,
                            //                         //   label: "Pay Up",
                            //                         //   submit: () {
                            //                         //     //locator<NavigationService>().clearStackAndShow(Routes.homeView);
                            //                         //   },
                            //                         //   color: kcPrimaryColor,
                            //                         // ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //               // Expanded(
                            //               //   child: Container(
                            //               //     alignment: Alignment.center,
                            //               //     height: 150,
                            //               //     child: SingleChildScrollView(
                            //               //       child: Column(
                            //               //         children: [
                            //               //           Row(
                            //               //             mainAxisAlignment:
                            //               //             MainAxisAlignment
                            //               //                 .spaceEvenly,
                            //               //             children: [
                            //               //               // First Container
                            //               //
                            //               //               GestureDetector(
                            //               //                 onTap: () {
                            //               //                   locator<NavigationService>()
                            //               //                       .navigateToDrawsView();
                            //               //                 },
                            //               //                 child: Padding(
                            //               //                   padding:
                            //               //                   const EdgeInsets
                            //               //                       .only(
                            //               //                       left: 0.0,
                            //               //                       right: 8.0),
                            //               //                   child: ClipRRect(
                            //               //                     borderRadius:
                            //               //                     BorderRadius
                            //               //                         .circular(
                            //               //                         10.0),
                            //               //                     child: Container(
                            //               //                       width:
                            //               //                       80, // Adjust width according to your design
                            //               //
                            //               //                       decoration:
                            //               //                       BoxDecoration(
                            //               //                         color: Colors
                            //               //                             .grey[200],
                            //               //                         boxShadow: [
                            //               //                           const BoxShadow(
                            //               //                             color: Colors
                            //               //                                 .black12,
                            //               //                             blurRadius:
                            //               //                             5.0,
                            //               //                             spreadRadius:
                            //               //                             1.0,
                            //               //                             offset:
                            //               //                             Offset(
                            //               //                                 0,
                            //               //                                 3),
                            //               //                           ),
                            //               //                         ],
                            //               //                       ),
                            //               //
                            //               //                       child:
                            //               //                       Image.asset(
                            //               //                         'assets/images/glo.png',
                            //               //                         fit: BoxFit
                            //               //                             .cover,
                            //               //                       ),
                            //               //                     ),
                            //               //                   ),
                            //               //                 ),
                            //               //               ),
                            //               //
                            //               //               // Second Container
                            //               //
                            //               //               GestureDetector(
                            //               //                 onTap: () {
                            //               //                   print(
                            //               //                       'there is the second click');
                            //               //
                            //               //                   locator<NavigationService>()
                            //               //                       .navigateToNotificationView();
                            //               //                 },
                            //               //                 child: Padding(
                            //               //                   padding:
                            //               //                   const EdgeInsets
                            //               //                       .only(
                            //               //                       left: 0.0,
                            //               //                       right: 8.0),
                            //               //                   child: ClipRRect(
                            //               //                     borderRadius:
                            //               //                     BorderRadius
                            //               //                         .circular(
                            //               //                         10.0),
                            //               //                     child: Container(
                            //               //                       width:
                            //               //                       80, // Adjust width according to your design
                            //               //
                            //               //                       decoration:
                            //               //                       BoxDecoration(
                            //               //                         color: Colors
                            //               //                             .grey[200],
                            //               //                         boxShadow: [
                            //               //                           const BoxShadow(
                            //               //                             color: Colors
                            //               //                                 .black12,
                            //               //                             blurRadius:
                            //               //                             5.0,
                            //               //                             spreadRadius:
                            //               //                             1.0,
                            //               //                             offset:
                            //               //                             Offset(
                            //               //                                 0,
                            //               //                                 3),
                            //               //                           ),
                            //               //                         ],
                            //               //                       ),
                            //               //
                            //               //                       child:
                            //               //                       Image.asset(
                            //               //                         'assets/images/mtn.png',
                            //               //                         fit: BoxFit
                            //               //                             .cover,
                            //               //                       ),
                            //               //                     ),
                            //               //                   ),
                            //               //                 ),
                            //               //               ),
                            //               //
                            //               //               // Third Container
                            //               //
                            //               //               GestureDetector(
                            //               //                 onTap: () {
                            //               //                   // Action for the third container
                            //               //
                            //               //                   print(
                            //               //                       'Coming Soon clicked!');
                            //               //
                            //               //                   // You can navigate or perform other actions here
                            //               //                 },
                            //               //                 child: Padding(
                            //               //                   padding:
                            //               //                   const EdgeInsets
                            //               //                       .only(
                            //               //                       left: 0.0,
                            //               //                       right: 8.0),
                            //               //                   child: ClipRRect(
                            //               //                     borderRadius:
                            //               //                     BorderRadius
                            //               //                         .circular(
                            //               //                         10.0),
                            //               //                     child: Container(
                            //               //                       width:
                            //               //                       80, // Adjust width according to your design
                            //               //
                            //               //                       decoration:
                            //               //                       BoxDecoration(
                            //               //                         color: Colors
                            //               //                             .grey[200],
                            //               //                         boxShadow: [
                            //               //                           const BoxShadow(
                            //               //                             color: Colors
                            //               //                                 .black12,
                            //               //                             blurRadius:
                            //               //                             5.0,
                            //               //                             spreadRadius:
                            //               //                             1.0,
                            //               //                             offset:
                            //               //                             Offset(
                            //               //                                 0,
                            //               //                                 3),
                            //               //                           ),
                            //               //                         ],
                            //               //                       ),
                            //               //
                            //               //                       child:
                            //               //                       Image.asset(
                            //               //                         'assets/images/airtel.png',
                            //               //                         fit: BoxFit
                            //               //                             .cover,
                            //               //                       ),
                            //               //                     ),
                            //               //                   ),
                            //               //                 ),
                            //               //               ),
                            //               //
                            //               //               GestureDetector(
                            //               //                 onTap: () {
                            //               //                   // Action for the third container
                            //               //
                            //               //                   print(
                            //               //                       'Coming Soon clicked!');
                            //               //
                            //               //                   // You can navigate or perform other actions here
                            //               //                 },
                            //               //                 child: Padding(
                            //               //                   padding:
                            //               //                   const EdgeInsets
                            //               //                       .only(
                            //               //                       left: 0.0,
                            //               //                       right: 8.0),
                            //               //                   child: ClipRRect(
                            //               //                     borderRadius:
                            //               //                     BorderRadius
                            //               //                         .circular(
                            //               //                         10.0),
                            //               //                     child: Container(
                            //               //                       width:
                            //               //                       80, // Adjust width according to your design
                            //               //
                            //               //                       decoration:
                            //               //                       BoxDecoration(
                            //               //                         color: Colors
                            //               //                             .grey[200],
                            //               //                         boxShadow: [
                            //               //                           const BoxShadow(
                            //               //                             color: Colors
                            //               //                                 .black12,
                            //               //                             blurRadius:
                            //               //                             5.0,
                            //               //                             spreadRadius:
                            //               //                             1.0,
                            //               //                             offset:
                            //               //                             Offset(
                            //               //                                 0,
                            //               //                                 3),
                            //               //                           ),
                            //               //                         ],
                            //               //                       ),
                            //               //                       child:
                            //               //                       Image.asset(
                            //               //                         'assets/images/etisalat.png',
                            //               //                         fit: BoxFit
                            //               //                             .cover,
                            //               //                       ),
                            //               //                     ),
                            //               //                   ),
                            //               //                 ),
                            //               //               ),
                            //               //             ],
                            //               //           ),
                            //               //           verticalSpaceMedium,
                            //               //           Container(
                            //               //             alignment: Alignment.bottomRight,
                            //               //             child: Text(
                            //               //               textAlign: TextAlign.left,
                            //               //               'No beneficiary',
                            //               //             ),
                            //               //           ),
                            //               //           TextFieldWidget(
                            //               //             hint: "Mobile number",
                            //               //             controller:
                            //               //             _phoneNumberController,
                            //               //           ),
                            //               //           verticalSpaceMedium,
                            //               //           SizedBox(height: 16.0),
                            //               //           DropdownButtonFormField<
                            //               //               String>(
                            //               //             value: selectedBundle,
                            //               //             onChanged: (newValue) {
                            //               //               setState(() {
                            //               //                 selectedBundle =
                            //               //                     newValue;
                            //               //               });
                            //               //             },
                            //               //             items: <String>[
                            //               //               'Bundle 1',
                            //               //               'Bundle 2',
                            //               //               'Bundle 3'
                            //               //             ]
                            //               //                 .map((bundle) =>
                            //               //                 DropdownMenuItem(
                            //               //                   value: bundle,
                            //               //                   child:
                            //               //                   Text(bundle),
                            //               //                 ))
                            //               //                 .toList(),
                            //               //             decoration: InputDecoration(
                            //               //               labelText:
                            //               //               'Select Bundles',
                            //               //               border:
                            //               //               OutlineInputBorder(),
                            //               //               contentPadding:
                            //               //               EdgeInsets.symmetric(
                            //               //                   horizontal: 12),
                            //               //             ),
                            //               //           ),
                            //               //           verticalSpaceMedium,
                            //               //           TextFieldWidget(
                            //               //             hint: "Amount",
                            //               //             controller:
                            //               //             _amountNumberController,
                            //               //           ),
                            //               //           verticalSpaceMedium,
                            //               //           Container(
                            //               //             alignment: Alignment.bottomLeft,
                            //               //             child: Text(
                            //               //                 textAlign: TextAlign.left,
                            //               //                 'Select amount'),
                            //               //           ),
                            //               //           Row(
                            //               //             mainAxisAlignment:
                            //               //             MainAxisAlignment
                            //               //                 .spaceBetween,
                            //               //             children: [
                            //               //               Card(
                            //               //                   child: Padding(
                            //               //                     padding:
                            //               //                     const EdgeInsets
                            //               //                         .all(8.0),
                            //               //                     child: Text('NGN 200'),
                            //               //                   )),
                            //               //               horizontalSpaceMedium,
                            //               //               Card(
                            //               //                   child: Padding(
                            //               //                     padding:
                            //               //                     const EdgeInsets
                            //               //                         .all(8.0),
                            //               //                     child: Text('NGN 500'),
                            //               //                   )),
                            //               //               horizontalSpaceMedium,
                            //               //               Card(
                            //               //                   child: Padding(
                            //               //                     padding:
                            //               //                     const EdgeInsets
                            //               //                         .all(8.0),
                            //               //                     child: Text('NGN 1000'),
                            //               //                   )),
                            //               //             ],
                            //               //           ),
                            //               //           verticalSpaceMedium,
                            //               //           SubmitButton(
                            //               //             isLoading: false,
                            //               //             boldText: true,
                            //               //             label: "Pay Up",
                            //               //             submit: () {
                            //               //               //locator<NavigationService>().clearStackAndShow(Routes.homeView);
                            //               //             },
                            //               //             color: kcPrimaryColor,
                            //               //           ),
                            //               //         ],
                            //               //       ),
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //             ],
                            //           ),
                            //         ),
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            verticalSpaceSmall,

                            // RefreshIndicator(
                            //   onRefresh: () async {
                            //     // await viewModel.refreshData();
                            //   },
                            //   child: loading
                            //       ? Padding(
                            //     padding: const EdgeInsets.all(26.0),
                            //     child: const Center(
                            //       child: CircularProgressIndicator(),
                            //     ),
                            //   )
                            //       : transactions.isEmpty
                            //       ? const EmptyState(
                            //     animation: "no_transactions.json",
                            //     label: "No Transaction Yet",
                            //   )
                            //       : ListView.builder(
                            //     itemCount: groupedTransactions
                            //         .keys.length,
                            //     itemBuilder: (context, index) {
                            //       String monthYear =
                            //       groupedTransactions.keys
                            //           .elementAt(index);
                            //
                            //       List<Transaction> transactions =
                            //       groupedTransactions[
                            //       monthYear]!;
                            //
                            //       return Column(
                            //         crossAxisAlignment:
                            //         CrossAxisAlignment.start,
                            //         children: [
                            //           Padding(
                            //             padding: const EdgeInsets
                            //                 .symmetric(
                            //                 horizontal: 30.0,
                            //                 vertical: 10.0),
                            //             child: Text(
                            //               monthYear,
                            //               style: GoogleFonts
                            //                   .redHatDisplay(
                            //                 textStyle: TextStyle(
                            //                   fontSize: 16,
                            //                   fontWeight:
                            //                   FontWeight.w400,
                            //                   color: uiMode
                            //                       .value ==
                            //                       AppUiModes
                            //                           .dark
                            //                       ? kcLightGrey
                            //                       : kcMediumGrey,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //           ...transactions.map(
                            //                 (transaction) => Padding(
                            //               padding:
                            //               const EdgeInsets
                            //                   .symmetric(
                            //                   horizontal:
                            //                   16.0),
                            //               child: ListTile(
                            //                 minLeadingWidth: 10,
                            //                 leading: Container(
                            //                   margin:
                            //                   const EdgeInsets
                            //                       .only(
                            //                       right: 8),
                            //                   child: SvgPicture
                            //                       .asset(
                            //                     'assets/icons/ticket_out.svg',
                            //                     height: 28,
                            //                   ),
                            //                 ),
                            //                 title: Text(
                            //                   transaction.paymentType ==
                            //                       'raffle'
                            //                       ? 'Ticket Purchase'
                            //                       : transaction
                            //                       .paymentType ==
                            //                       'donation'
                            //                       ? 'Project Donation'
                            //                       : 'Purchase',
                            //                   style: GoogleFonts
                            //                       .redHatDisplay(
                            //                     textStyle:
                            //                     const TextStyle(
                            //                       fontSize: 14,
                            //                       fontWeight:
                            //                       FontWeight
                            //                           .w500,
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 subtitle: Text(
                            //                   DateFormat(
                            //                       'EEEE, d MMM hh:mm a')
                            //                       .format(
                            //                     DateTime.parse(
                            //                         transaction
                            //                             .createdAt!),
                            //                   ),
                            //                   style: GoogleFonts
                            //                       .redHatDisplay(
                            //                     textStyle:
                            //                     TextStyle(
                            //                       fontSize: 11,
                            //                       fontWeight:
                            //                       FontWeight
                            //                           .w400,
                            //                       color: uiMode
                            //                           .value ==
                            //                           AppUiModes
                            //                               .dark
                            //                           ? kcLightGrey
                            //                           : kcMediumGrey,
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 trailing: Column(
                            //                   mainAxisAlignment:
                            //                   MainAxisAlignment
                            //                       .center,
                            //                   crossAxisAlignment:
                            //                   CrossAxisAlignment
                            //                       .end,
                            //                   children: [
                            //                     Text(
                            //                       transaction.paymentType ==
                            //                           'raffle'
                            //                           ? '+₦${transaction.amount}'
                            //                           : '-₦${transaction.amount}',
                            //                       style:
                            //                       TextStyle(
                            //                         color: transaction.paymentType ==
                            //                             'donation'
                            //                             ? Colors
                            //                             .red
                            //                             : Colors
                            //                             .green,
                            //                         fontSize: 16,
                            //                         fontWeight:
                            //                         FontWeight
                            //                             .w500,
                            //                         fontFamily:
                            //                         'roboto',
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpaceSmall,
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Bookings',
              //         style: TextStyle(fontSize: 16),
              //       ),
              //       Text(
              //         'Book now',
              //         style: TextStyle(fontSize: 14, color: kcPrimaryColor),
              //       ),
              //     ],
              //   ),
              // ),
              verticalSpaceSmall,
            ],
          ),
        ),
      ),
    );
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
