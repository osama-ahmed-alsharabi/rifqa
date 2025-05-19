import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/reservation/data/models/reservation_model.dart';
import 'package:rifqa/Features/reservation/presentation/view_model/reservation_cubit/reservation_cubit_cubit.dart';
import 'package:rifqa/Features/reservation/presentation/view_model/reservation_cubit/reservation_cubit_state.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class ReservationsListScreen extends StatefulWidget {
  final bool isAdmin;

  const ReservationsListScreen({super.key, this.isAdmin = false});

  @override
  State<ReservationsListScreen> createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل الحجوزات عند بدء تشغيل الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isAdmin) {
        context.read<ReservationCubit>().getAllReservations();
      } else {
        context.read<ReservationCubit>().getUserReservations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdmin ? 'جميع الحجوزات' : 'حجوزاتي'),
        backgroundColor: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
      ),
      body: BlocConsumer<ReservationCubit, ReservationState>(
        listener: (context, state) {
          if (state is ReservationStatusUpdated) {
            if (widget.isAdmin) {
              context.read<ReservationCubit>().getAllReservations();
            } else {
              context.read<ReservationCubit>().getUserReservations();
            }
          }
        },
        builder: (context, state) {
          if (state is ReservationsLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (state is ReservationsError) {
            return Center(child: Text(state.message));
          } else if (state is ReservationsLoaded) {
            if (state.reservations.isEmpty) {
              return const Center(child: Text('لا توجد حجوزات'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                if (widget.isAdmin) {
                  await context.read<ReservationCubit>().getAllReservations();
                } else {
                  await context.read<ReservationCubit>().getUserReservations();
                }
              },
              child: ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (context, index) {
                  final reservation = state.reservations[index];
                  return ReservationCard(
                    reservation: reservation,
                    isAdmin: widget.isAdmin,
                  );
                },
              ),
            );
          }
          return const Center(child: Text('لا توجد حجوزات'));
        },
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  final bool isAdmin;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      reservation.hotelName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(reservation.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusArabicText(reservation.status),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                reservation.hotelAddress,
                style: TextStyle(
                    color:
                        BlocProvider.of<ThemeAppCubit>(context).kprimayColor),
              ),
              const SizedBox(height: 5),
              if (isAdmin &&
                  reservation.userName != null &&
                  reservation.userPhone != null)
                Column(
                  children: [
                    const Divider(),
                    _buildInfoRow(
                        'اسم العميل:', reservation.userName!, context),
                    _buildInfoRow(
                        'هاتف العميل:', reservation.userPhone!, context),
                    _buildInfoRow('هاتف العميل الثاني:',
                        reservation.userSecondPhone!, context),
                    _buildInfoRow('رقم بطاقة العميل:',
                        reservation.userNationality!, context),
                  ],
                ),
              _buildInfoRow('نوع الحجز:', reservation.reservationType, context),
              _buildInfoRow('عدد الأشخاص:',
                  reservation.numberOfClients.toString(), context),
              _buildInfoRow(
                  'المدة:', '${reservation.durationDays} أيام', context),
              _buildInfoRow('تاريخ الحجز:',
                  _formatDate(reservation.reservationDate), context),
              const SizedBox(height: 8),
              if (isAdmin)
                Row(
                  children: [
                    if (reservation.status != 'confirmed')
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            context
                                .read<ReservationCubit>()
                                .updateReservationStatus(
                                  reservation.id,
                                  'confirmed',
                                );
                          },
                          child: const Text(
                            'تأكيد الحجز',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    if (reservation.status != 'cancelled')
                      const SizedBox(width: 8),
                    if (reservation.status != 'cancelled')
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            context
                                .read<ReservationCubit>()
                                .updateReservationStatus(
                                  reservation.id,
                                  'cancelled',
                                );
                          },
                          child: const Text(
                            'إلغاء الحجز',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              RatingCommentWidget(
                reservation: reservation,
                isAdmin: isAdmin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
                color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusArabicText(String status) {
    switch (status) {
      case 'confirmed':
        return 'تم التأكيد';
      case 'pending':
        return 'قيد الانتظار';
      case 'cancelled':
        return 'ملغية';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class RatingCommentWidget extends StatelessWidget {
  final ReservationModel reservation;
  final bool isAdmin;

  const RatingCommentWidget({
    super.key,
    required this.reservation,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    if (reservation.status != 'confirmed') return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        if (reservation.rating != null) _buildRatingStars(reservation.rating!),
        if (reservation.comment != null && reservation.comment!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'التعليق: ${reservation.comment}',
              style: TextStyle(
                color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              ),
            ),
          ),
        if (!isAdmin && reservation.rating == null)
          TextButton(
            onPressed: () => _showRatingBottomSheet(context, reservation.id),
            child: Text(
              'تقييم الحجز',
              style: TextStyle(
                color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  void _showRatingBottomSheet(BuildContext context, String reservationId) {
    int rating = 0;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'كيف تقيم تجربتك؟',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 40,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: commentController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'تعليقك (اختياري)',
                    labelStyle:
                        AppStyles.styleText12.copyWith(color: Colors.white),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (rating > 0) {
                    context.read<ReservationCubit>().addRatingAndComment(
                          reservationId,
                          rating,
                          commentController.text,
                        );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'إرسال التقييم',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
