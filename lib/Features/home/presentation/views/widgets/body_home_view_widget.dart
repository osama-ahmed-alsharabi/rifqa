import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/company_widget.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/grid_list_widget.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/image_const.dart';

class BodyHomeViewWidget extends StatelessWidget {
  const BodyHomeViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeAppCubit, ThemeAppState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 170.0,
              pinned: true,
              leading: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Image.asset(
                  ImageConst.kIocnDrawer,
                  width: 100,
                ),
              ),
              backgroundColor:
                  BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              floating: true,
              flexibleSpace: const FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: CompanyWidget(),
                ),
              ),
              centerTitle: true,
              title: const Text(
                'Rifqa',
                style: TextStyle(fontSize: 36),
              ),
              actions: const [
                Image(
                  image: AssetImage(ImageConst.kIconLogo),
                ),
              ],
            ),
            const GridListWidget()
          ],
        );
      },
    );
  }
}
