import 'package:flutter/material.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/booking_item_widget.dart';

class BookingListViewWidget extends StatelessWidget {
  const BookingListViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return const BookingItemWidget();
      },
    ));
  }
}
