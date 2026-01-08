import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/confirmorder/confirm_order_controller.dart';
import 'package:hijabiswap/modules/profile/profile_controller.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ConfirmOrderView extends StatefulWidget {
  const ConfirmOrderView({super.key});

  @override
  State<ConfirmOrderView> createState() => _ConfirmOrderViewState();
}

class _ConfirmOrderViewState extends State<ConfirmOrderView> {
  final ConfirmOrderController controller = Get.find<ConfirmOrderController>();
  final formKey = GlobalKey<FormState>();
  final RxBool useDefaultAddress = true.obs;

  late final TextEditingController streetController;
  late final TextEditingController cityController;
  late final TextEditingController postalCodeController;
  late final TextEditingController countryController;

  Map<String, dynamic>? defaultAddress;
  String? requestId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    requestId = args['requestId'] as String?;
    defaultAddress =
        (args['defaultAddress'] as Map<String, dynamic>?) ??
        _getProfileDefault();

    useDefaultAddress.value = defaultAddress != null;

    streetController = TextEditingController(
      text: (defaultAddress?['street'] as String?) ?? '',
    );
    cityController = TextEditingController(
      text: (defaultAddress?['city'] as String?) ?? '',
    );
    postalCodeController = TextEditingController(
      text: (defaultAddress?['postalCode'] as String?) ?? '',
    );
    countryController = TextEditingController(
      text: (defaultAddress?['country'] as String?) ?? '',
    );
  }

  Map<String, dynamic>? _getProfileDefault() {
    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();
      if (profileController.profileData.isNotEmpty) {
        return profileController.profileData.first.defaultShippingAddress;
      }
    }
    return null;
  }

  @override
  void dispose() {
    streetController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    useDefaultAddress.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (requestId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Confirm Order')),
        body: const Center(child: Text('Missing request information.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Order'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeUtils.scaleX(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            SizedBox(height: SizeUtils.scaleY(14)),
            _buildDefaultAddressCard(theme),
            SizedBox(height: SizeUtils.scaleY(12)),
            _buildCustomAddressCard(theme),
            SizedBox(height: SizeUtils.scaleY(24)),
            _buildConfirmButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a shipping address',
          style: GoogleFonts.inter(
            fontSize: SizeUtils.scaleY(18),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: SizeUtils.scaleY(4)),
        Text(
          'Use your saved address or enter a one-time address for this order.',
          style: GoogleFonts.inter(
            fontSize: SizeUtils.scaleY(12),
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAddressCard(ThemeData theme) {
    final hasDefault = defaultAddress != null;
    return Obx(
      () => _baseCard(
        theme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<bool>(
              value: true,
              groupValue: useDefaultAddress.value,
              onChanged:
                  hasDefault
                      ? (v) {
                        if (v == true) useDefaultAddress.value = true;
                      }
                      : null,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Use default address',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              subtitle:
                  hasDefault
                      ? Padding(
                        padding: EdgeInsets.only(top: SizeUtils.scaleY(6)),
                        child: _addressPreview(theme, defaultAddress!),
                      )
                      : Text(
                        'No default address saved. Please add one in your profile.',
                        style: GoogleFonts.inter(
                          fontSize: SizeUtils.scaleY(12),
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAddressCard(ThemeData theme) {
    return Obx(
      () => _baseCard(
        theme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<bool>(
              value: false,
              groupValue: useDefaultAddress.value,
              onChanged: (v) {
                if (v == false) useDefaultAddress.value = false;
              },
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Use a different address',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'This will only be used for this order.',
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(12),
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            SizedBox(height: SizeUtils.scaleY(8)),
            AbsorbPointer(
              absorbing: useDefaultAddress.value,
              child: Opacity(
                opacity: useDefaultAddress.value ? 0.5 : 1,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _inputField(
                        theme,
                        controller: streetController,
                        label: 'Street Address',
                        icon: Icons.home_outlined,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Street is required'
                                    : null,
                      ),
                      SizedBox(height: SizeUtils.scaleY(8)),
                      _inputField(
                        theme,
                        controller: cityController,
                        label: 'City',
                        icon: Icons.location_city_outlined,
                        textCapitalization: TextCapitalization.words,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'City is required'
                                    : null,
                      ),
                      SizedBox(height: SizeUtils.scaleY(8)),
                      _inputField(
                        theme,
                        controller: postalCodeController,
                        label: 'Postal Code',
                        icon: Icons.local_post_office_outlined,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[0-9A-Za-z -]"),
                          ),
                        ],
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Postal code is required'
                                    : null,
                      ),
                      SizedBox(height: SizeUtils.scaleY(8)),
                      _inputField(
                        theme,
                        controller: countryController,
                        label: 'Country',
                        icon: Icons.public_outlined,
                        textCapitalization: TextCapitalization.words,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Country is required'
                                    : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(ThemeData theme) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: SizeUtils.scaleY(48),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
            ),
          ),
          onPressed:
              controller.isLoading.value ? null : () => _handleConfirm(theme),
          child:
              controller.isLoading.value
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
                    'Confirm Order',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeUtils.scaleY(14),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _baseCard(ThemeData theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeUtils.scaleX(14)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: child,
    );
  }

  Widget _addressPreview(ThemeData theme, Map<String, dynamic> address) {
    final street = (address['street'] as String?) ?? '';
    final city = (address['city'] as String?) ?? '';
    final postalCode = (address['postalCode'] as String?) ?? '';
    final country = (address['country'] as String?) ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          street,
          style: GoogleFonts.inter(
            fontSize: SizeUtils.scaleY(14),
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: SizeUtils.scaleY(2)),
        Text(
          [city, postalCode].where((e) => e.isNotEmpty).join(', '),
          style: GoogleFonts.inter(
            fontSize: SizeUtils.scaleY(12),
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        if (country.isNotEmpty) ...[
          SizedBox(height: SizeUtils.scaleY(2)),
          Text(
            country,
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(12),
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );
  }

  Widget _inputField(
    ThemeData theme, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeUtils.scaleX(12),
          vertical: SizeUtils.scaleY(10),
        ),
        prefixIcon: Icon(icon, size: SizeUtils.scaleX(18)),
        prefixIconConstraints: BoxConstraints(
          minWidth: SizeUtils.scaleX(40),
          minHeight: SizeUtils.scaleY(32),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.scaleX(8)),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> _handleConfirm(ThemeData theme) async {
    Map<String, dynamic>? shipping;

    if (useDefaultAddress.value) {
      if (defaultAddress == null) {
        Get.snackbar('No address', 'Please add a default address first.');
        return;
      }
      shipping = {
        'street': (defaultAddress?['street'] as String?)?.trim() ?? '',
        'city': (defaultAddress?['city'] as String?)?.trim() ?? '',
        'postalCode': (defaultAddress?['postalCode'] as String?)?.trim() ?? '',
        'country': (defaultAddress?['country'] as String?)?.trim() ?? '',
      };
    } else {
      final valid = formKey.currentState?.validate() ?? false;
      if (!valid) return;
      shipping = {
        'street': streetController.text.trim(),
        'city': cityController.text.trim(),
        'postalCode': postalCodeController.text.trim(),
        'country': countryController.text.trim(),
      };
    }

    final success = await controller.confirmOrder(
      requestId: requestId!,
      data: {'shippingAddress': shipping},
    );

    if (success && mounted) {
      Get.back();
    }
  }
}
