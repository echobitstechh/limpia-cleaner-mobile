import 'package:flutter/widgets.dart';
import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.router.dart';
import 'package:limpia/core/data/models/profile.dart';
import 'package:limpia/core/data/repositories/repository.dart';
import 'package:limpia/core/network/api_response.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/common/ui_helpers.dart';
import 'package:limpia/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:limpia/core/data/models/profile.dart' as pro;
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/transaction.dart';
import '../../../state.dart';
import '../../components/empty_state.dart';
import 'full_transaction_page.dart';

class Wallet extends StatefulWidget {
  // final pro.Wallet wallet;

  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late pro.Wallet wallet = pro.Wallet(balance: 0);
  bool loading = false;
  bool loadingProfile = true;
  List<Transaction> transactions = [];
  Map<String, List<Transaction>> groupedTransactions = {};

  @override
  void initState() {
    getProfile();
    getHistory();

    super.initState();
  }


  void getHistory() async {
    setState(() {
      loading = true;
    });

    try {
      ApiResponse res = await locator<Repository>().getTransactions();
      if (res.statusCode == 200) {
        setState(() {
          //print('this is for the amount${res.data['data']['items'].amount}');
          //print('without amount${res.data['data']['items']}');
          transactions = (res.data['data']['items']
                  as List) // Accessing items array
              .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          groupRidesByMonth();
        });
      }
    } catch (e) {
      throw Exception("Error Api call");
    }

    setState(() {
      loading = false;
    });
  }

  void groupRidesByMonth() {
    setState(() {
      groupedTransactions.clear();
      for (var transaction in transactions) {
        String monthYear = transaction.createdAt != null
            ? DateFormat('MMMM yyyy').format(DateTime.parse(transaction.createdAt!))
            : 'Unknown Date';
        if (groupedTransactions.containsKey(monthYear)) {
          groupedTransactions[monthYear]!.add(transaction);
        } else {
          groupedTransactions[monthYear] = [transaction];
        }
      }
    });
  }

