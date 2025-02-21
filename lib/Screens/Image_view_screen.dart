import 'package:flutter/material.dart';
import 'package:new_task/Screens/html_view.dart';

/// A screen that displays an image using `HtmlImageView`.
///
/// This screen takes an image URL as a parameter and displays it inside
/// an `HtmlImageView` widget, which is optimized for rendering web images.
class ImageViewScreen extends StatelessWidget {
  /// The URL of the image to display.
  final String imageUrl;

  /// Creates an `ImageViewScreen` with the required [imageUrl].
  const ImageViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Directly placing `HtmlImageView` inside the body without `Column`
      /// because it's the only widget in this screen.
      body: HtmlImageView(imageUrl: imageUrl),
    );
  }
}
