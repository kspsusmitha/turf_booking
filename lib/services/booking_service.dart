import 'package:firebase_database/firebase_database.dart';
import 'package:pitch_planner/services/user_preferences.dart';

class BookingService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<Map<String, dynamic>> createBooking({
    required String timeSlot,
    required String courtType,
    required DateTime bookingDate,
    required double amount,
    required String paymentId,
    required String venueName,
    required String venueId,
  }) async {
    try {
      // Get current user data
      final userData = await UserPreferences.getUser();
      if (userData == null) {
        return {
          'success': false,
          'message': 'User not found'
        };
      }

      // Reference to user's bookings
      final userBookingsRef = _database.child('users/${userData['id']}/bookings');
      
      // Create new booking under user's node
      final newBookingRef = userBookingsRef.push();
      await newBookingRef.set({
        'timeSlot': timeSlot,
        'courtType': courtType,
        'bookingDate': bookingDate.toIso8601String(),
        'amount': amount,
        'paymentId': paymentId,
        'status': 'confirmed',
        'createdAt': ServerValue.timestamp,
        'venueName': venueName,
        'venueId': venueId,
      });

      return {
        'success': true,
        'message': 'Booking confirmed successfully',
        'bookingId': newBookingRef.key
      };
    } catch (e) {
      print('Error creating booking: $e');
      return {
        'success': false,
        'message': 'Failed to create booking'
      };
    }
  }

  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    try {
      final userData = await UserPreferences.getUser();
      if (userData == null) {
        return {
          'success': false,
          'message': 'User not found'
        };
      }

      // Update status in user's bookings
      final bookingRef = _database.child('users/${userData['id']}/bookings/$bookingId');
      await bookingRef.update({
        'status': 'cancelled',
        'cancelledAt': ServerValue.timestamp,
      });

      return {
        'success': true,
        'message': 'Booking cancelled successfully'
      };
    } catch (e) {
      print('Error cancelling booking: $e');
      return {
        'success': false,
        'message': 'Failed to cancel booking'
      };
    }
  }

  Future<List<Map<String, dynamic>>> getUserBookings() async {
    try {
      final userData = await UserPreferences.getUser();
      if (userData == null) {
        return [];
      }

      final userBookingsRef = _database.child('users/${userData['id']}/bookings');
      final bookingsSnapshot = await userBookingsRef.get();

      if (!bookingsSnapshot.exists) {
        return [];
      }

      List<Map<String, dynamic>> bookings = [];
      final bookingsMap = bookingsSnapshot.value as Map<dynamic, dynamic>;
      
      bookingsMap.forEach((key, value) {
        bookings.add({
          'id': key,
          'timeSlot': value['timeSlot'],
          'courtType': value['courtType'],
          'bookingDate': DateTime.parse(value['bookingDate']),
          'amount': value['amount'].toDouble(),
          'status': value['status'],
          'createdAt': value['createdAt'],
          'venueName': value['venueName'],
          'venueId': value['venueId'],
        });
      });

      // Sort bookings by date
      bookings.sort((a, b) => b['bookingDate'].compareTo(a['bookingDate']));
      return bookings;
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }
} 