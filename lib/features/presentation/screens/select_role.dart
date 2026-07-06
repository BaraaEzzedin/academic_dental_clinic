import 'package:academic_dental_clinic/core/constants/app_colors.dart';
import 'package:academic_dental_clinic/core/constants/app_dimensions.dart';
import 'package:academic_dental_clinic/core/theme/app_text_style.dart';
import 'package:academic_dental_clinic/features/presentation/screens/Patient_login.dart';
import 'package:academic_dental_clinic/features/presentation/screens/staff_login.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/logo_section.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/role_card.dart';
import 'package:flutter/material.dart';

class SelectRole extends StatelessWidget {
  const SelectRole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: AppDimensions.xxl,
                ),
                child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: AppDimensions.lg,
            width: AppDimensions.maxContentWidth,
          ),
          LogoSection(),
          SizedBox(height: AppDimensions.xl,),
          Text("Dental Excellence and Education" , textAlign:  TextAlign.center, style: AppTextStyles.appDefinition,),
          SizedBox(height: AppDimensions.xxl,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Please select your role" ,
              style: AppTextStyles.hint,),
          ),
          SizedBox(height: AppDimensions.lg,),
          RoleCard(icon: Icons.school_outlined, title: "Student", description: "Access your clinic cases and curriculum", onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const StaffLogin()),
                );
            }
            ),
          SizedBox(
            height: AppDimensions.xl,
          ),
            RoleCard(icon: Icons.local_hospital_outlined, title: "Patient", description: "View your appointments and records", onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PatientLogin()),
              );
            }
            ),
          SizedBox(
            height: AppDimensions.xl,
          ),
          RoleCard(icon: Icons.gpp_good_outlined, title: "Supervisor", description: "Review clinical progress and approvals", onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const StaffLogin()),
            );
          }
          ),
        ],
                ),
              ),
      ),
    );
  }
}
