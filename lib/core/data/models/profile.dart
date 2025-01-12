import 'dart:convert';

import 'package:limpia/core/data/models/country.dart';
import 'package:limpia/core/data/models/discount.dart';
import 'package:limpia/core/data/models/product.dart';

class Profile {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? phone;
  String? address;
  String? countryAndState;
  String? city;
  Country? country;
  Media? profilePic;
  bool? isUserVerified;
  String? status;
  String? accountType;
  int? accountPoints;
  String? accountPointsLocal;
  String? createdAt;
  String? updatedAt;
  String? lastActivity;
  NotificationPreferences? notificationPreferences;

  List<String>? preferredLocations;
  List<String>? services;
  List<String>? availability;
  List<String>? availabilityTime;
  String? preferredJobType;
  String? role;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.address,
    this.city,
    this.countryAndState,
    this.phone,
    this.country,
    this.profilePic,
    this.isUserVerified,
    this.status,
    this.accountType,
    this.accountPoints,
    this.accountPointsLocal,
    this.createdAt,
    this.updatedAt,
    this.lastActivity,
    this.notificationPreferences,
    this.preferredLocations,
    this.services,
    this.availability,
    this.availabilityTime,
    this.preferredJobType,
    this.role,
  });

  // Updated Profile.fromJson method
  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    username = json['username'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    countryAndState = json['countryAndState'];
    // Country object handling
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    profilePic = json['profile_pic'] != null ? Media.fromJson(json['profile_pic']) : null; // Handle profile_pic
    isUserVerified = json['is_user_verified'];
    status = json['status'];
    accountType = json['account_type'];
    accountPoints = json['account_points'];
    accountPointsLocal = json['account_points_local'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    lastActivity = json['last_activity']; // New field added

    // Notification preferences object handling
    notificationPreferences = json['notification_preferences'] != null
        ? NotificationPreferences.fromJson(json['notification_preferences'])
        : null;

    preferredLocations = json['preferredLocations'] is String
        ? List<String>.from(jsonDecode(json['preferredLocations'] ?? '[]'))
        : List<String>.from(json['preferredLocations'] ?? []);
    services = List<String>.from(json['services']);
    availability = List<String>.from(jsonDecode(json['availability'] ?? '[]'));
    availabilityTime = List<String>.from(json['availabilityTime']);
    preferredJobType = json['preferredJobType'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;

    // Country object serialization
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (profilePic != null) {
      data['profile_pic'] = profilePic!.toJson();
    }

    data['is_user_verified'] = isUserVerified;
    data['status'] = status;
    data['account_type'] = accountType;
    data['account_points'] = accountPoints;
    data['account_points_local'] = accountPointsLocal;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['last_activity'] = lastActivity;

    // Notification preferences serialization
    if (notificationPreferences != null) {
      data['notification_preferences'] = notificationPreferences!.toJson();
    }

    data['address'] = address;
    data['city'] = city;
    data['countryAndState'] = countryAndState;
    data['preferredLocations'] = preferredLocations;
    data['services'] = services;
    data['availability'] = availability;
    data['availabilityTime'] = availabilityTime;
    data['preferredJobType'] = preferredJobType;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
    
    
  }
}

// Model for NotificationPreferences
class NotificationPreferences {
  bool? platformNotifications;
  bool? appNotifications;
  bool? generalNotifications;
  String? id;

  NotificationPreferences({
    this.platformNotifications,
    this.appNotifications,
    this.generalNotifications,
    this.id,
  });

  NotificationPreferences.fromJson(Map<String, dynamic> json) {
    platformNotifications = json['platform_notifications'];
    appNotifications = json['app_notifications'];
    generalNotifications = json['general_notifications'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['platform_notifications'] = platformNotifications;
    data['app_notifications'] = appNotifications;
    data['general_notifications'] = generalNotifications;
    data['_id'] = id;
    return data;
  }
}


class Wallet {
  String? id;
  int? balance;
  String? created;
  String? updated;

  Wallet({this.id, this.balance, this.created, this.updated});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['balance'] = balance;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}

class Shipping {
  String? id;
  String? shippingFirstname;
  String? shippingLastname;
  String? shippingPhone;
  String? shippingAdditionalPhone;
  String? shippingAddress;
  String? shippingAdditionalAddress;
  String? shippingState;
  String? shippingCity;
  int? shippingZipCode;
  bool? isDefault;

  Shipping(
      {this.id,
      this.shippingFirstname,
      this.shippingLastname,
      this.shippingPhone,
      this.shippingAdditionalPhone,
      this.shippingAddress,
      this.shippingAdditionalAddress,
      this.shippingState,
      this.isDefault,
      this.shippingCity,
      this.shippingZipCode});

  Shipping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shippingFirstname = json['shipping_firstname'];
    shippingLastname = json['shipping_lastname'];
    shippingPhone = json['shipping_phone'];
    shippingAdditionalPhone = json['shipping_additional_phone'];
    shippingAddress = json['shipping_address'];
    isDefault = json['default'];
    shippingAdditionalAddress = json['shipping_additional_address'];
    shippingState = json['shipping_state'];
    shippingCity = json['shipping_city'];
    shippingZipCode = json['shipping_zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipping_firstname'] = shippingFirstname;
    data['shipping_lastname'] = shippingLastname;
    data['shipping_phone'] = shippingPhone;
    data['shipping_additional_phone'] = shippingAdditionalPhone;
    data['shipping_address'] = shippingAddress;
    data['default'] = isDefault;
    data['shipping_additional_address'] = shippingAdditionalAddress;
    data['shipping_state'] = shippingState;
    data['shipping_city'] = shippingCity;
    data['shipping_zip_code'] = shippingZipCode;
    return data;
  }
}
