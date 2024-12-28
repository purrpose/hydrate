import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterIntakeCircle extends StatelessWidget {
  final double amountTaken;
  final double dailyAmount;

  const WaterIntakeCircle({
    super.key,
    required this.amountTaken,
    required this.dailyAmount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (amountTaken / dailyAmount).clamp(0.0, 1.0);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          // Display Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${(progress * 100).toStringAsFixed(0)}%",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$amountTaken ml / $dailyAmount ml",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
