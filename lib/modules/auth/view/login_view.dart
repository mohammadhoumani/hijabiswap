import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/auth/controllers/auth_controller.dart';
import 'package:hijabiswap/modules/auth/view/signup_view.dart';
import 'package:hijabiswap/modules/auth/widgets/contine_with_container.dart';
import 'package:hijabiswap/modules/auth/widgets/custom_auth_feild.dart';
import 'package:hijabiswap/routes/app_routes.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Container(
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
                          "Welcome Back",
                          style: GoogleFonts.inter(
                            color: themeData.colorScheme.primary,
                            fontSize: SizeUtils.scaleY(16),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(5)),
                        Text(
                          "Enter your Credentials to log in to this app",
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

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Add your forgot password logic here
                                    Get.toNamed(AppRoutes.forgotPassword);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.inter(
                                      color: themeData.colorScheme.primary,
                                      fontSize: SizeUtils.scaleY(12),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: SizeUtils.scaleX(327),
                                height: SizeUtils.scaleY(40),
                                child: ElevatedButton(
                                  onPressed:
                                      () => controller.login(
                                        controller.emailController.text,
                                        controller.passwordController.text,
                                      ),
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
                                        "Sign In",
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
                        SizedBox(height: SizeUtils.scaleY(20)),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Divider(
                                color: themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                thickness: SizeUtils.scaleY(1),
                                indent: SizeUtils.scaleX(10),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Text(
                                "or",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: themeData.colorScheme.primary,
                                  fontSize: SizeUtils.scaleY(14),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Divider(
                                color: themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                thickness: SizeUtils.scaleY(1),
                                endIndent: SizeUtils.scaleX(10),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeUtils.scaleY(20)),
                        continueWithContainer(
                          onPressed: () {
                            Get.to(() => SignUpView());
                          },
                          iconPath: "assets/icons/add-user.png",
                          themeData: themeData,
                          buttonText: "Don't have an account? Sign Up",
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
