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

  List<Booking> pendingBookings = [];
  List<Booking> completedBookings = [];
  List<Booking> bookings = [];
  List<Booking> activeBookings = [];
  Booking? activeBooking;



  String searchQuery = '';
  List<Booking> filteredBookings = [];



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
      ApiResponse res = await repo.updateBooking(cleanerAssignmentId, action);
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
      ApiResponse response = await repo.getNearByBookings();
      if (response.statusCode == 200) {
        final data = response.data;

        print('Before Bookings::: $data');
        if (data != null && data['bookings'] != null && data['bookings'] is List) {

          print("bookings::: ${data['bookings']}");

          bookings = (data['bookings'] as List)
              .map((assignment) => Booking.fromJson(assignment))
              .toList();

          // Sort assignments by the first date in descending order
          bookings.sort((a, b) {
            return b.cleaningTime?.compareTo(a.cleaningTime ?? DateTime(0)) ?? 0;
          });

          pendingBookings = bookings
              .where((x) => x.bookingStatus == 'PENDING')
              .toList();

          completedBookings = bookings
              .where((x) => x.bookingStatus == 'COMPLETED')
              .toList();

          activeBookings = bookings.where((x) => x.bookingStatus == 'CONFIRMED').toList();

          print('Active Bookings::: $activeBookings');

          //TODO: Update this to be only current booking in progress
          activeBooking = bookings.isNotEmpty && bookings.any((x) => x.bookingStatus == 'CONFIRMED' || x.bookingStatus == 'IN_PROGRESS')
              ? (bookings.where((x) => x.bookingStatus == 'CONFIRMED' || x.bookingStatus == 'IN_PROGRESS')
              .toList()
            ..sort((a, b) => a.cleaningTime?.compareTo(b.cleaningTime ?? DateTime(0)) ?? 0))
              .first
              : null;


        } else {
          pendingBookings = [];
          completedBookings = [];
          bookings = [];
          activeBooking = null;
          activeBookings = [];
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
      filteredBookings = bookings;
    } else {
      filteredBookings = bookings.where((service) {
        final bookingStreet = service.property?.address.street.toLowerCase() ?? '';
        final bookingCity = service.property?.address.city.toLowerCase() ?? '';

        // Check if the search query matches any of the fields
        return bookingStreet.contains(searchQuery.toLowerCase()) ||
            bookingCity.contains(searchQuery.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }




}
