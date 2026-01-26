import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:hijabiswap/modules/profile/profile_controller.dart';
import 'package:hijabiswap/routes/app_routes.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: Obx(() {
        if (controller.profileData.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }

        final profile = controller.profileData[0];

        return RefreshIndicator(
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.onPrimary,
          onRefresh: () => controller.loadUserProfile(),
          child: CustomScrollView(
            slivers: [
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: SizeUtils.scaleY(200),
                pinned: true,
                backgroundColor: theme.colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar
                          Container(
                            width: SizeUtils.scaleX(100),
                            height: SizeUtils.scaleX(100),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child:
                                profile.imageUrl != null &&
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
                                          if (progress == null) return child;
                                          return Center(
                                            child: SizedBox(
                                              width: SizeUtils.scaleX(40),
                                              height: SizeUtils.scaleX(40),
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
                                                    theme.colorScheme.primary,
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
                                                fontSize: SizeUtils.scaleY(48),
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    : Center(
                                      child: Text(
                                        profile.name.isNotEmpty
                                            ? profile.name[0].toUpperCase()
                                            : 'U',
                                        style: GoogleFonts.inter(
                                          fontSize: SizeUtils.scaleY(48),
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                          ),
                          SizedBox(height: SizeUtils.scaleY(12)),
                          // Name
                          Text(
                            profile.name,
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(24),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: SizeUtils.scaleY(4)),
                          // Email
                          Text(
                            profile.email,
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(14),
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
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
                      // Stats Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              theme: theme,
                              icon: Icons.shopping_bag_outlined,
                              value: profile.itemsCount.toString(),
                              label: 'Items',
                            ),
                          ),
                          SizedBox(width: SizeUtils.scaleX(12)),
                          Expanded(
                            child: _buildStatCard(
                              theme: theme,
                              icon: Icons.star_outline,
                              value: profile.averageRating.toStringAsFixed(1),
                              label: 'Rating',
                            ),
                          ),
                          SizedBox(width: SizeUtils.scaleX(12)),
                          Expanded(
                            child: _buildStatCard(
                              theme: theme,
                              icon: Icons.reviews_outlined,
                              value: profile.totalRatings.toString(),
                              label: 'Reviews',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeUtils.scaleY(24)),

                      // Account Information
                      Text(
                        'Account Information',
                        style: GoogleFonts.inter(
                          fontSize: SizeUtils.scaleY(18),
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: SizeUtils.scaleY(16)),

                      // Info Cards
                      _buildInfoCard(
                        theme: theme,
                        icon: Icons.location_city_outlined,
                        title: 'Location',
                        value: profile.city,
                      ),
                      SizedBox(height: SizeUtils.scaleY(12)),
                      _buildInfoCard(
                        theme: theme,
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
                      SizedBox(height: SizeUtils.scaleY(12)),
                      _buildInfoCard(
                        theme: theme,
                        icon: Icons.calendar_today_outlined,
                        title: 'Member Since',
                        value: _formatDate(profile.createdAt),
                      ),

                      SizedBox(height: SizeUtils.scaleY(32)),

                      // Shipping Address (Display & Update)
                      _buildShippingAddressCard(
                        context: context,
                        theme: theme,
                        profile: profile,
                      ),

                      SizedBox(height: SizeUtils.scaleY(24)),

                      // Action Buttons
                      SizedBox(
                        width: double.infinity,
                        height: SizeUtils.scaleY(50),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Edit profile action
                            Get.toNamed(AppRoutes.editProfile);
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: SizeUtils.scaleX(20),
                          ),
                          label: Text(
                            'Edit Profile',
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleX(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeUtils.scaleY(12)),
                      SizedBox(
                        width: double.infinity,
                        height: SizeUtils.scaleY(50),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Logout action
                            Get.dialog(
                              AlertDialog(
                                backgroundColor: theme.colorScheme.onPrimary,
                                title: Text(
                                  'Confirm Logout',
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(15),
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to logout?',
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(14),
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text('Cancel'),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(
                                        SizeUtils.scaleX(14),
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.logout();
                                      },
                                      child: Obx(
                                        () =>
                                            controller.isLoading.value
                                                ? SizedBox(
                                                  width: SizeUtils.scaleX(16),
                                                  height: SizeUtils.scaleX(16),
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .onPrimary,
                                                        strokeWidth: 2.0,
                                                      ),
                                                )
                                                : Text(
                                                  'Logout',
                                                  style: GoogleFonts.inter(
                                                    fontSize: SizeUtils.scaleY(
                                                      14,
                                                    ),
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .onPrimary,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.logout, size: SizeUtils.scaleX(20)),
                          label: Text(
                            'Logout',
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleX(12),
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
          ),
        );
      }),
    );
  }

  Widget _buildStatCard({
    required ThemeData theme,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(SizeUtils.scaleX(16)),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(SizeUtils.scaleX(16)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: SizeUtils.scaleX(28),
            color: theme.colorScheme.onPrimary,
          ),
          SizedBox(height: SizeUtils.scaleY(8)),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(20),
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: SizeUtils.scaleY(4)),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(12),
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(SizeUtils.scaleX(16)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeUtils.scaleX(10)),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
            ),
            child: Icon(
              icon,
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
                  title,
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(12),
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(4)),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(15),
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildShippingAddressCard({
    required BuildContext context,
    required ThemeData theme,
    required dynamic profile,
  }) {
    final addr = profile.defaultShippingAddress as Map<String, dynamic>?;
    final street = (addr?['street'] as String?)?.trim() ?? '';
    final city = (addr?['city'] as String?)?.trim() ?? '';
    final postalCode = (addr?['postalCode'] as String?)?.trim() ?? '';
    final country = (addr?['country'] as String?)?.trim() ?? '';
    final hasAddress =
        street.isNotEmpty ||
        city.isNotEmpty ||
        postalCode.isNotEmpty ||
        country.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(SizeUtils.scaleX(16)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(SizeUtils.scaleX(10)),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
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
                      'Shipping Address',
                      style: GoogleFonts.inter(
                        fontSize: SizeUtils.scaleY(12),
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(4)),
                    if (hasAddress) ...[
                      Text(
                        street,
                        style: GoogleFonts.inter(
                          fontSize: SizeUtils.scaleY(15),
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: SizeUtils.scaleY(2)),
                      Text(
                        [
                          city,
                          postalCode,
                        ].where((e) => e.isNotEmpty).join(', '),
                        style: GoogleFonts.inter(
                          fontSize: SizeUtils.scaleY(13),
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      if (country.isNotEmpty) ...[
                        SizedBox(height: SizeUtils.scaleY(2)),
                        Text(
                          country,
                          style: GoogleFonts.inter(
                            fontSize: SizeUtils.scaleY(13),
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ] else ...[
                      Text(
                        'No shipping address set',
                        style: GoogleFonts.inter(
                          fontSize: SizeUtils.scaleY(14),
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: SizeUtils.scaleX(10)),
              OutlinedButton(
                onPressed:
                    () => _showEditShippingAddressDialog(
                      context: context,
                      theme: theme,
                      profile: profile,
                    ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.scaleX(12),
                    vertical: SizeUtils.scaleY(10),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
                  ),
                ),
                child: Text(
                  hasAddress ? 'Update' : 'Add',
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditShippingAddressDialog({
    required BuildContext context,
    required ThemeData theme,
    required dynamic profile,
  }) {
    final formKey = GlobalKey<FormState>();
    final addr = profile.defaultShippingAddress as Map<String, dynamic>?;
    final streetController = TextEditingController(
      text: (addr?['street'] as String?) ?? '',
    );
    final cityController = TextEditingController(
      text: (addr?['city'] as String?) ?? '',
    );
    final postalCodeController = TextEditingController(
      text: (addr?['postalCode'] as String?) ?? '',
    );

    // Reactive country selection
    final selectedCountry = Rxn<Country>();
    final countryError = RxnString();
    final savedCountryName = (addr?['country'] as String?)?.trim() ?? '';

    // Pre-select country if previously saved
    if (savedCountryName.isNotEmpty) {
      try {
        final countries = CountryService().getAll();
        selectedCountry.value = countries.firstWhereOrNull(
          (c) => c.name.toLowerCase() == savedCountryName.toLowerCase(),
        );
      } catch (_) {}
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: theme.colorScheme.onPrimary,
        title: Text(
          'Update Shipping Address',
          style: GoogleFonts.inter(
            fontSize: SizeUtils.scaleY(16),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This address will be used for deliveries.',
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(11),
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(8)),
                TextFormField(
                  controller: streetController,
                  autofocus: true,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    labelText: 'Street Address',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(12),
                      vertical: SizeUtils.scaleY(10),
                    ),
                    prefixIcon: Icon(
                      Icons.home_outlined,
                      size: SizeUtils.scaleX(18),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: SizeUtils.scaleX(40),
                      minHeight: SizeUtils.scaleY(32),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(8)),
                    ),
                  ),
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Street is required'
                              : null,
                ),
                SizedBox(height: SizeUtils.scaleY(8)),
                TextFormField(
                  controller: cityController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'City',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(12),
                      vertical: SizeUtils.scaleY(10),
                    ),
                    prefixIcon: Icon(
                      Icons.location_city_outlined,
                      size: SizeUtils.scaleX(18),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: SizeUtils.scaleX(40),
                      minHeight: SizeUtils.scaleY(32),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(8)),
                    ),
                  ),
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'City is required'
                              : null,
                ),
                SizedBox(height: SizeUtils.scaleY(8)),
                TextFormField(
                  controller: postalCodeController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9A-Za-z -]")),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Postal Code',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(12),
                      vertical: SizeUtils.scaleY(10),
                    ),
                    prefixIcon: Icon(
                      Icons.local_post_office_outlined,
                      size: SizeUtils.scaleX(18),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: SizeUtils.scaleX(40),
                      minHeight: SizeUtils.scaleY(32),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(8)),
                    ),
                  ),
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Postal code is required'
                              : null,
                ),
                SizedBox(height: SizeUtils.scaleY(8)),
                // Country Picker Dropdown
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            countryListTheme: CountryListThemeData(
                              backgroundColor: theme.colorScheme.onPrimary,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(SizeUtils.scaleX(16)),
                              ),
                              searchTextStyle: GoogleFonts.inter(
                                fontSize: SizeUtils.scaleY(14),
                                color: theme.colorScheme.onSurface,
                              ),
                              textStyle: GoogleFonts.inter(
                                fontSize: SizeUtils.scaleY(14),
                                color: theme.colorScheme.onSurface,
                              ),
                              inputDecoration: InputDecoration(
                                hintText: 'Search country',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: theme.colorScheme.primary,
                                ),
                                filled: true,
                                fillColor: theme
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    SizeUtils.scaleX(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            onSelect: (Country country) {
                              selectedCountry.value = country;
                              countryError.value = null;
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(
                          SizeUtils.scaleX(8),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeUtils.scaleX(12),
                            vertical: SizeUtils.scaleY(14),
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(8),
                            ),
                            border: Border.all(
                              color:
                                  countryError.value != null
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.outline.withOpacity(
                                        0.5,
                                      ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.public_outlined,
                                size: SizeUtils.scaleX(18),
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: SizeUtils.scaleX(12)),
                              Expanded(
                                child: Text(
                                  selectedCountry.value != null
                                      ? '${selectedCountry.value!.flagEmoji}  ${selectedCountry.value!.name}'
                                      : 'Select Country',
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(14),
                                    fontWeight: FontWeight.w500,
                                    color:
                                        selectedCountry.value != null
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (countryError.value != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeUtils.scaleY(6),
                            left: SizeUtils.scaleX(12),
                          ),
                          child: Text(
                            countryError.value!,
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(11),
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: SizeUtils.scaleX(16),
          vertical: SizeUtils.scaleY(8),
        ),
        actions: [
          Obx(
            () => OutlinedButton(
              onPressed:
                  controller.isUpdatingShippingAddress.value
                      ? null
                      : () => Get.back(),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
                ),
              ),
              onPressed:
                  controller.isUpdatingShippingAddress.value
                      ? null
                      : () async {
                        final valid = formKey.currentState?.validate() ?? false;

                        // Validate country selection
                        if (selectedCountry.value == null) {
                          countryError.value = 'Country is required';
                        }

                        if (!valid || selectedCountry.value == null) return;

                        await controller.updateShippingAddress(
                          street: streetController.text.trim(),
                          city: cityController.text.trim(),
                          postalCode: postalCodeController.text.trim(),
                          country: selectedCountry.value!.name,
                        );
                        Get.back();
                      },
              child:
                  controller.isUpdatingShippingAddress.value
                      ? SizedBox(
                        width: SizeUtils.scaleX(18),
                        height: SizeUtils.scaleX(18),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                      : Text(
                        'Save',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
