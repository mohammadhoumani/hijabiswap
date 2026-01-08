import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/editprofile/edit_profile_controller.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: Obx(() {
        if (controller.profileController.profileData.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }

        final profile = controller.profileController.profileData[0];

        return CustomScrollView(
          slivers: [
            // App Bar with gradient
            SliverAppBar(
              expandedHeight: SizeUtils.scaleY(200),
              pinned: true,
              backgroundColor: theme.colorScheme.primary,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar with Edit Overlay
                        Stack(
                          children: [
                            Obx(
                              () => Container(
                                width: SizeUtils.scaleX(100),
                                height: SizeUtils.scaleX(100),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                child:
                                    controller.selectedImage.value != null
                                        ? ClipOval(
                                          child: Image.file(
                                            controller.selectedImage.value!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : (profile.imageUrl != null &&
                                                profile.imageUrl!.isNotEmpty
                                            ? ClipOval(
                                              child: Image.network(
                                                profile.imageUrl!,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (
                                                  context,
                                                  child,
                                                  progress,
                                                ) {
                                                  if (progress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child: SizedBox(
                                                      width: SizeUtils.scaleX(
                                                        40,
                                                      ),
                                                      height: SizeUtils.scaleX(
                                                        40,
                                                      ),
                                                      child: CircularProgressIndicator(
                                                        value:
                                                            progress.expectedTotalBytes !=
                                                                    null
                                                                ? progress
                                                                        .cumulativeBytesLoaded /
                                                                    progress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .primary,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Center(
                                                    child: Text(
                                                      profile.name.isNotEmpty
                                                          ? profile.name[0]
                                                              .toUpperCase()
                                                          : 'U',
                                                      style: GoogleFonts.inter(
                                                        fontSize:
                                                            SizeUtils.scaleY(
                                                              48,
                                                            ),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .primary,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                            : Center(
                                              child: Text(
                                                profile.name.isNotEmpty
                                                    ? profile.name[0]
                                                        .toUpperCase()
                                                    : 'U',
                                                style: GoogleFonts.inter(
                                                  fontSize: SizeUtils.scaleY(
                                                    48,
                                                  ),
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                              ),
                                            )),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: SizeUtils.scaleX(18),
                                    color: theme.colorScheme.primary,
                                  ),
                                  onPressed:
                                      () =>
                                          controller.pickProfileImage(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeUtils.scaleY(12)),
                        Text(
                          'Edit Profile',
                          style: GoogleFonts.inter(
                            fontSize: SizeUtils.scaleY(24),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(SizeUtils.scaleX(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Editable Fields Section
                    Text(
                      'Personal Information',
                      style: GoogleFonts.inter(
                        fontSize: SizeUtils.scaleY(18),
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(16)),

                    // Name Field
                    _buildEditField(
                      theme: theme,
                      label: 'Full Name',
                      controller: controller.nameController,
                      icon: Icons.person_outline,
                    ),
                    SizedBox(height: SizeUtils.scaleY(12)),

                    // City Field
                    _buildEditField(
                      theme: theme,
                      label: 'City',
                      controller: controller.cityController,
                      icon: Icons.location_city_outlined,
                    ),
                    SizedBox(height: SizeUtils.scaleY(24)),

                    // Account Information (Read-only)
                    Text(
                      'Account Information',
                      style: GoogleFonts.inter(
                        fontSize: SizeUtils.scaleY(18),
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(16)),

                    // Grouped Info Card
                    _buildInfoGroup(
                      theme: theme,
                      items: [
                        _InfoItem(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: profile.email,
                        ),

                        _InfoItem(
                          icon: Icons.email_outlined,
                          title: 'Email Status',
                          value:
                              profile.emailIsConfirm
                                  ? 'Verified'
                                  : 'Not Verified',
                          trailing:
                              profile.emailIsConfirm
                                  ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: SizeUtils.scaleX(20),
                                  )
                                  : Icon(
                                    Icons.warning,
                                    color: Colors.orange,
                                    size: SizeUtils.scaleX(20),
                                  ),
                        ),

                        _InfoItem(
                          icon: Icons.calendar_today_outlined,
                          title: 'Member Since',
                          value: controller.formatDate(profile.createdAt),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeUtils.scaleY(32)),

                    // Action Buttons
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: SizeUtils.scaleY(50),
                        child: ElevatedButton.icon(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () {
                                    controller.updateProfile(
                                      controller.nameController.text,
                                      controller.cityController.text,
                                      controller.selectedImage.value?.path ??
                                          '',
                                    );
                                  },
                          label:
                              controller.isLoading.value
                                  ? SizedBox(
                                    width: SizeUtils.scaleX(20),
                                    height: SizeUtils.scaleX(20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  )
                                  : Text(
                                    'Save Changes',
                                    style: GoogleFonts.inter(
                                      fontSize: SizeUtils.scaleY(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            disabledBackgroundColor: theme.colorScheme.primary
                                .withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleX(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(12)),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: SizeUtils.scaleY(50),
                        child: OutlinedButton.icon(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () => Get.back(),
                          icon: Icon(Icons.close, size: SizeUtils.scaleX(20)),
                          label: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                controller.isLoading.value
                                    ? theme.colorScheme.onSurface.withOpacity(
                                      0.5,
                                    )
                                    : theme.colorScheme.onSurface,
                            side: BorderSide(
                              color:
                                  controller.isLoading.value
                                      ? theme.colorScheme.outline.withOpacity(
                                        0.3,
                                      )
                                      : theme.colorScheme.outline,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleX(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(24)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEditField({
    required ThemeData theme,
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: SizeUtils.scaleY(14),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeUtils.scaleX(16),
          vertical: SizeUtils.scaleY(14),
        ),
      ),
      style: GoogleFonts.inter(
        fontSize: SizeUtils.scaleY(16),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInfoGroup({
    required ThemeData theme,
    required List<_InfoItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children:
            items.map((item) {
              final isLast = item == items.last;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(16),
                      vertical: SizeUtils.scaleY(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(SizeUtils.scaleX(10)),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(10),
                            ),
                          ),
                          child: Icon(
                            item.icon,
                            size: SizeUtils.scaleX(22),
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(14)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: SizeUtils.scaleY(12),
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: SizeUtils.scaleY(4)),
                              Text(
                                item.value,
                                style: GoogleFonts.inter(
                                  fontSize: SizeUtils.scaleY(15),
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (item.trailing != null) item.trailing!,
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;
  final Widget? trailing;

  _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.trailing,
  });
}
