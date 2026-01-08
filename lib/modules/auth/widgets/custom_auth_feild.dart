import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class CustomAuthField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ThemeData? themeData;

  const CustomAuthField({
    super.key,
    required this.labelText,
    required this.obscureText,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.themeData,
  });

  @override
  State<CustomAuthField> createState() => _CustomAuthFieldState();
}

class _CustomAuthFieldState extends State<CustomAuthField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeUtils.scaleY(45),
      width: SizeUtils.scaleX(327),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _isObscured,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.inter(
            color:
                widget.themeData?.colorScheme.onSurface.withOpacity(0.6) ??
                Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: widget.themeData?.colorScheme.primary ?? AppColors.primary,
              width: 2.0,
            ),
          ),
          hintText: widget.hintText,
          labelText: widget.labelText,
          labelStyle: GoogleFonts.inter(
            color: widget.themeData?.colorScheme.primary ?? AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color:
                          widget.themeData?.colorScheme.primary ??
                          AppColors.primary,
                      size: SizeUtils.scaleY(20),
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}

// Backward compatibility wrapper
Widget customAuthField({
  required String labelText,
  required bool obscureText,
  required String hintText,
  TextEditingController? controller,
  TextInputType? keyboardType,
  ThemeData? themeData,
}) {
  return CustomAuthField(
    labelText: labelText,
    obscureText: obscureText,
    hintText: hintText,
    controller: controller,
    keyboardType: keyboardType,
    themeData: themeData,
  );
}
