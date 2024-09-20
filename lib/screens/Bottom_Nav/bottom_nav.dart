import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_management_app/screens/Bottom_Nav/bottom_nav_bloc/bottom_nav_bloc.dart';
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
      Icons.qr_code,
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

          // Floating Action Button
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
                  backgroundColor: Colors
                      .transparent, // Set to transparent because the container handles it
                  height: 50,
                  activeIndex: currentPageIndex,
                  gapLocation: GapLocation.none,
                  leftCornerRadius: 32,
                  rightCornerRadius: 32,
                  splashRadius: 30,
                  notchSmoothness: NotchSmoothness.verySmoothEdge,
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
