import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hijabiswap/modules/activity/activity_bindings.dart';
import 'package:hijabiswap/modules/activity/activity_view.dart';
import 'package:hijabiswap/modules/addproduct/add_product_view.dart';
import 'package:hijabiswap/modules/addproduct/addproduct_bindings.dart';
import 'package:hijabiswap/modules/auth/bindings/auth_bindings.dart';
import 'package:hijabiswap/modules/auth/view/forget_password_view.dart';
import 'package:hijabiswap/modules/auth/view/login_view.dart';
import 'package:hijabiswap/modules/confirmorder/confirm_order_bindings.dart';
import 'package:hijabiswap/modules/confirmorder/confirm_order_view.dart';
import 'package:hijabiswap/modules/editprofile/edit_profile_bindings.dart';
import 'package:hijabiswap/modules/editprofile/edit_profile_view.dart';
import 'package:hijabiswap/modules/favorites/favorites_bindings.dart';
import 'package:hijabiswap/modules/favorites/favorites_view.dart';
import 'package:hijabiswap/modules/home/home_bindings.dart';
import 'package:hijabiswap/modules/home/home_view.dart';
import 'package:hijabiswap/modules/notfications/notifications_bindings.dart';
import 'package:hijabiswap/modules/notfications/notifications_view.dart';
import 'package:hijabiswap/modules/profile/profile_bindings.dart';
import 'package:hijabiswap/modules/profile/profile_view.dart';
import 'package:hijabiswap/modules/splash/splash_bindings.dart';
import 'package:hijabiswap/routes/app_routes.dart';
import 'package:hijabiswap/widgets/navbar.dart';
import 'package:hijabiswap/modules/splash/splash_view.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      bindings: [SplashBindings()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const SignInView(),
      bindings: [AuthBindings()],
    ),
    GetPage(
      name: AppRoutes.confirmOrder,
      page: () => ConfirmOrderView(),
      bindings: [ConfirmOrderBindings()],
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => NotificationsView(),
      bindings: [NotificationsBindings()],
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      bindings: [HomeBindings()],
    ),
    GetPage(
      name: AppRoutes.addProduct,
      page: () => AddProductView(),
      bindings: [AddProductBindings()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      bindings: [ProfileBindings()],
    ),
    GetPage(
      name: AppRoutes.navbar,
      page: () => Navbar(),
      bindings: [
        HomeBindings(),
        AddProductBindings(),
        ProfileBindings(),
        ActivityBindings(),
        FavoritesBindings(),
      ],
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => EditProfileView(),
      bindings: [EditProfileBindings()],
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgetPasswordView(),
      bindings: [AuthBindings()],
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesView(),
      bindings: [FavoritesBindings()],
    ),
    GetPage(
      name: AppRoutes.activity,
      page: () => const ActivityView(),
      bindings: [ActivityBindings()],
    ),
  ];
}
