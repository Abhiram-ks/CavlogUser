
import 'package:flutter/material.dart';

class WalletFilterButtonBooking extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color colors;

  const WalletFilterButtonBooking({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              Icon(
                icon,
                color: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
