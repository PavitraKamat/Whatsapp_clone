import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String getRelativeDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate(); // <-- Convert first
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDay == today) {
    return 'today';
  } else if (messageDay == yesterday) {
    return 'yesterday';
  } else {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}

String formatLastSeen(Timestamp lastSeenTimestamp) {
  DateTime dateTime = lastSeenTimestamp.toDate(); // <-- Convert
  final relativeDate = getRelativeDate(lastSeenTimestamp);

  if (relativeDate == 'today') {
    return "Last seen today at ${DateFormat('hh:mm a').format(dateTime)}";
  } else if (relativeDate == 'yesterday') {
    return "Last seen yesterday at ${DateFormat('hh:mm a').format(dateTime)}";
  } else {
    return "Last seen on $relativeDate";
  }
}

String formatMessageTimestamp(Timestamp messageTimestamp) {
  DateTime dateTime = messageTimestamp.toDate(); // <-- Convert
  final relativeDate = getRelativeDate(messageTimestamp);

  if (relativeDate == 'today') {
    return DateFormat('hh:mm a').format(dateTime);
  } else {
    return relativeDate == 'yesterday' ? 'Yesterday' : relativeDate;
  }
}