  Future<void> getProfile() async {
    ApiResponse res = await locator<Repository>().getProfile();
    setState(() {
      loadingProfile = false;
      if (res.statusCode == 200) {
        Map<String, dynamic> userData =
            res.data["data"] as Map<String, dynamic>;
        profile.value = Profile.fromJson(userData);
        // if (profile.value.wallet != null) {
        //   wallet = profile.value.wallet!;
        // } else {
        //   wallet = pro.Wallet(balance: 0);
        // }
      } else {
        wallet = pro.Wallet(balance: 0);
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.asset(
                  height: 150,
                  width: 150,
                  'assets/images/limpiarblue.png'
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getProfile();
        },
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Container(
                    height: 150,
                    width: 400,
                    color: kcPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                      'Cumulative Payment:'
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                      '\$ 200,000.00'
                                  )
                                ],
                              ),
                            ],
                          ),
                          horizontalSpaceLarge,
                          horizontalSpaceMedium,
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                      'Next Payment:'
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                      '20/09/2010')
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                      '\$200,000.00')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // child: Stack(
                    //   alignment: Alignment.center, // Centers all children in the stack
                    //   children: [
                    //     // Background Image
                    //     Align(
                    //       alignment: Alignment.center,
                    //       child: SizedBox(
                    //         width: 400,
                    //         child: const Image(
                    //           image: AssetImage('assets/images/Frame.png'),
                    //           fit: BoxFit.cover, // Ensures the image covers the container
                    //         ),
                    //       ),
                    //     ),
                    //     Align(
                    //       alignment: Alignment.center,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             'Wallet Balance',
                    //             style: GoogleFonts.redHatDisplay(
                    //               textStyle: const TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: kcWhiteColor,
                    //               ),
                    //             ),
                    //           ),
                    //           Text(
                    //             '${profile.value.accountPoints ?? 0} pts',
                    //             style: GoogleFonts.redHatDisplay(
                    //               textStyle: const TextStyle(
                    //                 fontSize: 36,
                    //                 fontWeight: FontWeight.w700,
                    //                 color: kcPrimaryColor,
                    //               ),
                    //             ),
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.end,
                    //             children: [
                    //               Text(
                    //                 '${profile.value.accountPointsLocal ?? 0}',
                    //                 style: const TextStyle(
                    //                   fontFamily: 'Roboto',
                    //                   fontSize: 14, // Size for the dollar amount
                    //                   fontWeight: FontWeight.w900,
                    //                   color: kcPrimaryColor,
                    //                 ),
                    //               ),
                    //               horizontalSpaceMedium
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ],
            ),
            verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                child: Text(
                    style: TextStyle(
                      fontSize: 26
                    ),
                    'Payment History'),
              ),
            ),
            verticalSpaceSmall,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                                '\$20.00'
                            )
                          ],
                       ),
                       Column(
                          children: [
                            Text('Paid in full from Johnsons')
                          ],
                       )
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                          children: [
                            Text('21.00am')
                          ],
                       ),
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                         children: [
                           Image.asset('assets/images/Vec.png')
                         ],
                       ),
                       Column(
                          children: [
                            Text('received')
                          ],
                       ),
                     ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                                '\$800.00'
                            )
                          ],
                       ),
                       Column(
                          children: [
                            Text('Paid to you')
                          ],
                       )
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                          children: [
                            Text('2hrs ago')
                          ],
                       ),
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                         children: [
                           Image.asset('assets/images/Vec.png')
                         ],
                       ),
                       Column(
                          children: [
                            Text('received')
                          ],
                       ),
                     ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                                '\$800.00'
                            )
                          ],
                       ),
                       Column(
                          children: [
                            Text('Paid to you')
                          ],
                       )
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                          children: [
                            Text('2hrs ago')
                          ],
                       ),
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                         children: [
                           Image.asset('assets/images/Vec.png')
                         ],
                       ),
                       Column(
                          children: [
                            Text('received')
                          ],
                       ),
                     ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                                '\$20.00'
                            )
                          ],
                       ),
                       Column(
                          children: [
                            Text('Paid to you')
                          ],
                       )
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                          children: [
                            Text('21.00am')
                          ],
                       ),
                     ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                     children: [
                       Column(
                         children: [
                           Image.asset('assets/images/Vec.png')
                         ],
                       ),
                       Column(
                          children: [
                            Text('received')
                          ],
                       ),
                     ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                                '\$800.00'
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text('Paid to you')
                          ],
                        )
                      ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                      children: [
                        Column(
                          children: [
                            Text('2hrs ago')
                          ],
                        ),
                      ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/images/Vec.png')
                          ],
                        ),
                        Column(
                          children: [
                            Text('received')
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                                '\$20.00'
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text('Paid to you')
                          ],
                        )
                      ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                      children: [
                        Column(
                          children: [
                            Text('21.00am')
                          ],
                        ),
                      ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/images/Vec.png')
                          ],
                        ),
                        Column(
                          children: [
                            Text('received')
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                                '\$800.00'
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text('Paid to you')
                          ],
                        )
                      ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                      children: [
                        Column(
                          children: [
                            Text('2hrs ago')
                          ],
                        ),
                      ],
                    ),
                    horizontalSpaceMedium,
                    Column(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/images/Vec.png')
                          ],
                        ),
                        Column(
                          children: [
                            Text('received')
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 26.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Transactions",
            //         style: GoogleFonts.bricolageGrotesque(
            //           textStyle:  TextStyle(
            //             fontSize: 15, // Custom font size
            //             fontWeight: FontWeight.w700, // Custom font weight
            //             color: uiMode.value == AppUiModes.dark ? kcWhiteColor : kcBlackColor, // Custom text color
            //           ),
            //         ),
            //       ),
            //       InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => FullTransactionsPage()),
            //           );
            //         },
            //         child: Text(
            //           "See all",
            //           style: GoogleFonts.redHatDisplay(
            //             textStyle: const TextStyle(
            //               fontSize: 13,
            //               fontWeight: FontWeight.w700,
            //               color: Colors.blue,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // loading
            //     ? Padding(
            //   padding: const EdgeInsets.all(26.0),
            //   child: const Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // )
            //     : transactions.isEmpty
            //     ? const EmptyState(
            //   animation: "no_transactions.json",
            //   label: "No Transaction Yet",
            // )
            //     : SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.6, // Bounded height
            //   child: ListView.builder(
            //     itemCount: groupedTransactions.keys.length,
            //     itemBuilder: (context, index) {
            //       String monthYear = groupedTransactions.keys.elementAt(index);
            //       List<Transaction> transactions = groupedTransactions[monthYear]!;
            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 30.0, vertical: 10.0),
            //             child: Text(
            //               monthYear,
            //               style: GoogleFonts.redHatDisplay(
            //                 textStyle:  TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w400,
            //                   color: uiMode.value == AppUiModes.dark ? kcLightGrey :  kcMediumGrey,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           ...transactions.map(
            //                 (transaction) => Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //               child: ListTile(
            //                 minLeadingWidth: 10,
            //                 leading: Container(
            //                   margin: const EdgeInsets.only(right: 8),
            //                   child: SvgPicture.asset(
            //                     'assets/icons/ticket_out.svg',
            //                     height: 28,
            //                   ),
            //                 ),
            //                 title: Text(
            //                   transaction.paymentType == 'raffle'
            //                       ? 'Ticket Purchase'
            //                       : transaction.paymentType == 'donation'
            //                       ? 'Project Donation'
            //                       : 'Purchase',
            //                   style: GoogleFonts.redHatDisplay(
            //                     textStyle: const TextStyle(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                   ),
            //                 ),
            //                 subtitle: Text(
            //                   DateFormat('EEEE, d MMM hh:mm a').format(
            //                     DateTime.parse(transaction.createdAt!),
            //                   ),
            //                   style: GoogleFonts.redHatDisplay(
            //                     textStyle:  TextStyle(
            //                       fontSize: 11,
            //                       fontWeight: FontWeight.w400,
            //                       color: uiMode.value == AppUiModes.dark ? kcLightGrey : kcMediumGrey,
            //                     ),
            //                   ),
            //                 ),
            //                 trailing: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.end,
            //                   children: [
            //                     Text(
            //                       transaction.paymentType == 'raffle'
            //                           ? '+₦${transaction.amount}'
            //                           : '-₦${transaction.amount}',
            //                       style: TextStyle(
            //                         color: transaction.paymentType == 'donation'
            //                             ? Colors.red
            //                             : Colors.green,
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.w500,
            //                         fontFamily: 'roboto'
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
    );
  }

}
