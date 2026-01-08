import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/auth/controllers/auth_controller.dart';
import 'package:hijabiswap/modules/auth/widgets/custom_auth_feild.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ForgetPasswordView extends GetView<AuthController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Forgot Password',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: SizeUtils.scaleY(18),
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SizeUtils.scaleX(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: SizeUtils.scaleY(28)),

              // Subtle header icon to differ from Sign In/Up
              Center(
                child: Container(
                  width: SizeUtils.scaleX(72),
                  height: SizeUtils.scaleX(72),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: SizeUtils.scaleY(28),
                    color: AppColors.primary,
                  ),
                ),
              ),

              SizedBox(height: SizeUtils.scaleY(16)),
              Text(
                'Forgot Password',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeUtils.scaleY(20),
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: SizeUtils.scaleY(22)),
              customAuthField(
                labelText: 'Email',
                obscureText: false,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter your email',
              ),

              SizedBox(height: SizeUtils.scaleY(16)),
              SizedBox(
                height: SizeUtils.scaleY(48),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: hook up reset flow
                    controller.forgotPassword(
                      controller.emailController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
                    ),
                  ),
                  child: Obx(
                    () =>
                        controller.loading.value
                            ? CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2.0,
                            )
                            : Text(
                              'Reset Password',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: SizeUtils.scaleY(16),
                                color: AppColors.white,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
