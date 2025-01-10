import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed; // Function passed to the button

  // Constructor to receive the function to be executed on press
  const CustomFAB({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 65,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 10.0,
        onPressed: onPressed, // Use the passed function here
        child: const Icon(Icons.add, size: 35),
      ),
    );
  }
}
