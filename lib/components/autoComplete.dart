import 'package:flutter/material.dart';

class AutocompleteHelp extends StatefulWidget {
  const AutocompleteHelp({super.key});

  @override
  State<AutocompleteHelp> createState() => _AutocompleteHelpState();
}

class _AutocompleteHelpState extends State<AutocompleteHelp> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) {
        print(textEditingValue.text);
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return ['apple', 'banana', 'orange', 'pear', 'strawberry', 'watermelon'].where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,

          // validator: widget.validator,
          // onEditingComplete: widget.onEditingComplete,
          // onAppPrivateCommand: widget.onAppPrivateCommand,
          // keyboardType: widget.inputType,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          cursorColor: Colors.white,
          // enableInteractiveSelection: false,
          decoration: InputDecoration(
            prefixIcon: null,
            suffixIcon: null,
            enabledBorder: true
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.blue,
                      // style: BorderStyle.none,
                    ),
                  )
                : const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
            border: true
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.blue,
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
            labelText: "Test",
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
    );
  }
}
