import 'package:flutter/material.dart';
import 'package:project_management_app/theme/appcolors.dart';
import 'package:sizer/sizer.dart'; // التأكد من إضافة مكتبة Sizer

class Botcamps extends StatelessWidget {
  const Botcamps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0x20e9e9e9),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // العنوان
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "New programs..",
                style: TextStyle(
                  color: AppColors.blueLight,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "See more ..>",
                style: TextStyle(
                  color: AppColors.blueDark,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildCampContainer(
                  campName: "Flutter Bootcamp",
                  date: "Start: 12/10/2024",
                  duration: "Duration: 3 months",
                  imageUrl: 'assets/1_5-aoK8IBmXve5whBQM90GA.png',
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          Row(
            children: [
              Expanded(
                child: _buildCampContainer(
                  campName: "Java Bootcamp",
                  date: "Start: 05/11/2024",
                  duration: "Duration: 2 months",
                  imageUrl: 'assets/Java-Logo.png', // صورة مخصصة للـ AI بوتكامب
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCampContainer({
    required String campName,
    required String date,
    required String duration,
    required String imageUrl,
  }) {
    return Container(
      height: 15.h,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffabadf5),
            spreadRadius: 5,
            blurRadius: 0,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // الصورة الدائرية
          Padding(
            padding: EdgeInsets.all(2.w),
            child: CircleAvatar(
              radius: 8.w,
              backgroundImage: AssetImage(imageUrl), // استخدام الصورة المخصصة
            ),
          ),
          // معلومات المعسكر
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 2.h), // استخدام Sizer للتحكم بالمسافات
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campName,
                    style: TextStyle(
                      color: AppColors.blueLight,
                      fontSize: 12.sp, // استخدام Sizer للتحكم بحجم النص
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h), // مسافة بين النصوص باستخدام Sizer
                  Text(
                    date,
                    style: TextStyle(
                      color: AppColors.blueDark,
                      fontSize: 11.sp, // استخدام Sizer للتحكم بحجم النص
                    ),
                  ),
                  SizedBox(height: 1.h), // مسافة بين النصوص باستخدام Sizer
                  Text(
                    duration,
                    style: TextStyle(
                      color: AppColors.blueDark,
                      fontSize: 10.sp, // استخدام Sizer للتحكم بحجم النص
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
