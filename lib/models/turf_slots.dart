import 'package:pitch_planner/models/time_slot.dart';

class FiveASideSlot extends TimeSlot {
  FiveASideSlot({
    required String time,
    required double price,
    bool isAvailable = true,
  }) : super(
          time: time,
          price: price,
          isAvailable: isAvailable,
          courtType: '5-a-side',
        );
}

class SevenASideSlot extends TimeSlot {
  SevenASideSlot({
    required String time,
    required double price,
    bool isAvailable = true,
  }) : super(
          time: time,
          price: price,
          isAvailable: isAvailable,
          courtType: '7-a-side',
        );
} 