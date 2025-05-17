import 'package:flutter/material.dart';
import 'package:rifqa/Features/admin/presentation/widgets/admin_drawer_widget.dart';
import 'package:rifqa/Features/admin/presentation/widgets/admin_view_body.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: AdminDrawerWidget(),
          body: AdminViewBody(),
        ),
      ),
    );
  }
}
