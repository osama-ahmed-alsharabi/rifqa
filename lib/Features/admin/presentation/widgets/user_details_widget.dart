import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/data/model/user_model.dart';
import 'package:rifqa/Features/admin/presentation/view_model/user_management/user_management_cubit.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';

class UserDetailsWidget extends StatelessWidget {
  final UserModel? user;

  const UserDetailsWidget({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("اسم المستخدم: ${user!.name}",
                      style: AppStyles.styleText16.copyWith(
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor)),
                  const SizedBox(height: 10),
                  Text(" الهاتف: ${user!.phone}",
                      style: AppStyles.styleText16.copyWith(
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor)),
                  const SizedBox(height: 10),
                  Text("العمر: ${user!.age}",
                      style: AppStyles.styleText16.copyWith(
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor)),
                  const SizedBox(height: 10),
                  Text("رقم البطاقة: ${user!.cardInfo}",
                      style: AppStyles.styleText16.copyWith(
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            CustomButtonWidget(
              color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              textColor: Colors.white,
              widget: Text(
                user!.isActive ? 'ايقاف' : 'تفعيل',
                textAlign: TextAlign.center,
                style: AppStyles.styleText20.copyWith(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                context.read<UserManagementCubit>().toggleUserStatus(
                      user!.id,
                      !user!.isActive,
                    );
              },
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
