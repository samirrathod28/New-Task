import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:new_task/Screens/Image_view_screen.dart';

/// Calls an external JavaScript function to toggle fullscreen mode.
@JS()
external void toggleFullScreen();

/// A stateful widget that represents the home screen.
///
/// The screen allows users to input an image URL, navigate to an image viewer,
/// and toggle a fullscreen menu with additional actions.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Tracks whether the floating menu is open or closed.
  bool isMenuOpen = false;

  /// Controller for handling the image URL input field.
  final TextEditingController urlController = TextEditingController();

  /// Toggles the visibility of the floating action menu.
  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fullscreen Menu Example")),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Input field for entering an image URL.
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: "Enter Image URL",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.paste),
                      onPressed: () async {
                        // Fetch the clipboard data and set it to the text field.
                        ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                        if (clipboardData != null) {
                          urlController.text = clipboardData.text ?? '';
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.url,
                ),
              ),
              const SizedBox(height: 20),

              // Button to validate and navigate to the image viewer screen.
              ElevatedButton(
                onPressed: () {
                  String url = urlController.text.trim();

                  // Regular expression to check if the entered URL points to an image.
                  RegExp imageRegex = RegExp(r'\.(jpeg|jpg|png|gif|webp|bmp|svg)$', caseSensitive: false);

                  if (Uri.tryParse(url)?.hasAbsolutePath == true &&
                      (url.startsWith('http://') || url.startsWith('https://')) &&
                      imageRegex.hasMatch(url)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageViewScreen(imageUrl: url),
                      ),
                    );
                  } else {
                    // Show an error message if the URL is invalid.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid image URL")),
                    );
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),

          // Semi-transparent overlay when the menu is open.
          if (isMenuOpen)
            GestureDetector(
              onTap: toggleMenu, // Close the menu when tapping outside.
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          // Floating action button with a dropdown menu.
          Positioned(
            bottom: 80,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isMenuOpen)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _menuItem("Enter Fullscreen", toggleFullScreen),
                        _menuItem("Exit Fullscreen", toggleFullScreen),
                      ],
                    ),
                  ),
                FloatingActionButton(
                  onPressed: toggleMenu,
                  backgroundColor: Colors.blue,
                  child: Icon(isMenuOpen ? Icons.close : Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a clickable menu item with text and an action.
  Widget _menuItem(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap(); // Call the provided function.
        toggleMenu(); // Close the menu after tapping.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
