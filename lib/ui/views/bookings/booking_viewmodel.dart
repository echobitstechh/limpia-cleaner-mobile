import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../core/data/models/booking.dart';
import '../../../core/data/repositories/repository.dart';
import '../../../core/network/api_response.dart';
import '../dashboard/dashboard_viewmodel.dart';

class BookingsViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("BookingsViewModel");

  List<BookingInfo> pendingBookinginfos = [];
  List<BookingInfo> bookingInfos = [];
  List<BookingInfo> activebookingInfos = [];
  BookingInfo? activebookingInfo;



  String searchQuery = '';
  List<BookingInfo> filteredBookingInfos = [];



  DateTime? selectedDay;

  List<DateTime> activeBookingDays = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 5)),
  ];

  List<String> getEventsForDay(DateTime day) {
    if (activeBookingDays.contains(day)) {
      return ['Active Booking'];
    }
    return [];
  }

  void onDaySelected(DateTime day) {
    selectedDay = day;
    notifyListeners();
  }




  Future<void> init() async {
    setBusy(true);
    await displayAllNearByBookings();
    setBusy(false);
    notifyListeners();
  }



  Future<void> refreshData() async {
    print('refreshing data');
    setBusy(true);
    notifyListeners();
    getResourceList();
    setBusy(false);
    notifyListeners();
  }

  void getResourceList(){
    displayAllNearByBookings();
  }

  Future<void> updateCleanerAssignments(String cleanerAssignmentId,String action) async {
    setBusy(true);
    try {
      ApiResponse res = await repo.updateCleanerAssignments(cleanerAssignmentId, action);
      if (res.statusCode == 200) {
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e);
    } finally{
      setBusy(false);
    }
  }

  void onEnd() {
    print('onEnd');
    //TODO SEND USER NOTIFICATION OF AVAILABILITY OF PRODUCT
    notifyListeners();
  }

  Future<void> displayAllNearByBookings() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse response = await repo.displayAllNearByBookings();
      if (response.statusCode == 200) {
        final data = response.data;

        print('Before Bookings::: $data');
        if (data != null && data['bookings'] != null && data['bookings'] is List) {

          print("bookings::: ${data['bookings']}");

          bookingInfos = (data['bookings'] as List)
              .map((assignment) => BookingInfo.fromJson(assignment))
              .toList();

          // Sort assignments by the first date in descending order
          bookingInfos.sort((a, b) {
            DateTime dateA = DateTime.parse(a.booking.date.first);
            DateTime dateB = DateTime.parse(b.booking.date.first);
            return dateB.compareTo(dateA);
          });

          pendingBookinginfos = bookingInfos
              .where((assignment) => assignment.booking.isTaken == false)
              .toList();

          activebookingInfos = bookingInfos
              .where((assignment) => assignment.booking.status == 'Active')
              .toList();

          print('Active Bookings::: $activebookingInfos');

          activebookingInfo = bookingInfos.isNotEmpty && bookingInfos.any((info) => info.booking.isTaken)
              ? bookingInfos.firstWhere((info) => info.booking.isTaken)
              : null;


        } else {
          pendingBookinginfos = [];
          bookingInfos = [];
          activebookingInfo = null;
          activebookingInfos = [];
        }
      } else {
        throw Exception('Failed to load assignments');
      }
    } catch (e) {
      log.e(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }


  void updateSearchQuery(String query) {
    searchQuery = query;

    if (searchQuery.isEmpty) {
      filteredBookingInfos = bookingInfos;
    } else {
      filteredBookingInfos = bookingInfos.where((service) {
        final propertyName = service.booking.property?.nameOfProperty?.toLowerCase() ?? '';
        final bookingCity = service.booking.city?.toLowerCase() ?? '';
        final bookingState = service.booking.state?.toLowerCase() ?? '';
        final propertyCity = service.booking.property?.city?.toLowerCase() ?? '';

        // Check if the search query matches any of the fields
        return propertyName.contains(searchQuery.toLowerCase()) ||
            bookingCity.contains(searchQuery.toLowerCase()) ||
            bookingState.contains(searchQuery.toLowerCase()) ||
            propertyCity.contains(searchQuery.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }




}
