import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limpia/ui/common/ui_helpers.dart';
import 'package:limpia/ui/views/dashboard/dashboard_viewmodel.dart';
import 'package:limpia/utils/date_time_utils.dart';
import 'package:stacked_services/stacked_services.dart';


import '../app/app.locator.dart';
import '../ui/common/helper.dart';
import 'booking_success.dart';


class BookingAssignmentCard extends StatelessWidget {
  final BookingInfo bookingInfo;
  final BuildContext context;
  final DashboardViewModel viewModel;

  const BookingAssignmentCard({
    Key? key,
    required this.bookingInfo,
    required this.context,
    required this.viewModel,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 30, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            // Booking Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SQFT and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SQFT: 760",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Price: 55/hr",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Address
                  Text(
                    "Address: ${bookingInfo?.booking.property?.address ?? bookingInfo?.booking.address},"
                        " ${bookingInfo?.booking.property?.state ?? bookingInfo?.booking?.state}",
                      style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  bookingInfo.booking.isTaken == false
                      ? Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showRejectDialog(context, bookingInfo.booking.id);
                        },
                        child: Container(
                          height: 30,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Reject",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      horizontalSpaceTiny,
                      InkWell(
                        onTap: () {
                          showAcceptBottomSheet(context, bookingInfo,viewModel);
                        },
                        child: Container(
                          height: 30,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Accept",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green,
                    ),
                    child: Text(
                      bookingInfo.booking.status,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Date and Time
                  //TODO: Why is it multiple times && Dates??
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${formatDateString(bookingInfo.booking.date?.firstOrNull) ?? ""} ${bookingInfo.booking.time?.firstOrNull ?? ""}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Show reject dialog
void showRejectDialog(BuildContext context, String id) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Warning"),
      content: const Text(
          "Are you sure? You won’t be able to see this job again if you reject it."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async{
            await DashboardViewModel().updateCleanerAssignments(id, "reject");
            Navigator.pop(context);
           locator<SnackbarService>().showSnackbar(message: "Booking Rejected successfully");
            // Handle rejection logic here
          },
          child: const Text("Reject"),
        ),
      ],
    ),
  );
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent accidental dismiss by clicking outside
    builder: (context) {
      return SuccessWidget(
        message: "Booking Accepted",
        onDismiss: () {
          debugPrint("Success dialog dismissed");
          Navigator.pop(context);
        },
      );
    },
  );
}

void showAcceptBottomSheet(BuildContext context, BookingInfo bookingInfo,DashboardViewModel viewModel) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Status Header
              Text(
                "Bookings Details",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Booking Title
              Text(
                bookingInfo.booking.cleaningType,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${bookingInfo.booking.property?.nameOfProperty ?? ""}",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                "${bookingInfo.booking.property?.type ?? ""}",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 12),
              // Details Header
              Text(
                "Details",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              // Grid of details
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                children: [
                  _buildDetailItem(
                    icon: Icons.timer_outlined,
                    title: "2h 30 min",
                    subtitle: "Est Time",
                  ),
                  _buildDetailItem(
                    icon: Icons.location_on_outlined,
                    title: "${bookingInfo?.booking.property?.address ?? bookingInfo?.booking.address}, ${bookingInfo?.booking.property?.state ?? bookingInfo?.booking.state}",
                    subtitle: "Location",
                  ),
                  _buildDetailItem(
                    icon: Icons.calendar_today_outlined,
                    title:'${formatDateString(bookingInfo.booking.date?.firstOrNull) ?? ""} ${bookingInfo.booking.time?.firstOrNull ?? ""}',
                    subtitle: "Date",
                  ),
                  _buildDetailItem(
                    icon: Icons.monetization_on_outlined,
                    title: "55 per hour",
                    subtitle: "Price",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () async {
                      await DashboardViewModel().updateCleanerAssignments(bookingInfo.booking.id, "reject");
                      Navigator.pop(context);
                      locator<SnackbarService>().showSnackbar(message: "Booking Rejected successfully");

                    },
                    child: viewModel.isBusy
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
                      "Reject",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () async {
                      var bool = await DashboardViewModel().acceptBooking(bookingInfo.booking.id);
                      if(bool){
                        showSuccessDialog(context);
                      } else {
                        locator<SnackbarService>().showSnackbar(message: "Oops! Something went wrong");
                      }
                    },
                    child: viewModel.isBusy
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
                      "Accept",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDetailItem({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.black87, size: 24),
        const SizedBox(width: 8),
        Expanded( // Ensure the text does not cause overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1, // Prevent overflow to multiple lines
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflowed text
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1, // Prevent overflow to multiple lines
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflowed text
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

