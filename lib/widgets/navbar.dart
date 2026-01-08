import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijabiswap/modules/activity/activity_view.dart';
import 'package:hijabiswap/modules/addproduct/add_product_view.dart';
import 'package:hijabiswap/modules/favorites/favorites_view.dart';
import 'package:hijabiswap/modules/home/home_view.dart';
import 'package:hijabiswap/modules/profile/profile_view.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  List<Widget> get pages => [
    const HomeView(),
    FavoritesView(),
    AddProductView(),
    ActivityView(),
    ProfileView(),
  ];

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _pageIndex = 0;

  final items = <Widget>[
    Icon(Icons.home_rounded, size: SizeUtils.scaleY(28)),
    Icon(Icons.favorite_rounded, size: SizeUtils.scaleY(28)),
    Icon(Icons.add_circle, size: SizeUtils.scaleY(32)),
    FaIcon(FontAwesomeIcons.solidPaperPlane, size: SizeUtils.scaleY(24)),
    Icon(Icons.person_rounded, size: SizeUtils.scaleY(28)),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: widget.pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        backgroundColor: themeData.colorScheme.surface,
        color: themeData.colorScheme.onPrimary,
        buttonBackgroundColor: themeData.colorScheme.primary,
        animationDuration: const Duration(milliseconds: 350),
        animationCurve: Curves.easeInOutCubic,
        height: SizeUtils.scaleY(65),
        items:
            items.asMap().entries.map((entry) {
              int idx = entry.key;
              Widget item = entry.value;
              return Container(
                padding: EdgeInsets.all(SizeUtils.scaleX(8)),
                child: AnimatedScale(
                  scale: _pageIndex == idx ? 1.0 : 0.85,
                  duration: const Duration(milliseconds: 300),
                  child: IconTheme(
                    data: IconThemeData(
                      color:
                          _pageIndex == idx
                              ? themeData.colorScheme.onPrimary
                              : themeData.colorScheme.secondary,
                    ),
                    child: item,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
