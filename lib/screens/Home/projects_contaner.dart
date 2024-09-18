import 'package:flutter/material.dart';
import 'package:project_management_app/models/project_model.dart';
import 'package:project_management_app/screens/Project/project_details_screen.dart';
import 'package:sizer/sizer.dart';

import '../../theme/appcolors.dart';

class Projects extends StatelessWidget {
  final ProjectModel project;

  const Projects({
    super.key,
    required this.project,
    // required this.projectName,
    // required this.bootcampName,
    // required this.type,
    // required this.image
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to Project Details Screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         ProjectDetailsScreen(),
        //   ),
        // );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 1.4.h, left: 5.w, right: 1.4.w),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                height: 13.h,
                width: 13.h,
                decoration: BoxDecoration(
                  color: AppColors.blueDark,
                  borderRadius: BorderRadius.circular(1.4.h),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1.4,
                      blurRadius: 3.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: (project.logoUrl == null || project.logoUrl == 'null')
                      ? const Icon(
                          Icons.image,
                          size: 28,
                          color: Colors.white,
                        )
                      : Image.network(
                          project.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image,
                              size: 28,
                              color: Colors.white,
                            );
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                ),
              ),
            ),
            SizedBox(width: 3.5.w),
            Flexible(
              flex: 7,
              child: Container(
                height: 14.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.4.h),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1.4,
                      blurRadius: 3.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 10,
                            child: Text(
                              'Project Name: ${project.projectName}',
                              style: TextStyle(
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.4.sp,
                              ),
                            ),
                          ),
                          Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  color: AppColors.blueDark,
                                  borderRadius: BorderRadius.circular(3)),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blueDark,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3))),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailsScreen(
                                          project: project,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  )))
                        ],
                      ),
                      SizedBox(height: 0.7.h),
                      Text(
                        "Bootcamp: ${project.bootcampName}",
                        style: TextStyle(fontSize: 7.sp, color: AppColors.grey),
                      ),
                      SizedBox(height: 0.7.h),
                      Text(
                        "Type: ${project.type}",
                        style: TextStyle(fontSize: 7.sp, color: AppColors.grey),
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
}
