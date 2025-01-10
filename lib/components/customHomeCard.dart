import 'package:flutter/material.dart';

class CustomHomeCard extends StatelessWidget {
  final String title;
  final String amount;
  final List<Widget> children;
  final double? width;
  final double? height;

  const CustomHomeCard({
    Key? key,
    required this.title,
    required this.amount,
    this.children = const [],
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 120, // Default width
      height: height ?? 120, // Default height
      child: Card(
        color: Color(0xFFf3ebf5),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                amount,
                style: TextStyle(fontSize: 17, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
