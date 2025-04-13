import 'package:intl/intl.dart';

enum BookingStatus {
  upcoming,
  completed,
  cancelled
}

class Booking {
  final String id;
  final DateTime date;
  final String timeSlot;
  final String courtType;
  final double price;
  final BookingStatus status;
  final String venueName;

  Booking({
    required this.id,
    required this.date,
    required this.timeSlot,
    required this.courtType,
    required this.price,
    required this.status,
    required this.venueName,
  });

  String get formattedDate => DateFormat('EEE, MMM d, y').format(date);

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'],
      courtType: json['courtType'],
      price: json['price'].toDouble(),
      status: BookingStatus.values.byName(json['status']),
      venueName: json['venueName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'courtType': courtType,
      'price': price,
      'status': status.name,
      'venueName': venueName,
    };
  }
} 