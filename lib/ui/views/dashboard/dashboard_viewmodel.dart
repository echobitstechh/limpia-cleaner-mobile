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
import 'package:video_player/video_player.dart';

import '../../../core/data/models/app_notification.dart';
import '../../../core/data/models/booking.dart';
import '../../../core/data/models/profile.dart';
import '../../../core/data/models/project.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final bool _isDataLoaded = false;
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Raffle> raffleList = [];
  List<Project> projects = [];
  List<Ads> adsList = [];
  List<ProjectResource> projectResources = [];
  List<Raffle> featuredRaffle = [];

  bool? onboarded;

  bool showDialog = true;  // Controls when to show the modal
  bool modalShown = false; // Flag to track if the modal was shown
  bool appBarLoading = false;
  bool shouldShowShowcase = true;  // Controls when to show showcase

  List<BookingAssignment> pendingAssignments = [];
  List<BookingAssignment> assignments = [];
  List<BookingAssignment> activeAssignments = [];
  BookingAssignment? activeAssignment;

  @override
  void initialise() {
    init();
  }

  bool showcaseShown = false; // Track whether the showcase has been shown
  void setShowcaseShown(bool value) {
    showcaseShown = value;
    notifyListeners();
  }

  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }


  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }


  Future<void> init() async {
    setBusy(true);
    // onboarded = await locator<LocalStorage>().fetch(LocalStorageDir.onboarded) ?? false;
    // if (!onboarded!) {
    //   showDialog = true; // Show modal if not onboarded
    // }
    // notifyListeners();
    // await loadRaffles();
    // await loadAds();
    // // await loadProducts();
    //  await loadProjects();
    if (userLoggedIn.value == true) {
      // initCart();
      // await getNotifications();
      await fetchAssignments();
    }
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
  



  Future<void> getNotifications() async {
    try {
      ApiResponse res = await repo.getNotifications();
      if (res.statusCode == 200) {
        notifications.value = (res.data['data']['items'] as List)
            .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        unreadCount.value = notifications.value.where((n) => n.unread).length;
        notifyListeners();
      }
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await repo.markNotificationAsRead();
      notifications.value.forEach((n) => n.unread = false);
      unreadCount.value--;
      notifyListeners();
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> getProfile() async {
    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data['data']));
        await locator<LocalStorage>().save(LocalStorageDir.profileView, res.data["data"]);
        notifyListeners();
        print(profile.value.accountPoints);
      }
    } catch (e) {
      throw Exception(e);
    }
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




  void addToRaffleCart(Raffle raffle) async {
    setBusy(true);
    notifyListeners();
    try {
      final existingItem = raffleCart.value.firstWhere(
            (raffleItem) => raffleItem.raffle?.id == raffle.id,
        orElse: () => RaffleCartItem(raffle: raffle, quantity: 0),
      );

      if (existingItem.quantity != null && existingItem.quantity! > 0 && existingItem.raffle != null) {
        existingItem.quantity = (existingItem.quantity! + 1);
      } else {
        existingItem.quantity = 1;
        raffleCart.value.add(existingItem);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);

      // Save to online cart using API
      final response = await repo.addToCart({
        "raffle": raffle.id,
        "quantity": existingItem.quantity,
      });

      if (response.statusCode == 201) {
        locator<SnackbarService>().showSnackbar(message: "Raffle added to cart", duration: Duration(seconds: 2));
      } else {
        locator<SnackbarService>().showSnackbar(message: response.data["message"], duration: Duration(seconds: 2));
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to add raffle to cart: $e", duration: Duration(seconds: 2));
      log.e(e);
    } finally {
      setBusy(false);
      raffleCart.notifyListeners();
    }
  }
  
  void initCart() async {
    dynamic raffle = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    dynamic store = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    List<RaffleCartItem> localRaffleCart = List<Map<String, dynamic>>.from(raffle)
        .map((e) => RaffleCartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    raffleCart.value = localRaffleCart;
    raffleCart.notifyListeners();
  }
  
  Future<void> decreaseRaffleQuantity(RaffleCartItem item) async {
    setBusy(true);
    try {
      if (item.quantity! > 1) {
        item.quantity = item.quantity! - 1;

        // Update online cart
        await repo.addToCart({
          "raffle": item.raffle?.id,
          "quantity": item.quantity,
        });
      } else if (item.quantity! == 1) {
        // Remove from local cart
        raffleCart.value.removeWhere((cartItem) => cartItem.raffle?.id == item.raffle?.id);

        // Remove from online cart
        await repo.deleteFromCart(item.raffle!.id!);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to decrease raffle quantity: $e", duration: Duration(seconds: 2));
      log.e(e);
    } finally {
      setBusy(false);
      raffleCart.notifyListeners();
    }
  }
  
  Future<void> increaseRaffleQuantity(RaffleCartItem item) async {
    setBusy(true);
    try {
      item.quantity = item.quantity! + 1;
      int index = raffleCart.value.indexWhere((raffleItem) => raffleItem.raffle?.id == item.raffle?.id);
      if (index != -1) {
        raffleCart.value[index] = item;
        raffleCart.value = List.from(raffleCart.value);

        // Update online cart
        await repo.addToCart({
          "raffle": item.raffle?.id,
          "quantity": item.quantity,
        });

        // Save to local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to increase raffle quantity: $e", duration: Duration(seconds: 2));
      log.e(e);
    } finally {
      setBusy(false);
      raffleCart.notifyListeners();
    }
  }




  String formatRemainingTime(DateTime drawDate) {
    final now = DateTime.now();
    final difference = drawDate.difference(now);
    // Format the Duration to your needs
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
      booking: json['Booking'] != null ? Booking.fromJson(json['Booking']) : Booking(id: '', cleaningType: '', property: Property(id: '', nameOfProperty: '', country: '', city: '', address: '', type: '', numberOfUnit: '', numberOfRoom: '', state: ''), date: [], time: []),
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
    );
  }
}

class Booking {
  final String id;
  final List<String> date;
  final List<String> time;
  final String cleaningType;
  final Property property;

  Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.cleaningType,
    required this.property,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      date: List<String>.from(json['date']),
      time: List<String>.from(json['time']),
      cleaningType: json['cleaningType'],
      property: Property.fromJson(json['Property']),
    );
  }
}