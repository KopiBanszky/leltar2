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
    this.disabled,
    this.disabledBorderColor,
    this.disabledTextColor,
    this.disabledBackgroundGradient,
    this.width,
    this.spacing,
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
  final bool? disabled;
  final Color? disabledBorderColor;
  final Color? disabledTextColor;
  final Gradient? disabledBackgroundGradient;
  final double? width;
  final MainAxisAlignment? spacing;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: duration ?? 200),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: (disabled ?? false ? disabledBorderColor : borderColor) ??
                Colors.white,
            width: 1),
        gradient:
            disabled ?? false ? disabledBackgroundGradient : backgroundGradient,
      ),
      child: ElevatedButton(
        onPressed: disabled ?? false ? onPressed : onPressed,
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
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: spacing ?? MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color:
                          (disabled ?? false ? disabledTextColor : textColor) ??
                              Colors.white,
                      size: (fontSize ?? 20) + (text == "" ? 0 : 8),
                    ),
                    Text(
                      text ?? "",
                      style: TextStyle(
                        color: (disabled ?? false
                                ? disabledTextColor
                                : textColor) ??
                            Colors.white,
                        fontSize: fontSize ?? 20,
                      ),
                    ),
                  ],
                )
              : Text(
                  text ?? "",
                  style: TextStyle(
                    color:
                        (disabled ?? false ? disabledTextColor : textColor) ??
                            Colors.white,
                    fontSize: fontSize ?? 20,
                  ),
                ),
        ),
      ),
    );
  }
}
