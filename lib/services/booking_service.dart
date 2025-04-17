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
      final userId = await UserPreferences.getUserId();
      if (userId == null) {
        return {
          'success': false,
          'message': 'User not found'
        };
      }

      // Create booking under user's bookings node
      final bookingRef = _database
          .child('users')
          .child(userId)
          .child('bookings')
          .push();

      final bookingData = {
        'timeSlot': timeSlot,
        'courtType': courtType,
        'bookingDate': bookingDate.toIso8601String(),
        'amount': amount,
        'paymentId': paymentId,
        'status': 'confirmed',
        'createdAt': ServerValue.timestamp,
        'venueName': venueName,
        'venueId': venueId,
      };

      await bookingRef.set(bookingData);

      return {
        'success': true,
        'message': 'Booking confirmed successfully',
        'bookingId': bookingRef.key
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create booking: $e'
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
      final userId = await UserPreferences.getUserId();
      if (userId == null) return [];

      final snapshot = await _database
          .child('users')
          .child(userId)
          .child('bookings')
          .get();

      if (!snapshot.exists) return [];

      final bookingsMap = Map<String, dynamic>.from(snapshot.value as Map);
      
      return bookingsMap.entries.map((entry) {
        final booking = Map<String, dynamic>.from(entry.value as Map);
        return {
          'id': entry.key,
          'timeSlot': booking['timeSlot'],
          'courtType': booking['courtType'],
          'bookingDate': DateTime.parse(booking['bookingDate']),
          'amount': booking['amount'],
          'status': booking['status'],
          'createdAt': booking['createdAt'],
          'venueName': booking['venueName'],
          'venueId': booking['venueId'],
        };
      }).toList()
        ..sort((a, b) => (b['bookingDate'] as DateTime)
            .compareTo(a['bookingDate'] as DateTime));
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, int>> getUserBookingStats(String userId) async {
    // TODO: Implement API call to fetch booking statistics
    // This is where you'll make the actual API call to your backend
    throw UnimplementedError();
  }
} 