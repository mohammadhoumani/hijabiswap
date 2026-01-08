import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/auth/controllers/auth_controller.dart';
import 'package:hijabiswap/modules/auth/view/login_view.dart';
import 'package:hijabiswap/modules/auth/widgets/contine_with_container.dart';
import 'package:hijabiswap/modules/auth/widgets/custom_auth_feild.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -90,
              child: Container(
                width: SizeUtils.scaleX(230),
                height: SizeUtils.scaleY(230),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeData.colorScheme.surface.withAlpha(128),
                ),
              ),
            ),
            Positioned(
              top: -100,
              right: -90,
              child: Container(
                width: SizeUtils.scaleX(195),
                height: SizeUtils.scaleY(195),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeData.colorScheme.primary,
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -90,
              child: Container(
                width: SizeUtils.scaleX(230),
                height: SizeUtils.scaleY(230),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeData.colorScheme.surface.withAlpha(128),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(SizeUtils.scaleX(18)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: SizeUtils.scaleY(100)),
                        Text(
                          "hijabi swap",
                          style: GoogleFonts.italiana(
                            letterSpacing: -1,
                            color: themeData.colorScheme.primary,
                            fontSize: SizeUtils.scaleY(36),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(40)),
                        Text(
                          "Create an account",
                          style: GoogleFonts.inter(
                            color: themeData.colorScheme.primary,
                            fontSize: SizeUtils.scaleY(16),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(5)),
                        Text(
                          "Enter your email to sign up for this app",
                          style: GoogleFonts.inter(
                            color: themeData.colorScheme.primary,
                            letterSpacing: 0,
                            fontSize: SizeUtils.scaleY(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(20)),
                        Form(
                          child: Column(
                            children: [
                              customAuthField(
                                controller: controller.nameController,
                                labelText: "Name",
                                obscureText: false,
                                hintText: "Enter your name",
                              ),
                              SizedBox(height: SizeUtils.scaleY(20)),
                              customAuthField(
                                controller: controller.cityController,
                                labelText: "City",
                                obscureText: false,
                                hintText: "Enter your city name",
                              ),
                              SizedBox(height: SizeUtils.scaleY(20)),
                              customAuthField(
                                controller: controller.emailController,
                                hintText: "Enter your email",
                                labelText: "Email",
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                themeData: themeData,
                              ),
                              SizedBox(height: SizeUtils.scaleY(20)),
                              customAuthField(
                                controller: controller.passwordController,
                                hintText: "Enter your password",
                                labelText: "Password",
                                obscureText: true,
                                themeData: themeData,
                              ),
                              SizedBox(height: SizeUtils.scaleY(20)),
                              SizedBox(
                                width: SizeUtils.scaleX(327),
                                height: SizeUtils.scaleY(40),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.registerWithLocation(
                                      controller.nameController.text,
                                      controller.emailController.text,
                                      controller.passwordController.text,
                                      controller.cityController.text,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        themeData.colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: Obx(() {
                                    if (controller.loading.value) {
                                      return SizedBox(
                                        width: SizeUtils.scaleY(20),
                                        height: SizeUtils.scaleY(20),
                                        child: CircularProgressIndicator(
                                          color:
                                              themeData.colorScheme.onPrimary,
                                          strokeWidth: 2.0,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        "Continue",
                                        style: GoogleFonts.inter(
                                          color:
                                              themeData.colorScheme.onPrimary,
                                          fontSize: SizeUtils.scaleY(16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeUtils.scaleY(10)),
                        continueWithContainer(
                          onPressed: () {
                            Get.to(() => SignInView());
                          },
                          iconPath: "assets/icons/user-check.png",
                          themeData: themeData,
                          buttonText: "Already have an account? Sign In",
                        ),
                        SizedBox(height: SizeUtils.scaleY(20)),

                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: "By signing up, you agree to our ",
                            style: GoogleFonts.inter(
                              color: themeData.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: SizeUtils.scaleY(12),
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: GoogleFonts.inter(
                                  color: themeData.colorScheme.onInverseSurface,
                                  fontSize: SizeUtils.scaleY(12),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: " \nand ",
                                style: GoogleFonts.inter(
                                  color: themeData.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  fontSize: SizeUtils.scaleY(12),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: GoogleFonts.inter(
                                  color: themeData.colorScheme.onInverseSurface,
                                  fontSize: SizeUtils.scaleY(12),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
