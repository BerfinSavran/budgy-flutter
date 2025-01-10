import 'package:flutter/material.dart';

class CustomAnalysisCard extends StatefulWidget {
  final String title;
  final String amount;
  final String? date;
  final bool showDate;
  final bool income;

  const CustomAnalysisCard({
    Key? key,
    required this.title,
    required this.amount,
    this.date,
    this.showDate = false,
    this.income = true,
  }) : super(key: key);

  @override
  _CustomAnalysisCardState createState() => _CustomAnalysisCardState();
}

class _CustomAnalysisCardState extends State<CustomAnalysisCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFf3ebf5),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.income ? "+ "+ widget.amount : "- "+widget.amount,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.income ? Colors.green[700] : Colors.red[700], // Adjust color as needed
                  ),
                ),
              ],
            ),
            if (widget.showDate && widget.date != null) ...[
              SizedBox(height: 8),
              Text(
                widget.date!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
