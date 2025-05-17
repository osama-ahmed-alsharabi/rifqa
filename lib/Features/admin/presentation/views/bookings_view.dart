import 'package:flutter/material.dart';
import 'package:rifqa/Features/admin/presentation/widgets/body_bookings_view_widget.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: BodyBookingsViewWidget(),
      ),
    );
  }
}
