import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import 'assigned_patient_list_card.dart';


class AssignedPatientsListView extends StatelessWidget {
  const AssignedPatientsListView({
    super.key,
    required this.patients,
    this.onViewDetails,
  });

  final List<AssignedPatientEntity> patients;
  final void Function(AssignedPatientEntity patient)? onViewDetails;

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return const AssignedPatientsEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontalPadding,
        vertical: AppDimensions.lg,
      ),
      itemCount: patients.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppDimensions.lg),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return AssignedPatientListCard(
          patient: patient,
          onViewDetails:
              onViewDetails == null ? null : () => onViewDetails!(patient),
        );
      },
    );
  }
}

class AssignedPatientsEmptyState extends StatelessWidget {
  const AssignedPatientsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.people_outline_rounded,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppDimensions.md),
          Text('No assigned patients yet.', style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}