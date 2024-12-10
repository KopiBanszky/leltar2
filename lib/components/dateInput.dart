import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  const DateInput({
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
    this.initialValue,
    required this.controller,
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

  final DateTime? initialValue;

  final TextEditingController controller;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  bool _isEmpty = true;

  void _onChanged(String value) {
    setState(() {
      _isEmpty = value.trim().isEmpty;
    });
    widget.onChanged!(value);
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      widget.controller.text =
          DateFormat("yyyy-MM-dd").format(widget.initialValue!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        onChanged: _onChanged,
        onEditingComplete: widget.onEditingComplete,
        onAppPrivateCommand: widget.onAppPrivateCommand,
        validator: widget.validator,
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
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
        ),
        readOnly: true, // when true user cannot edit text
        onTap: () async {
          DateTime? pickDate = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(DateTime.now().year + 1),
          ));
          String formattedDate =
              DateFormat("yyyy-MM-dd").format(pickDate ?? DateTime.now());
          widget.controller.text = formattedDate.toString();
        });
  }
}
