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



  List<BookingInfo> pendingBookinginfos = [];
  List<BookingInfo> bookingInfos = [];
  List<BookingInfo> activebookingInfos = [];
  BookingInfo? activebookingInfo;



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
    // fetchAssignments();
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

  // Future<void> fetchAssignments() async {
  //   setBusy(true);
  //   notifyListeners();
  //   try {
  //     ApiResponse response = await repo.fetchAssignments();
  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //
  //       if (data != null && data['assignments'] != null && data['assignments'] is List) {
  //        
  //         assignments = (data['assignments'] as List)
  //             .map((assignment) => BookingAssignment.fromJson(assignment))
  //             .toList();
  //
  //         // Sort assignments by the first date in descending order
  //         assignments.sort((a, b) {
  //           DateTime dateA = DateTime.parse(a.booking.date.first);
  //           DateTime dateB = DateTime.parse(b.booking.date.first);
  //           return dateB.compareTo(dateA);
  //         });
  //        
  //         pendingBookinginfo = assignments
  //             .where((assignment) => assignment.status == 'Pending')
  //             .toList();
  //
  //         activeAssignments = assignments
  //             .where((assignment) => assignment.status == 'Active')
  //             .toList();
  //        
  //         activeAssignment = activeAssignments.isNotEmpty ? activeAssignments.first : null;
  //
  //
  //       } else {
  //         pendingBookinginfo = [];
  //         assignments = [];
  //         activeAssignment = null;
  //         activeAssignments = [];
  //       }
  //     } else {
  //       throw Exception('Failed to load assignments');
  //     }
  //   } catch (e) {
  //     log.e(e);
  //   } finally {
  //     setBusy(false);
  //     notifyListeners();
  //   }
  // }
  
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
      booking: json['Booking'] != null ? Booking.fromJson(json['Booking']) : Booking(id: '', date: [], time: [], cleaningType: '', property: null, status: '', isTaken: false, country: '', state: '', city: '', address: ''),
    );
  }
}


class Property {
  final String id;
  final String type;
  final String nameOfProperty;
  final String numberOfUnit;
  final String numberOfRoom;
  final String country;
  final String state;
  final String city;
  final String address;
  final String? zipCode;
  final List<String>? images;
  final String? cleanerPreferences;
  

  Property({
    required this.id,
    required this.type,
    required this.nameOfProperty,
    required this.numberOfUnit,
    required this.numberOfRoom,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    this.zipCode,
    this.images,
    this.cleanerPreferences,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      type: json['type'],
      nameOfProperty: json['nameOfProperty'],
      numberOfUnit: json['numberOfUnit'],
      numberOfRoom: json['numberOfRoom'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      address: json['address'],
      zipCode: json['zipCode'],
      images: List<String>.from(json['images'] ?? []),
      cleanerPreferences: json['cleanerPreferences'],
    );
  }
}


class Booking {
  final String id;
  final List<String> date;
  final List<String> time;
  final String cleaningType;
  final bool isTaken;
  final String status;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final Property? property;

  Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.cleaningType,
    required this.property,
    required this.status,
    required this.isTaken,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      date: List<String>.from(json['date']?? []),
      time: List<String>.from(json['time']?? []),
      cleaningType: json['cleaningType'],
      isTaken: json['isTaken'],
      status: json['status'],
      country: json['country'],
      state: json['state'],
      address: json['address'],
      city: json['city'],
      property: json['Property'] != null ? Property.fromJson(json['Property']) : null,
    );
  }
}

class BookingInfo {
  final String type; // HomeOwnerBooking or PropertyManagerBooking
  final Booking booking;

  BookingInfo({
    required this.type,
    required this.booking,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      type: json['type'],
      booking: Booking.fromJson(json['booking']),
    );
  }
}
