// class Property {
//   final String id;
//   final String type;
//   final String nameOfProperty;
//   final String numberOfUnit;
//   final String numberOfRoom;
//   final String country;
//   final String state;
//   final String city;
//   final String address;
//
//   Property({
//     required this.id,
//     required this.type,
//     required this.nameOfProperty,
//     required this.numberOfUnit,
//     required this.numberOfRoom,
//     required this.country,
//     required this.state,
//     required this.city,
//     required this.address,
//   });
//
//   factory Property.fromJson(Map<String, dynamic> json) {
//     return Property(
//       id: json['id'],
//       type: json['type'],
//       nameOfProperty: json['nameOfProperty'],
//       numberOfUnit: json['numberOfUnit'],
//       numberOfRoom: json['numberOfRoom'],
//       country: json['country'],
//       state: json['state'],
//       city: json['city'],
//       address: json['address'],
//     );
//   }
// }
//
// class Booking {
//   final String id;
//   final List<String> date;
//   final List<String> time;
//   final String cleaningType;
//   final String status;
//   final Property property;
//
//   Booking({
//     required this.id,
//     required this.date,
//     required this.time,
//     required this.cleaningType,
//     required this.property,
//     required this.status
//   });
//
//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       id: json['id'],
//       date: List<String>.from(json['date']),
//       time: List<String>.from(json['time']),
//       cleaningType: json['cleaningType'],
//       status: json['status'],
//       property: Property.fromJson(json['Property']),
//     );
//   }
// }
//
// class BookingAssignment {
//   final String id;
//   final String cleanerId;
//   final String status;
//   final List<String> newDate;
//   final List<String> newTime;
//   final Booking booking;
//
//   BookingAssignment({
//     required this.id,
//     required this.cleanerId,
//     required this.status,
//     required this.newDate,
//     required this.newTime,
//     required this.booking,
//   });
//
//   factory BookingAssignment.fromJson(Map<String, dynamic> json) {
//     return BookingAssignment(
//       id: json['id'] ?? '',
//       cleanerId: json['cleanerId'] ?? '',
//       status: json['status'] ?? '',
//       newDate: json['newDate'] != null ? List<String>.from(json['newDate']) : [],
//       newTime: json['newTime'] != null ? List<String>.from(json['newTime']) : [],
//       booking: json['Booking'] != null ? Booking.fromJson(json['Booking']) : Booking(id: '', cleaningType: '', property: Property(id: '', nameOfProperty: '', country: '', city: '', address: '', type: '', numberOfUnit: '', numberOfRoom: '', state: ''), date: [], time: [], status: ''),
//     );
//   }
// }
