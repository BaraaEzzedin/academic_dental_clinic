import 'package:academic_dental_clinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../models/schedule_item.dart';
import '../widgets/home_header.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/today_schedule_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // data for ui , delete when back is ready
  static const List<ScheduleItem> _schedule = [
    ScheduleItem(
      patientName: 'Sara Mahmoud',
      subject: 'Periodontics',
      clinic: 'Clinic 1',
      startTime: '8:00',
      endTime: '9:00',
      status: ScheduleStatus.last,
    ),
    ScheduleItem(
      patientName: 'Ahmad Khaled',
      subject: 'Operative Dentistry',
      clinic: 'Clinic 4',
      startTime: '9:00',
      endTime: '11:00',
      status: ScheduleStatus.now,
    ),
    ScheduleItem(
      patientName: 'Lina Yousef',
      subject: 'Endodontics',
      clinic: 'Clinic 2',
      startTime: '11:30',
      endTime: '13:00',
      status: ScheduleStatus.next,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: AppDimensions.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeTopBar(studentName: 'Student name'),
              const SizedBox(height: AppDimensions.xl),
              const HomeHeader(
                date: 'MONDAY, OCT 23',
                greeting: 'Dr.Julian',
                summary: 'You have 3 clinical procedures scheduled for today.',
              ),
              const SizedBox(height: AppDimensions.xl),
              const TodayScheduleSection(items: _schedule),
            ],
          ),
        ),
      ),
    );
  }
}