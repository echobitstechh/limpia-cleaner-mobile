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
  RoleDetails? roleDetails;
  String? role;
  List<String>? services;
  List<String>? availability;
  List<String>? availabilityTime;

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
    this.roleDetails,
    this.role,
    this.services,
    this.availability,
    this.availabilityTime,
  });

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
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    profilePic = json['profile_pic'] != null ? Media.fromJson(json['profile_pic']) : null;
    isUserVerified = json['is_user_verified'];
    status = json['status'];
    accountType = json['account_type'];
    accountPoints = json['account_points'];
    accountPointsLocal = json['account_points_local'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    lastActivity = json['last_activity'];
    notificationPreferences = json['notification_preferences'] != null
        ? NotificationPreferences.fromJson(json['notification_preferences'])
        : null;
    roleDetails = json['roleDetails'] != null ? RoleDetails.fromJson(json['roleDetails']) : null;
    role = json['role'];
    // services = List<String>.from(json['services']);
    // availability = List<String>.from(json['availability']);
    // availabilityTime = List<String>.from(json['availabilityTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;
    data['address'] = address;
    data['city'] = city;
    data['countryAndState'] = countryAndState;
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
    if (notificationPreferences != null) {
      data['notification_preferences'] = notificationPreferences!.toJson();
    }
    if (roleDetails != null) {
      data['roleDetails'] = roleDetails!.toJson();
    }
    data['role'] = role;
    data['services'] = services;
    data['availability'] = availability;
    data['availabilityTime'] = availabilityTime;
    return data;
  }
}

class RoleDetails {
  String? id;
  String? userId;
  List<String>? preferredLocations;
  List<String>? services;
  List<String>? availability;
  List<String>? availabilityTime;
  String? preferredJobType;
  String? createdAt;
  String? updatedAt;

  RoleDetails({
    this.id,
    this.userId,
    this.preferredLocations,
    this.services,
    this.availability,
    this.availabilityTime,
    this.preferredJobType,
    this.createdAt,
    this.updatedAt,
  });

  RoleDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    preferredLocations = List<String>.from(json['preferredLocations']);
    services = List<String>.from(json['services']);
    availability = List<String>.from(json['availability']);
    availabilityTime = List<String>.from(json['availabilityTime']);
    preferredJobType = json['preferredJobType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['preferredLocations'] = preferredLocations;
    data['services'] = services;
    data['availability'] = availability;
    data['availabilityTime'] = availabilityTime;
    data['preferredJobType'] = preferredJobType;
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
