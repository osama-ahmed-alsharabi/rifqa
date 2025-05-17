import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final Widget widget;
  final Function()? onTap;
  final Color color;
  final Color? textColor;
  final double horizontalPadding;
  const CustomButtonWidget({
    super.key,
    required this.widget,
    this.onTap,
    this.color = Colors.white,
    this.textColor,
    this.horizontalPadding = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.5,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
