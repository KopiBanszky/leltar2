import 'package:flutter/material.dart';

class AlertDialogWidget extends StatefulWidget {
  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.mainAction,
    required this.mainActionText,
    this.dismissible,
    this.secondaryAction,
    this.secondaryActionText,
  });

  final String title;
  final Widget content;
  final bool? dismissible;
  final Function mainAction;
  final Function? secondaryAction;
  final String mainActionText;
  final String? secondaryActionText;

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: widget.content,
      actions: <Widget>[
        TextButton(
          onPressed: widget.mainAction as void Function()?,
          child: Text(widget.mainActionText),
        ),
        if (widget.secondaryAction != null)
          TextButton(
            onPressed: widget.secondaryAction as void Function()?,
            child: Text(widget.secondaryActionText ?? "Cancel"),
          ),
      ],
    );
  }
}
