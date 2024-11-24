import 'package:intl/intl.dart';


String formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return '';
  }
  try {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('MMM, dd').format(dateTime);
  } catch (e) {
    // Handle parsing error
    print('Error parsing date: $e');
    return '';
  }
}

String formatTime(String? timeString) {
  if (timeString == null || timeString.isEmpty) {
    return '';
  }
  try {
    DateTime dateTime = DateTime.parse(timeString);
    return DateFormat('hh:mm a').format(dateTime);
  } catch (e) {
    // Handle parsing error
    print('Error parsing time: $e');
    return '';
  }
}
