import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.logger.dart';
import 'package:limpia/core/data/models/cart_item.dart';
import 'package:limpia/core/data/models/product.dart';
import 'package:limpia/core/data/models/raffle_cart_item.dart';
import 'package:limpia/core/data/repositories/repository.dart';
import 'package:limpia/core/network/api_response.dart';
import 'package:limpia/core/utils/local_store_dir.dart';
import 'package:limpia/core/utils/local_stotage.dart';
import 'package:limpia/state.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/app_notification.dart';
import '../../../core/data/models/booking.dart';
import '../../../core/data/models/profile.dart';
import '../../../core/data/models/project.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("DashboardViewModel");



  List<Booking> pendingBookings = [];
  List<Booking> bookings = [];
  List<Booking> activebookings = [];
  Booking? activebooking;



  Future<void> init() async {
    setBusy(true);
    await getNearByBookings();
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
    // fetchAssignments();
    getNearByBookings();
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

 Future<bool> acceptBooking(String bookingId) async {
    setBusy(true);
    try {
      ApiResponse res = await repo.acceptBooking(bookingId);
      if (res.statusCode == 200) {
        notifyListeners();
        return true;
      }
    } catch (e) {
      log.e(e);
    } finally {
      setBusy(false);
    }
    return false;
  }

  void onEnd() {
    print('onEnd');
    //TODO SEND USER NOTIFICATION OF AVAILABILITY OF PRODUCT
    notifyListeners();
  }


  Future<void> getNearByBookings() async {
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
              .map((b) => Booking.fromJson(b))
              .toList();

          // Sort assignments by the first date in descending order
          // bookings.sort((a, b) {
          //   return b.cleaningTime?.compareTo(a.cleaningTime);
          // });

          pendingBookings = bookings
              // .where((assignment) => assignment.booking.isTaken == false)
              // .toList()
          ;

          activebooking = bookings.firstOrNull;
              // .where((b) => b.status == 'Active')
              // .toList();

          print('Active Bookings::: $activebooking');

          // activebookingInfo = bookingInfos.isNotEmpty && bookingInfos.any((info) => info.booking.isTaken)
          //     ? bookingInfos.firstWhere((info) => info.booking.isTaken)
          //     : null;


        } else {
          pendingBookings = [];
          bookings = [];
          activebooking = null;
          activebookings = [];
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

}

class BookingAssignment {
  final String id;
  final String cleanerId;
  final String status;
  final List<String> newDate;
  final List<String> newTime;
  final Booking booking;

  BookingAssignment({
    required this.id,
    required this.cleanerId,
    required this.status,
    required this.newDate,
    required this.newTime,
    required this.booking,
  });

  factory BookingAssignment.fromJson(Map<String, dynamic> json) {
    return BookingAssignment(
      id: json['id'] ?? '',
      cleanerId: json['cleanerId'] ?? '',
      status: json['status'] ?? '',
      newDate: json['newDate'] != null ? List<String>.from(json['newDate']) : [],
      newTime: json['newTime'] != null ? List<String>.from(json['newTime']) : [],
      booking: json['Booking'] != null ? Booking.fromJson(json['Booking']) : Booking(id: '', cleaningType: '', property: null, status: '', isTaken: false, cleaningTime: null, numberOfRooms: 0, numberOfBathrooms: 0, distance: 0),
    );
  }
}



class Booking {
  final String id;
  final DateTime? cleaningTime;
  final String cleaningType;
  final bool isTaken;
  final String? status;
  final int numberOfRooms;
  final int numberOfBathrooms;
  final Property? property;
  final ChecklistDetails? checklistDetails;
  final int distance;

  Booking({
    required this.id,
    required this.cleaningTime,
    required this.cleaningType,
    required this.isTaken,
    this.status,
    required this.numberOfRooms,
    required this.numberOfBathrooms,
    this.property,
    this.checklistDetails,
    required this.distance,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      cleaningTime: DateTime.parse(json['cleaningTime']),
      cleaningType: json['cleaningType'],
      isTaken: json['isTaken'] ?? false,
      status: json['status'],
      numberOfRooms: int.parse(json['numberOfRooms']),
      numberOfBathrooms: int.parse(json['numberOfBathrooms']),
      property: json['property'] != null ? Property.fromJson(json['property']) : null,
      checklistDetails: json['checklistDetails'] != null
          ? ChecklistDetails.fromJson(json['checklistDetails'])
          : null,
      distance: json['distance'],
    );
  }
}

class Property {
  final String id;
  final Address address;

  Property({
    required this.id,
    required this.address,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      address: Address.fromJson(json['address']),
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }
}

class ChecklistDetails {
  final List<Task> kitchenTasks;
  final List<Task> bathroomTasks;
  final List<Task> generalAreasTasks;

  ChecklistDetails({
    required this.kitchenTasks,
    required this.bathroomTasks,
    required this.generalAreasTasks,
  });

  factory ChecklistDetails.fromJson(Map<String, dynamic> json) {
    return ChecklistDetails(
      kitchenTasks: (json['kitchenTasks'] as List)
          .map((task) => Task.fromJson(task))
          .toList(),
      bathroomTasks: (json['bathroomTasks'] as List)
          .map((task) => Task.fromJson(task))
          .toList(),
      generalAreasTasks: (json['generalAreasTasks'] as List)
          .map((task) => Task.fromJson(task))
          .toList(),
    );
  }
}

class Task {
  final String taskName;
  final bool completed;

  Task({
    required this.taskName,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskName: json['taskName'],
      completed: json['completed'],
    );
  }
}

