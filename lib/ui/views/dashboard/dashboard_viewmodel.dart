import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.logger.dart';
import 'package:limpia/core/data/repositories/repository.dart';
import 'package:limpia/core/network/api_response.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("DashboardViewModel");

  List<Booking> pendingBookings = [];
  List<Booking> bookings = [];
  List<Booking> activeBookings = [];
  Booking? activeBooking;

  Future<void> init() async {
    setBusy(true);
    await getNearByBookings();
    await getCleanerBookings();
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

  void getResourceList() {
    // fetchAssignments();
    getNearByBookings();
    getCleanerBookings();
  }

  Future<bool> updateBooking(String cleanerAssignmentId, String action) async {
    setBusy(true);
    try {
      ApiResponse res = await repo.updateBooking(cleanerAssignmentId, action);
      if (res.statusCode == 200) {
        DashboardViewModel().refreshData();
        locator<SnackbarService>()
            .showSnackbar(message: 'Booking Status Updated Successfully!');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    } finally {
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

        if (data != null &&
            data['bookings'] != null &&
            data['bookings'] is List) {
          print("bookings::: ${data['bookings']}");

          bookings = (data['bookings'] as List)
              .map((assignment) => Booking.fromJson(assignment))
              .toList();

          // Sort assignments by the first date in descending order
          bookings.sort((a, b) {
            return b.cleaningTime?.compareTo(a.cleaningTime ?? DateTime(0)) ??
                0;
          });

          pendingBookings =
              bookings.where((x) => x.bookingStatus == 'PENDING').toList();


        } else {
          pendingBookings = [];
          bookings = [];
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

  Future<void> getCleanerBookings() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse response = await repo.getCleanerBookings();
      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null &&
            data['bookings'] != null &&
            data['bookings'] is List) {
          activeBookings = (data['bookings'] as List)
              .map((x) => Booking.fromJson(x))
              .toList();

          // Sort assignments by the first date in descending order
          activeBookings.sort((a, b) {
            return b.cleaningTime?.compareTo(a.cleaningTime ?? DateTime(0)) ??
                0;
          });

          //TODO: Update this to be only current booking in progress
          activeBookings.sort((a, b) =>
              a.cleaningTime?.compareTo(b.cleaningTime ?? DateTime(0)) ?? 0);
          activeBooking =
              activeBookings.isNotEmpty ? activeBookings.first : null;
        } else {
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
      newDate:
          json['newDate'] != null ? List<String>.from(json['newDate']) : [],
      newTime:
          json['newTime'] != null ? List<String>.from(json['newTime']) : [],
      booking: json['Booking'] != null
          ? Booking.fromJson(json['Booking'])
          : Booking(
              id: '',
              cleaningType: '',
              property: null,
              status: '',
              isTaken: false,
              cleaningTime: null,
              numberOfRooms: 0,
              numberOfBathrooms: 0,
              distance: 0),
    );
  }
}

class Booking {
  final String id;
  final DateTime? cleaningTime;
  final String cleaningType;
  final bool isTaken;
  final String? status;
  final String? bookingStatus;
  final int numberOfRooms;
  final int numberOfBathrooms;
  final Property? property;
  final ChecklistDetails? checklistDetails;
  final List<Cleaner>? cleaners;
  final int distance;

  Booking({
    required this.id,
    required this.cleaningTime,
    required this.cleaningType,
    required this.isTaken,
    this.status,
    this.bookingStatus,
    required this.numberOfRooms,
    required this.numberOfBathrooms,
    this.property,
    this.checklistDetails,
    required this.distance,
    this.cleaners,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      cleaningTime: DateTime.parse(json['cleaningTime']),
      cleaningType: json['cleaningType'],
      isTaken: json['isTaken'] ?? false,
      status: json['status'],
      bookingStatus: json['bookingStatus'],
      numberOfRooms: int.parse(json['numberOfRooms'] ?? 0),
      numberOfBathrooms: int.parse(json['numberOfBathrooms'] ?? 0),
      property:
          json['property'] != null ? Property.fromJson(json['property']) : null,
      checklistDetails: json['checklistDetails'] != null
          ? ChecklistDetails.fromJson(json['checklistDetails'])
          : null,
      distance: json['distance'] ?? 0,
      cleaners: json['Cleaners'] != null
          ? (json['Cleaners'] as List)
              .map((cleaner) => Cleaner.fromJson(cleaner))
              .toList()
          : null,
    );
  }
}

class Cleaner {
  final String id;
  final String userId;
  final List<String> preferredLocations;
  final List<String> services;
  final List<String> availability;
  final List<String> availabilityTime;
  final String preferredJobType;
  final String createdAt;
  final String updatedAt;

  Cleaner({
    required this.id,
    required this.userId,
    required this.preferredLocations,
    required this.services,
    required this.availability,
    required this.availabilityTime,
    required this.preferredJobType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cleaner.fromJson(Map<String, dynamic> json) {
    return Cleaner(
      id: json['id'],
      userId: json['userId'],
      preferredLocations: List<String>.from(json['preferredLocations']),
      services: List<String>.from(json['services']),
      availability: List<String>.from(json['availability']),
      availabilityTime: List<String>.from(json['availabilityTime']),
      preferredJobType: json['preferredJobType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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
