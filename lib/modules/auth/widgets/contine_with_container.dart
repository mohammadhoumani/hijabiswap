import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

Widget continueWithContainer({
  String? iconPath,
  required String buttonText,
  ThemeData? themeData,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: SizeUtils.scaleY(40),
    width: SizeUtils.scaleX(327),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: themeData?.colorScheme.surface ?? AppColors.peach,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null) ...[
            Image.asset(
              iconPath,
              height: SizeUtils.scaleY(20),
              width: SizeUtils.scaleX(20),
              fit: BoxFit.cover,
            ),
          ],
          SizedBox(width: SizeUtils.scaleX(10)),
          Text(
            buttonText,
            style: GoogleFonts.inter(
              color:
                  themeData?.colorScheme.onInverseSurface ??
                  AppColors.secondary,
              fontSize: SizeUtils.scaleY(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
