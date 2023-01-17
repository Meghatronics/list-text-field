import 'package:flutter/material.dart';

import 'list_text_editing_controller.dart';

class ListTextField extends StatefulWidget {
  const ListTextField({
    Key? key,
    required this.itemBuilder,
    this.controller,
    this.decoration,
    this.validator,
    this.style,
    this.itemSpacing = 4,
    this.itemLineSpacing = 4,
  }) : super(key: key);

  final ListTextEditingController? controller;
  final Validator? validator;
  final Decoration? decoration;
  final double itemSpacing;
  final double itemLineSpacing;
  final TextStyle? style;
  final Widget Function(BuildContext context, String value) itemBuilder;

  @override
  State<ListTextField> createState() => _ListTextFieldState();
}

class _ListTextFieldState extends State<ListTextField> {
  late ListTextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _controller = widget.controller ?? ListTextEditingController(',');
    _controller.connect(widget.validator);
    super.initState();
  }

  double _calculateTextWidth(
      BuildContext context, String text, TextStyle? style) {
    final scale = MediaQuery.of(context).textScaleFactor;
    double space = 0;
    for (var i = 0; i < text.length; i++) {
      space += (style?.fontSize ?? 14) * scale;
    }
    return space.clamp(40.0, MediaQuery.of(context).size.width);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: _controller.itemsNotifier,
      builder: (_, value, textField) => GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Container(
          decoration: widget.decoration,
          constraints: const BoxConstraints.tightFor(width: double.infinity),
          child: Wrap(
            spacing: widget.itemSpacing,
            runSpacing: widget.itemLineSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (String item in _controller.items)
                widget.itemBuilder(context, item),
              textField!,
            ],
          ),
        ),
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (_, value, field) => SizedBox(
          width: _calculateTextWidth(_, value.text, widget.style),
          child: field,
        ),
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          style: widget.style,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
