import 'package:credit_card_validator/controls/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';

class ButtonControl extends StatefulWidget {
  final String? title;
  final Color? backgroundColor;
  final bool? isBold;
  final GestureTapCallback? onTap;
  final bool disable;
  final Widget? titleWidget;

  const ButtonControl({
    this.title = '',
    this.backgroundColor,
    this.isBold = false,
    this.onTap,
    this.disable = false,
    this.titleWidget,
  });

  @override
  State<ButtonControl> createState() => _ButtonControlState();
}

class _ButtonControlState extends State<ButtonControl> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disable == false ? widget.onTap : null,
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Center(
            child: widget.titleWidget ?? TextControl(text: widget.title!, isBold: widget.isBold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
