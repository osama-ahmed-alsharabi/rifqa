import 'package:flutter/material.dart';
import 'package:rifqa/Features/google_map/data/models/hotel.dart';

class HotelListItem extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onTap;
  final bool isSelected;

  const HotelListItem({
    super.key,
    required this.hotel,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: isSelected ? Colors.blue[50] : Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            onTap: onTap,
            title: Text(
              hotel.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              hotel.address,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            trailing: Icon(
              isSelected ? Icons.star : Icons.chevron_right,
              color: isSelected ? Colors.amber : null,
            ),
          ),
        ),
      ),
    );
  }
}
