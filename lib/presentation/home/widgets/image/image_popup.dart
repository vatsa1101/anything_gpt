import 'dart:math';
import 'dart:typed_data';
import '../../../utils/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class ImagePopup extends StatelessWidget {
  final String id;
  final Uint8List imageBytes;
  const ImagePopup({
    required this.id,
    required this.imageBytes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black45,
        alignment: Alignment.center,
        child: SizedBox(
          width: min(context.width * 0.9, context.height * 0.9),
          height: min(context.width * 0.9, context.height * 0.9),
          child: Stack(
            children: [
              Hero(
                tag: id,
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                  width: context.width * 0.9,
                  height: context.height * 0.9,
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: MouseRegion(
                  cursor: MaterialStateMouseCursor.clickable,
                  child: GestureDetector(
                    onTap: () async {
                      final image = await decodeImageFromList(imageBytes);
                      final html.CanvasElement canvas = html.CanvasElement(
                        height: image.height,
                        width: image.width,
                      );
                      final ctx = canvas.context2D;
                      final List<String> binaryString = [];
                      for (final imageCharCode in imageBytes) {
                        final charCodeString =
                            String.fromCharCode(imageCharCode);
                        binaryString.add(charCodeString);
                      }
                      final data = binaryString.join();
                      final base64 = html.window.btoa(data);
                      final img = html.ImageElement();
                      img.src = "data:image/png;base64,$base64";
                      final html.ElementStream<html.Event> loadStream =
                          img.onLoad;
                      loadStream.listen((event) {
                        ctx.drawImage(img, 0, 0);
                        final dataUrl = canvas.toDataUrl("image/png", 100);
                        final html.AnchorElement anchorElement =
                            html.AnchorElement(href: dataUrl);
                        anchorElement.download = "${DateTime.now()}.png";
                        anchorElement.click();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.download,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
