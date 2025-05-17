import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/google_map/presentation/views/map_screen.dart';
import 'package:rifqa/Features/reservation/presentation/views/reservation_page.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';
import 'hotel_list_item.dart';

class HotelBottomSheet extends StatelessWidget {
  final HotelViewModel viewModel;

  const HotelBottomSheet({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  viewModel.selectedHotel != null
                      ? 'الفندق المحدد'
                      : 'الفنادق القريبة',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: viewModel.selectedHotel != null
                      ? 1
                      : viewModel.hotels.length,
                  itemBuilder: (context, index) {
                    if (viewModel.selectedHotel != null) {
                      return HotelListItem(
                        hotel: viewModel.selectedHotel!,
                        isSelected: true,
                      );
                    }
                    final hotel = viewModel.hotels[index];
                    return HotelListItem(
                      hotel: hotel,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReservationScreen(hotel: hotel))),
                    );
                  },
                ),
              ),
              if (viewModel.selectedHotel != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          widget: const Text('إلغاء'),
                          onTap: viewModel.clearSelection,
                          color: Colors.grey,
                          textColor: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButtonWidget(
                          widget: const Text('حجز'),
                          onTap: viewModel.navigateToReservationScreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      },
    );
  }
}
