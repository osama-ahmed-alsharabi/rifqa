import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/profile/presentation/view/widgets/body_profile_view.dart';
import 'package:rifqa/Features/profile/presentation/view_model/profile_cubit/profile_cubit.dart';

class ProfileView extends StatefulWidget {
  final String userName;
  const ProfileView({super.key, required this.userName});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? phone;
  @override
  void initState() {
    getPhone();
    super.initState();
  }

  getPhone() async {
    phone = await BlocProvider.of<ProfileCubit>(context).getUserPhone();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BodyProfileView(
          userName: widget.userName,
          phone: phone,
        ),
      ),
    );
  }
}
