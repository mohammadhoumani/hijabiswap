import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.scaleX(24),
          vertical: SizeUtils.scaleY(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: SizeUtils.scaleX(80),
              height: SizeUtils.scaleY(80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.12),
                    theme.colorScheme.primary.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(SizeUtils.scaleY(24)),
              ),
              child: Icon(
                icon,
                size: SizeUtils.scaleY(32),
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: SizeUtils.scaleY(16)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: SizeUtils.scaleY(16),
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: SizeUtils.scaleY(8)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: SizeUtils.scaleY(13),
                height: 1.4,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: SizeUtils.scaleY(14)),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.scaleX(16),
                    vertical: SizeUtils.scaleY(10),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeUtils.scaleY(10)),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.poppins(
                    fontSize: SizeUtils.scaleY(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
