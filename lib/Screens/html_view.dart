import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:js/js.dart';

/// Externally defined JavaScript function to toggle fullscreen mode.
@JS()
external void toggleFullScreen();

/// A widget that displays a network image using HTML's `ImageElement`.
///
/// This widget registers a platform view to render an image using a native
/// `<img>` element for web performance optimization. It also supports
/// double-tap functionality to toggle fullscreen mode.
class HtmlImageView extends StatelessWidget {
  /// The URL of the image to display.
  final String imageUrl;

  /// Creates an `HtmlImageView` with the required [imageUrl].
  ///
  /// Registers an HTML `ImageElement` as a Flutter platform view.
  HtmlImageView({super.key, required this.imageUrl}) {
    // Register a unique view type for each image URL to avoid conflicts.
    ui_web.platformViewRegistry.registerViewFactory(
      'html-img-view-$imageUrl',
          (int viewId) {
        final imgElement = html.ImageElement()
          ..src = imageUrl
          ..style.width = '100%' // Ensures full width display
          ..style.height = 'auto' // Maintains aspect ratio
          ..onDoubleClick.listen((_) => toggleFullScreen()); // Enables double-tap fullscreen

        return imgElement;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Defines a fixed height for the image display
      child: HtmlElementView(viewType: 'html-img-view-$imageUrl'), // Uses the registered HTML view
    );
  }
}
