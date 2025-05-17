import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/profile/presentation/view/widgets/profile_item_widget.dart';
import 'package:rifqa/Features/profile/presentation/view/widgets/show_email_bottom_sheet.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/services/send_email_hepler.dart';
import 'package:rifqa/cores/services/share_app_helper.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class BodyProfileView extends StatefulWidget {
  final String? phone;
  final String userName;
  const BodyProfileView({
    super.key,
    required this.userName,
    this.phone,
  });

  @override
  State<BodyProfileView> createState() => _BodyProfileViewState();
}

class _BodyProfileViewState extends State<BodyProfileView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.4,
              height: MediaQuery.sizeOf(context).width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    (MediaQuery.sizeOf(context).width * 0.4) / 2),
                color: Colors.white,
              ),
              child: Icon(
                Icons.person,
                size: 100,
                color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.userName,
            style: AppStyles.styleText24,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.phone ?? '',
            style: AppStyles.styleText24,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            width: MediaQuery.sizeOf(context).width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    ShowEmailBottomSheet().showEmailBottomSheet(context);
                  },
                  child: const ProfileItemList(
                    text: "الخصوصية والامان",
                    icon: Icons.privacy_tip,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    SendEmailHepler().contactSupportEmail(
                        emailAddress: "osamaahmed70088@gmail.com");
                  },
                  child: const ProfileItemList(
                    text: "الدعــم والمساعدة",
                    icon: Icons.support_agent,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await ShareAppHelper().shareAppApk();
                  },
                  child: const ProfileItemList(
                    text: "مشاركة تطبيق رفيق",
                    icon: Icons.share,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await SharedPreferencesService.clearUser();
                    await SharedPreferencesService.clearUserId();
                    await SharedPreferencesService.clearUserPhone();
                    Navigator.pushReplacementNamed(
                        context, AppRouter.kLoginRoute);
                  },
                  child: const ProfileItemList(
                    text: "تسجيـل خـروج",
                    icon: Icons.logout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
