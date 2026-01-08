import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  final List<String> _banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items:
              _banners
                  .map(
                    (banner) => ClipRRect(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
                      child: Image.asset(
                        banner,
                        fit: BoxFit.cover,
                        width: SizeUtils.scaleX(343),
                      ),
                    ),
                  )
                  .toList(),
          options: CarouselOptions(
            height: SizeUtils.scaleY(203),
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: SizeUtils.scaleY(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width:
                  _currentIndex == index
                      ? SizeUtils.scaleX(24)
                      : SizeUtils.scaleX(8),
              height: SizeUtils.scaleY(8),
              margin: EdgeInsets.symmetric(horizontal: SizeUtils.scaleX(4)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeUtils.scaleX(4)),
                color:
                    _currentIndex == index
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildImageSlider() {
  return const ImageSlider();
}
