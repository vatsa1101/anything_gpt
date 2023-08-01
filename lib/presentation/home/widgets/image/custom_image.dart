import 'dart:typed_data';
import 'image_popup.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String id;
  final Uint8List imageBytes;

  CustomImage({
    required this.id,
    required this.imageBytes,
    super.key,
  });

  final ValueNotifier<bool> _isHovered = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) {
              return ImagePopup(
                id: id,
                imageBytes: imageBytes,
              );
            },
            transitionsBuilder:
                (___, Animation<double> animation, ____, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) {
          _isHovered.value = true;
        },
        onExit: (_) {
          _isHovered.value = false;
        },
        child: Stack(
          children: [
            Hero(
              tag: id,
              child: Image.memory(
                imageBytes,
                fit: BoxFit.fitWidth,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isHovered,
              builder: (_, isHovered, child) {
                return isHovered
                    ? Positioned.fill(
                        child: Container(
                          color: Colors.black26,
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
