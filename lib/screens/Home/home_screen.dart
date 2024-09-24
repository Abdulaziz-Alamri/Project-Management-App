import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/models/project_model.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/screens/All_projects/all_projects_screen.dart';
import 'package:project_management_app/screens/Home/bloc/home_bloc.dart';
import 'package:project_management_app/screens/Home/boot_camps.dart';
import 'package:project_management_app/screens/Home/image_slider.dart';
import 'package:project_management_app/screens/Home/out_Standing_student.dart';
import 'package:project_management_app/screens/Home/projects_contaner.dart';
import 'package:project_management_app/screens/Home/cubit/image_slider_cubit_cubit.dart';
import 'package:project_management_app/theme/appcolors.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeBloc(apiNetworking: ApiNetworking())
                ..add(FetchProjects()), // أول Fetch
            ),
            BlocProvider(
              create: (context) => ImageSliderCubit(3),
            ),
          ],
          child: Builder(
            builder: (context) {
              return DefaultTabController(
                length: 3, // Number of tabs
                child: Scaffold(
                  backgroundColor: const Color(0x80e9e9e9),
                  body: RefreshIndicator(
                    // إضافة RefreshIndicator هنا
                    onRefresh: () async {
                      // استدعاء الـ HomeBloc لإعادة تحميل المشاريع
                      context.read<HomeBloc>().add(FetchProjects());
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          backgroundColor: const Color(0xff352197),
                          floating: true,
                          pinned: false,
                          actions: [
                            const Text(
                              'Home',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 180,
                            ),
                            Image.asset(
                              'assets/logo-h-white 2.png',
                              height: 20.h,
                              width: 28.w,
                            ),
                          ],
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              const Center(
                                  child: ImageSlider()), // Image Slider
                              SizedBox(height: 2.h),
                              _buildTabBar(context),
                              SizedBox(height: 2.h),
                              _buildTabContent(context), // Pass context here
                              const Divider(
                                height: 2,
                                thickness: 2,
                                color: Color.fromARGB(255, 245, 243, 243),
                              ),
                              const Botcamps(),
                              const Divider(
                                height: 2,
                                thickness: 2,
                                color: Color.fromARGB(255, 245, 243, 243),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Outstanding students ..',
                                    style: TextStyle(
                                      color: AppColors.blueLight,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              const Out_Standing_Student(),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.3.w),
      child: TabBar(
        indicator: BoxDecoration(
          color: AppColors.blueLight.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        dividerHeight: 0,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.blueDark,
        tabs: [
          _buildTab("All", context),
          _buildTab("Recent", context),
          _buildTab("Top", context),
        ],
      ),
    );
  }

  Widget _buildTab(String label, BuildContext context) {
    return Container(
      width: 100.w,
      height: 5.h,
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
        horizontal: 2.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.sp),
      ),
      child: Text(
        textAlign: TextAlign.center,
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: TabBarView(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllProjectsScreen()),
                      );
                    },
                    child: const Text(
                      "See more ..>",
                      style: TextStyle(
                        color: AppColors.blueDark,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent,
                      ),
                    );
                  } else if (state is HomeLoaded) {
                    return Column(
                      children: state.projects.take(4).map((project) {
                        return Projects(project: project);
                      }).toList(),
                    );
                  } else if (state is HomeError) {
                    return Center(
                      child: Text('Error: ${state.message}'),
                    );
                  }
                  return const Center(child: Text('No projects available.'));
                },
              ),
            ],
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightBlueAccent,
                  ),
                );
              } else if (state is HomeLoaded) {
                List<ProjectModel> recentProjects = state.projects;
                recentProjects.sort((a, b) => DateTime.parse(b.createAt!)
                    .compareTo(DateTime.parse(a.createAt!)));
                return Column(
                  children: recentProjects.take(4).map((project) {
                    return Projects(project: project);
                  }).toList(),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }
              return const Center(child: Text('No projects available.'));
            },
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightBlueAccent,
                  ),
                );
              } else if (state is HomeLoaded) {
                List<ProjectModel> topProjects = state.projects;
                topProjects.sort((a, b) => b.rating!.compareTo(a.rating!));
                return Column(
                  children: topProjects.take(4).map((project) {
                    return Projects(project: project);
                  }).toList(),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }
              return const Center(child: Text('No projects available.'));
            },
          ),
        ],
      ),
    );
  }
}
