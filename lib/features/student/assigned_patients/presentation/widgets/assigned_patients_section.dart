import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/view_all_button.dart';
import '../../domain/use_cases/get_assigned_cases_use_case.dart';
import '../manager/assigned_patients/assigned_patients_cubit.dart';
import '../manager/assigned_patients/assigned_patients_state.dart';
import '../navigation/open_patient_case.dart';
import '../screens/assigned_patients_screen.dart';
import 'assigned_patient_card.dart';
import 'assigned_patients_shimmer.dart';

class AssignedPatientsSection extends StatelessWidget {
  const AssignedPatientsSection({super.key});

  static const int _previewLimit = 3;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssignedPatientsCubit>(
      create: (_) => AssignedPatientsCubit(sl<GetAssignedCasesUseCase>())
        ..loadAssignedPatients(),
      child: BlocBuilder<AssignedPatientsCubit, AssignedPatientsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Assigned Patients',
                      style: AppTextStyles.sectionTitle,
                    ),
                  ),
                  if (state.hasPatients)
                    ViewAllButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AssignedPatientsScreen(),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _SectionContent(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent({required this.state});

  final AssignedPatientsState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
        child: AssignedPatientsShimmer(),
      );
    }
    if (state.hasError) {
      return _CompactError(
        message: state.errorMessage ?? 'Failed to load assigned patients.',
        onRetry: context.read<AssignedPatientsCubit>().loadAssignedPatients,
      );
    }
    if (state.isEmpty) {
      return const _CompactEmpty();
    }

    final patients =
        state.patients.take(AssignedPatientsSection._previewLimit).toList();

    return SizedBox(
      height: AssignedPatientCard.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: patients.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimensions.md),
        itemBuilder: (context, index) {
          final patient = patients[index];
          return AssignedPatientCard(
            patient: patient,
            onViewDetails: () => openAssignedPatientCase(context, patient),
          );
        },
      ),
    );
  }
}


class _CompactEmpty extends StatelessWidget {
  const _CompactEmpty();

  @override
  Widget build(BuildContext context) {
    return _MessageBox(
      icon: Icons.people_outline_rounded,
      iconColor: AppColors.textHint,
      child: Text(
        'No assigned patients yet.',
        style: AppTextStyles.subtitle,
      ),
    );
  }
}


class _CompactError extends StatelessWidget {
  const _CompactError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _MessageBox(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      child: Row(
        children: [
          Expanded(
            child: Text(message, style: AppTextStyles.subtitle),
          ),
          const SizedBox(width: AppDimensions.sm),
          TextButton.icon(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: AppDimensions.xs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppTextStyles.viewDetailsButton,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}


class _MessageBox extends StatelessWidget {
  const _MessageBox({
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}