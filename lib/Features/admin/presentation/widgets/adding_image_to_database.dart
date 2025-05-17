// features/admin/presentation/widgets/adding_image_to_database.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';

class AddinImageToDatabase extends StatelessWidget {
  final File? image;
  final String? imageUrl;
  const AddinImageToDatabase({
    super.key,
    this.image,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 3),
        image: getImageDecoration(),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Icon(
              Icons.add,
              color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              size: 45,
            )),
      ),
    );
  }

  DecorationImage? getImageDecoration() {
    if (image != null) {
      return DecorationImage(
        image: FileImage(image!),
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null) {
      return DecorationImage(
        image: NetworkImage(imageUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
