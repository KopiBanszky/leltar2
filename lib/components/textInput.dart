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
    this.isSuggestionsOn = false,
    this.suggestions,
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

  final bool? isSuggestionsOn;
  final Future<List<String>> Function()? suggestions;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _isEmpty = true;

  void _onChanged(String value) {
    if (_isEmpty == widget.controller!.text.trim().isEmpty) return;
    setState(() {
      _isEmpty = widget.controller!.text.trim().isEmpty || value.trim().isEmpty;
    });
    widget.onChanged != null ? widget.onChanged!(value) : () {};
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSuggestionsOn!) {
      widget.suggestions!.call().then((value) => print(value));
    }
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        widget.controller!.text = textEditingValue.text;
        _onChanged(textEditingValue.text);
        if (!widget.isSuggestionsOn!) {
          return const Iterable<String>.empty();
        }
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return (await widget.suggestions!.call()).where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
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
      },
      onSelected: (String option) {
        widget.controller!.text = option;
      },
    );
  }
}
