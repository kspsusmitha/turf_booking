import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pitch_planner/services/booking_service.dart';
import 'package:pitch_planner/screens/booking/booking_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String timeSlot;
  final String courtType;
  final DateTime bookingDate;
  final String venueName;
  final String venueId;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.timeSlot,
    required this.courtType,
    required this.bookingDate,
    required this.venueName,
    required this.venueId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _bookingService = BookingService();
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Generate a random payment ID (in real app, this would come from payment gateway)
      final paymentId = 'PAY_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';

      // Create booking in database
      final result = await _bookingService.createBooking(
        timeSlot: widget.timeSlot,
        courtType: widget.courtType,
        bookingDate: widget.bookingDate,
        amount: widget.amount,
        paymentId: paymentId,
        venueName: widget.venueName,
        venueId: widget.venueId,
      );

      if (mounted) {
        if (result['success']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingSuccessScreen(
                amount: widget.amount,
                timeSlot: widget.timeSlot,
                courtType: widget.courtType,
                bookingDate: widget.bookingDate,
                venueName: widget.venueName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBookingDetails(),
            const SizedBox(height: 24),
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const Divider(),
            _buildDetailRow('Venue', widget.venueName),
            _buildDetailRow('Date', widget.bookingDate.toString().split(' ')[0]),
            _buildDetailRow('Time', widget.timeSlot),
            _buildDetailRow('Court Type', widget.courtType),
            const Divider(),
            _buildDetailRow(
              'Amount to Pay',
              '₹${widget.amount.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green.shade700 : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      onPressed: _isProcessing ? null : _processPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: _isProcessing
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Pay Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
} 