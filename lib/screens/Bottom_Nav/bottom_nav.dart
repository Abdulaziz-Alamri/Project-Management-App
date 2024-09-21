import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_management_app/screens/Bottom_Nav/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:project_management_app/screens/QR_scanner/qr_scanner_screen.dart';
import 'package:project_management_app/theme/appcolors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final List<IconData> iconList = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.rectangleList,
      Icons.calendar_month,
      Icons.person,
      // Icons.qr_code,  // لن نستخدم هذه الأيقونة في الـ Bottom Nav الآن
    ];

    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          extendBody: true,
          body: BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<BottomNavBloc>(context);
              int currentPageIndex = bloc.currentIndex;

              if (state is SuccessChangeViewState) {
                currentPageIndex = state.currentPageIndex;
              }

              return IndexedStack(
                index: currentPageIndex,
                children: bloc.views,
              );
            },
          ),

          // تعديل الـ Floating Action Button
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // عند الضغط، الانتقال إلى صفحة QR Code
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QrScannerScreen()),
              );
            },
            backgroundColor: AppColors.blueLight,
            child: const Icon(Icons.qr_code,
                size: 25, color: Colors.white), // تعديل الأيقونة إلى QR Code
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked, // لضبط موقع الفاب

          // شريط التنقل السفلي
          bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<BottomNavBloc>(context);
              int currentPageIndex = bloc.currentIndex;

              if (state is SuccessChangeViewState) {
                currentPageIndex = state.currentPageIndex;
              }
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.blueDark,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: AnimatedBottomNavigationBar.builder(
                  itemCount: iconList.length,
                  tabBuilder: (int index, bool isActive) {
                    final color = isActive ? AppColors.blueLight : Colors.white;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconList[index],
                          size: 30,
                          color: color,
                        ),
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            height: 5,
                            width: 20,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                      ],
                    );
                  },
                  backgroundColor: Colors.transparent,
                  height: 50,
                  activeIndex: currentPageIndex,
                  gapLocation: GapLocation.center,
                  gapWidth: 40,
                  leftCornerRadius: 32,
                  rightCornerRadius: 32,
                  splashRadius: 30,
                  notchSmoothness: NotchSmoothness.softEdge,
                  onTap: (index) {
                    BlocProvider.of<BottomNavBloc>(context)
                        .add(ChangeEvent(index: index));
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
