import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';

class BookingItemWidget extends StatefulWidget {
  final bool admin;
  const BookingItemWidget({
    super.key,
    this.admin = false,
  });

  @override
  State<BookingItemWidget> createState() => _BookingItemWidgetState();
}

class _BookingItemWidgetState extends State<BookingItemWidget> {
  showDialogBox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              backgroundColor:
                  BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              icon: const Icon(FontAwesomeIcons.trashCan),
              content: const Text('هل أنت متأكد من حذف القسم؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لا'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('نعم'),
                ),
              ]));

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            "فندق صنعاء القديمة",
                            style: AppStyles.styleText20.copyWith(
                                color: BlocProvider.of<ThemeAppCubit>(context)
                                    .kprimayColor),
                          ),
                          CustomButtonWidget(
                            widget: Text(
                              "تسجيل الدخول",
                              textAlign: TextAlign.center,
                              style: AppStyles.styleText20.copyWith(
                                color: BlocProvider.of<ThemeAppCubit>(context)
                                    .kprimayColor,
                              ),
                            ),
                            color: BlocProvider.of<ThemeAppCubit>(context)
                                .kprimayColor,
                            textColor: Colors.white,
                            horizontalPadding: 3,
                          ),
                          Divider(
                            color: BlocProvider.of<ThemeAppCubit>(context)
                                .kprimayColor,
                            thickness: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          "اسم العميل : محمد أحمد",
                          style: AppStyles.styleText16.copyWith(
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          "رقم العميل : 0123456789",
                          style: AppStyles.styleText16.copyWith(
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.calendarDays,
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              " تاريخ الحجز :  ${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}",
                              style: AppStyles.styleText16.copyWith(
                                  color: BlocProvider.of<ThemeAppCubit>(context)
                                      .kprimayColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
                style:
                    AppStyles.styleText20.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ")
          ],
        ),
      ),
    );
  }
}
