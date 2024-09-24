import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/screens/All_projects/bloc/all_projects_bloc_bloc.dart';
import 'package:project_management_app/screens/Home/projects_contaner.dart';
import 'package:project_management_app/screens/Supervisor/add_project_screen.dart';
import 'package:project_management_app/theme/appcolors.dart';
import 'package:sizer/sizer.dart';

class AllProjectsScreen extends StatelessWidget {
  const AllProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AllProjectsBloc(ApiNetworking())..add(FetchAllProjectsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              // إعادة تحميل المشاريع عند السحب لتحديث
              context.read<AllProjectsBloc>().add(FetchAllProjectsEvent());
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: const Color(0x80e9e9e9),
                  expandedHeight: 100.0,
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'All Projects',
                      style: TextStyle(color: AppColors.white),
                    ),
                    background: Container(color: AppColors.blueDark),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProjectScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.sp),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<AllProjectsBloc, AllProjectsState>(
                  builder: (context, state) {
                    if (state is AllProjectsLoading) {
                      return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is AllProjectsError) {
                      return SliverToBoxAdapter(
                        child: Center(child: Text('Error: ${state.message}')),
                      );
                    } else if (state is AllProjectsLoaded) {
                      if (state.projects.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(child: Text('No projects available.')),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final project = state.projects[index];
                            return Projects(project: project);
                          },
                          childCount: state.projects.length,
                        ),
                      );
                    }
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('No data')),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 14.h, // Adjust height as needed
                    child: Center(
                      child: Text(
                        'End of Projects',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
