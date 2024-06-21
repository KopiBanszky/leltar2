import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    this.onChanged,
    this.onEditingComplete,
    this.onAppPrivateCommand,
    this.validator,
    this.labelText,
    this.color = Colors.white,
    this.fontWeight = FontWeight.normal,
    this.borderColor = const Color.fromARGB(103, 255, 255, 255),
    this.fontSize,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType = TextInputType.text,
    this.controller,
  });

  final String? labelText;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;

  final Color borderColor;

  final Icon? prefixIcon;

  final Icon? suffixIcon;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final AppPrivateCommandCallback? onAppPrivateCommand;

  final FormFieldValidator<String>? validator;

  final TextInputType inputType;

  final TextEditingController? controller;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _isEmpty = true;

  void _onChanged(String value) {
    setState(() {
      _isEmpty = widget.controller!.text.trim().isEmpty || value.trim().isEmpty;
    });
    widget.onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: _onChanged,
      validator: widget.validator,
      onEditingComplete: widget.onEditingComplete,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      keyboardType: widget.inputType,
      style: TextStyle(
        color: widget.color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
      cursorColor: Colors.white,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        enabledBorder: _isEmpty
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: widget.borderColor,
                  // style: BorderStyle.none,
                ),
              )
            : const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
        border: _isEmpty
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: widget.borderColor,
                  // style: BorderStyle.none,
                ),
              )
            : const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 10,
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}
