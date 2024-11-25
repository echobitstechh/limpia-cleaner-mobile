import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../core/data/models/booking.dart';
import '../../../core/data/repositories/repository.dart';
import '../../../core/network/api_response.dart';

class BookingsViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("BookingsViewModel");

  List<BookingAssignment> pendingAssignments = [];
  List<BookingAssignment> assignments = [];
  List<BookingAssignment> activeAssignments = [];
  BookingAssignment? activeAssignment;


  String searchQuery = '';
  List<BookingAssignment> filteredAssignments = [];



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
    await fetchAssignments();
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
    fetchAssignments();
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

  Future<void> fetchAssignments() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse response = await repo.fetchAssignments();
      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null && data['assignments'] != null && data['assignments'] is List) {

          assignments = (data['assignments'] as List)
              .map((assignment) => BookingAssignment.fromJson(assignment))
              .toList();

          // Sort assignments by the first date in descending order
          assignments.sort((a, b) {
            DateTime dateA = DateTime.parse(a.booking.date.first);
            DateTime dateB = DateTime.parse(b.booking.date.first);
            return dateB.compareTo(dateA);
          });

          pendingAssignments = assignments
              .where((assignment) => assignment.status == 'Pending')
              .toList();

          activeAssignments = assignments
              .where((assignment) => assignment.status == 'Active')
              .toList();

          activeAssignment = activeAssignments.isNotEmpty ? activeAssignments.first : null;


        } else {
          pendingAssignments = [];
          assignments = [];
          activeAssignment = null;
          activeAssignments = [];
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
      filteredAssignments = assignments;
    } else {
      filteredAssignments = assignments.where((service) {
        return service.booking.property.nameOfProperty.toLowerCase().contains(searchQuery.toLowerCase()) ||
            service.booking.property.city.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }



}
