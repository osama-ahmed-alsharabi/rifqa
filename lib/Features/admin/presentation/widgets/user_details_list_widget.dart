import 'package:flutter/material.dart';
import 'package:rifqa/Features/admin/presentation/widgets/custom_search_widget.dart';
import 'package:rifqa/Features/admin/presentation/widgets/user_details_widget.dart';

class UserDetailsListWidget extends StatelessWidget {
  const UserDetailsListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            GestureDetector(
              
              child: const CustomSearchWidget()),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return const UserDetailsWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
