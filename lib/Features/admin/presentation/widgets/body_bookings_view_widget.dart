import 'package:flutter/material.dart';
import 'package:rifqa/Features/admin/presentation/widgets/booking_list_view_widget.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/custom_app_bar_widget.dart';

class BodyBookingsViewWidget extends StatelessWidget {
  const BodyBookingsViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomAppBarWidget(
          title: "الحجوزات",
        ),
        BookingListViewWidget()
      ],
    );
  }
}
