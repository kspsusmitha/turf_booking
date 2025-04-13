class TimeSlot {
  final String time;
  final double price;
  final bool isAvailable;
  final String courtType; // e.g., '5-a-side', '7-a-side'

  TimeSlot({
    required this.time,
    required this.price,
    this.isAvailable = true,
    required this.courtType,
  });
} 