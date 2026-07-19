import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/assigned_patient.dart';
import 'patient_card.dart';


class PatientListView extends StatelessWidget {
  const PatientListView({
    super.key,
    required this.patients,
    this.onViewDetails,
  });

  final List<AssignedPatient> patients;
  final void Function(AssignedPatient patient)? onViewDetails;

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return const _EmptyState();
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
        return PatientCard(
          patient: patient,
          onViewDetails:
              onViewDetails == null ? null : () => onViewDetails!(patient),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.people_outline,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppDimensions.md),
          Text('No patients in this category', style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}