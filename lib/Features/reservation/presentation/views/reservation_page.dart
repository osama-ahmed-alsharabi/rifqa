import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rifqa/Features/google_map/data/models/hotel.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/custom_app_bar_widget.dart';
import 'package:rifqa/Features/reservation/presentation/view_model/reservation_cubit/reservation_cubit_cubit.dart';
import 'package:rifqa/Features/reservation/presentation/view_model/reservation_cubit/reservation_cubit_state.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';

class ReservationScreen extends StatefulWidget {
  final Hotel hotel;
  final bool isAdmin;

  const ReservationScreen({
    super.key,
    required this.hotel,
    this.isAdmin = false,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? _selectedReservationType;
  int _numberOfClients = 1;
  int _durationDays = 1;

  // Map of reservation types with their base prices
  final Map<String, double> _reservationTypes = {
    'غرفة فردية': 100.0,
    'غرفة مزدوجة': 150.0,
    'جناح': 250.0,
    'جناح فاخر': 400.0,
    'شقة فندقية': 300.0,
  };

  // Current price calculations
  double get _pricePerNight => _selectedReservationType != null
      ? _reservationTypes[_selectedReservationType]!
      : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ReservationCubit, ReservationState>(
          listener: (context, state) {
            if (state is ReservationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تأكيد الحجز بنجاح')),
              );
              Navigator.pop(context);
            } else if (state is ReservationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SvgPicture.asset(
                        "assets/images/reservation_backgraound.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    CustomAppBarWidget(
                      title: "الحجز",
                      color:
                          BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.hotel.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.hotel.address,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Reservation type selector
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedReservationType,
                              hint: const Text(
                                'اختر نوع الحجز',
                                style: TextStyle(color: Colors.white),
                              ),
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: _reservationTypes.keys.map((String value) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.center,
                                  value: value,
                                  child: Column(
                                    children: [
                                      Text(value),
                                      const Divider(),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedReservationType = newValue;
                                });
                              },
                            ),
                          ),

                          // Price display - Outside the dropdown menu
                          if (_selectedReservationType != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'السعر: $_pricePerNight ر.س لكل ليلة',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),

                          // Number of clients selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'عدد الأشخاص:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_numberOfClients > 1) {
                                          _numberOfClients--;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    '$_numberOfClients',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _numberOfClients++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Duration selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'مدة الإقامة (أيام):',
                                style: TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_durationDays > 1) {
                                          _durationDays--;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    '$_durationDays',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _durationDays++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Confirm reservation button
                          if (!widget.isAdmin)
                            CustomButtonWidget(
                              widget: state is ReservationLoading
                                  ? CircularProgressIndicator(
                                      color: BlocProvider.of<ThemeAppCubit>(
                                              context)
                                          .kprimayColor,
                                    )
                                  : Text(
                                      'تأكيد الحجز',
                                      style: TextStyle(
                                          color: BlocProvider.of<ThemeAppCubit>(
                                                  context)
                                              .kprimayColor),
                                    ),
                              onTap: () {
                                if (_selectedReservationType == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('الرجاء اختيار نوع الحجز')),
                                  );
                                  return;
                                }

                                context
                                    .read<ReservationCubit>()
                                    .createReservation(
                                      hotelId: widget.hotel.id,
                                      hotelName: widget.hotel.name,
                                      hotelAddress: widget.hotel.address,
                                      reservationType:
                                          _selectedReservationType!,
                                      numberOfClients: _numberOfClients,
                                      durationDays: _durationDays,
                                      // totalPrice: _pricePerNight * _durationDays,
                                    );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
