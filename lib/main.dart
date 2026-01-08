import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijabiswap/data/services/fcm_service.dart';
import 'package:hijabiswap/routes/app_pages.dart';
import 'package:hijabiswap/theme/app_theme.dart';
import 'package:hijabiswap/utils/size_utils.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  await FcmService().initialize();
  runApp(
    LayoutBuilder(
      builder: (context, constraints) {
        SizeUtils.init(context);
        return GetMaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
