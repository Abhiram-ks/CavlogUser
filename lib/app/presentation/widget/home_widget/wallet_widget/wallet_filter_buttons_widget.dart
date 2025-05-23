
import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/constant.dart';

class WalletFilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color colors;

  const WalletFilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            ConstantWidgets.hight10(context),
            Icon(
              icon,
              color: colors,
            ),
          ],
        ),
      ),
    );
  }
}

