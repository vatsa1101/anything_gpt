import 'custom_timer_painter.dart';
import '../../../utils/size_helpers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CustomCountdown extends StatefulWidget {
  final CurrentRemainingTime? time;

  const CustomCountdown({
    required this.time,
    super.key,
  });

  @override
  State<CustomCountdown> createState() => _CustomCountdownState();
}

class _CustomCountdownState extends State<CustomCountdown>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    controller.forward(from: controller.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: context.height * 0.2,
          width: context.height * 0.2,
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, child) {
              return CustomPaint(
                painter: CustomTimerPainter(
                  animation: controller,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Center(
            child: AutoSizeText(
              (widget.time?.sec ?? 0).toString(),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
