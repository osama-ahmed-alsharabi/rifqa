import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/view_model/user_management/user_management_cubit.dart';
import 'package:rifqa/Features/admin/presentation/widgets/custom_search_widget.dart';
import 'package:rifqa/Features/admin/presentation/widgets/user_details_widget.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/custom_app_bar_widget.dart';

class UserDetailsListWidget extends StatefulWidget {
  const UserDetailsListWidget({
    super.key,
  });

  @override
  State<UserDetailsListWidget> createState() => _UserDetailsListWidgetState();
}

class _UserDetailsListWidgetState extends State<UserDetailsListWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserManagementCubit>().fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const CustomAppBarWidget(),
          CustomSearchWidget(
            controller: _searchController,
            onChanged: (query) {
              if (query.isEmpty) {
                context.read<UserManagementCubit>().fetchUsers();
              } else {
                context.read<UserManagementCubit>().searchUsers(query);
              }
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<UserManagementCubit, UserManagementState>(
              builder: (context, state) {
                if (state is UserManagementLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                } else if (state is UserManagementError) {
                  return Center(child: Text(state.error));
                } else if (state is UserManagementLoaded) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return UserDetailsWidget(user: state.users[index]);
                    },
                  );
                }
                return const Center(child: Text('لايوجد مستخدمين'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
