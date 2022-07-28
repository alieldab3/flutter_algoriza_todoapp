import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekdayItem extends StatelessWidget {
  final bool isSelected;
  final DateTime date;
  const WeekdayItem({Key? key, this.isSelected = false, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 55,
      child: Card(
        color: isSelected ? Colors.green : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('E').format(date),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                date.day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
