import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.size,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.duration,
    this.padding,
    this.backgroundGradient,
  });

  final Function() onPressed;
  final String? text;
  final IconData? icon;
  final Size? size;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final int? duration;
  final EdgeInsetsGeometry? padding;
  final Gradient? backgroundGradient;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: duration ?? 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor ?? Colors.white, width: 1),
        gradient: backgroundGradient,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // side: BorderSide(color: borderColor ?? Colors.white, width: 1),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          fixedSize: size,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding ?? const EdgeInsets.all(10),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(10),
          child: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: textColor ?? Colors.white,
                      size: fontSize ?? 20,
                    ),
                    Text(
                      text ?? "",
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: fontSize ?? 20,
                      ),
                    ),
                  ],
                )
              : Text(
                  text ?? "",
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize ?? 20,
                  ),
                ),
        ),
      ),
    );
  }
}
