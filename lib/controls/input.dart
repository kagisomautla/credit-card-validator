import 'package:credit_card_validator/controls/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class InputControl extends StatefulWidget {
  final String? title;
  final String? placeholder;
  final String? initialValue;
  final IconData? icon;
  final bool obscure;
  final bool enabled;
  final bool required;
  final Function(String)? onChanged;
  final Function(TextEditingController)? onInitialized;
  final String? Function(String?)? validator;
  final bool autoFocus;
  final int? maxLength;

  const InputControl({
    this.title,
    this.placeholder,
    this.initialValue,
    this.icon,
    this.obscure = false,
    this.enabled = true,
    this.required = false,
    this.onChanged,
    this.onInitialized,
    this.validator,
    this.autoFocus = false,
    this.maxLength,
  });

  @override
  State<InputControl> createState() => _InputControlState();
}

class _InputControlState extends State<InputControl> with SingleTickerProviderStateMixin {
  FocusNode focusNode = FocusNode();
  bool hasFocus = false;
  bool toolTipVisibility = false;
  DateTime? selectedDate;
  TextEditingController controller = TextEditingController();
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  late AnimationController _controller;
  bool autoCompleteOpen = false;
  GlobalKey key = GlobalKey<FormState>();
  RenderBox? box;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      reverseDuration: Duration(milliseconds: 150),
      vsync: this,
    );

    //Handle focus with a boolean.
    focusNode.addListener(
      () => setState(() {
        hasFocus = focusNode.hasFocus;

        if (hasFocus) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      }),
    );

    //Set the initial value for the controller, if any.
    controller.text = widget.initialValue != null ? widget.initialValue.toString() : "";

    if (widget.onInitialized != null) {
      widget.onInitialized!(controller);
    }

    super.initState();
  }

  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            TextFormField(
              key: key,
              enabled: widget.enabled,
              controller: controller,
              focusNode: focusNode,
              obscureText: widget.obscure,
              validator: widget.validator,
              keyboardType: keyboardType,
              autofocus: widget.autoFocus,
              cursorColor: Colors.black,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                isDense: true,
                labelText: widget.title,

                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),

                // floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: EdgeInsets.all(10),
                errorStyle: TextStyle(
                  color: Colors.red,
                ),
              ),
              onChanged: widget.onChanged == null
                  ? null
                  : (e) {
                      widget.onChanged!(e);
                    },
            ),
          ],
        ),
      ],
    );
  }
}
