import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../../../core/widgets/sheet_grabber.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../domain/entities/available_procedure_entity.dart';
import '../manager/case_acceptance_request/case_acceptance_request_cubit.dart';
import '../manager/case_acceptance_request/case_acceptance_request_state.dart';

Future<void> showProcedurePickerSheet(
  BuildContext context, {
  required CaseAcceptanceRequestCubit cubit,
  required int toothNumber,
}) {
  cubit.loadProcedures();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _ProcedurePickerSheet(toothNumber: toothNumber),
    ),
  );
}

class _ProcedurePickerSheet extends StatelessWidget {
  const _ProcedurePickerSheet({required this.toothNumber});

  final int toothNumber;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const Center(child: SheetGrabber()),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.xl,
                  AppDimensions.lg,
                  AppDimensions.xl,
                  AppDimensions.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tooth #$toothNumber',
                              style: AppTextStyles.sectionTitle),
                          const SizedBox(height: 2),
                          Text('Select a procedure',
                              style: AppTextStyles.helperText),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.dividerLine),
              Expanded(
                child: BlocBuilder<CaseAcceptanceRequestCubit,
                    CaseAcceptanceRequestState>(
                  builder: (context, state) {
                    if (state.isLoadingProcedures) {
                      return const _ProcedureListShimmer();
                    }
                    if (state.hasProceduresError) {
                      return ErrorRetryView(
                        message: state.proceduresError ??
                            'Could not load procedures.',
                        onRetry: () => context
                            .read<CaseAcceptanceRequestCubit>()
                            .loadProcedures(force: true),
                      );
                    }
                    if (state.proceduresStatus == ProceduresStatus.empty) {
                      return const _EmptyProcedures();
                    }
                    final selectedId = state.selections[toothNumber]?.id;
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.xl,
                        AppDimensions.lg,
                        AppDimensions.xl,
                        AppDimensions.xl,
                      ),
                      itemCount: state.procedures.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppDimensions.sm),
                      itemBuilder: (context, index) {
                        final procedure = state.procedures[index];
                        return _ProcedureTile(
                          procedure: procedure,
                          selected: procedure.id == selectedId,
                          onTap: () {
                            context
                                .read<CaseAcceptanceRequestCubit>()
                                .assignProcedure(toothNumber, procedure);
                            Navigator.of(context).maybePop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProcedureTile extends StatelessWidget {
  const _ProcedureTile({
    required this.procedure,
    required this.selected,
    required this.onTap,
  });

  final AvailableProcedureEntity procedure;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.fieldFill,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.fieldBorder,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      procedure.name,
                      style: AppTextStyles.caseProcedure.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (procedure.description != null &&
                        procedure.description!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(procedure.description!,
                          style: AppTextStyles.helperText),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? AppColors.primary : AppColors.indicatorInactive,
                size: AppDimensions.iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyProcedures extends StatelessWidget {
  const _EmptyProcedures();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.medical_services_outlined,
                size: 44, color: AppColors.indicatorInactive),
            const SizedBox(height: AppDimensions.md),
            Text(
              'No procedures available for this subject.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcedureListShimmer extends StatelessWidget {
  const _ProcedureListShimmer();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.xl,
          AppDimensions.lg,
          AppDimensions.xl,
          AppDimensions.xl,
        ),
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.sm),
        itemBuilder: (_, _) => const ShimmerBox(
          width: double.infinity,
          height: 52,
          borderRadius: AppDimensions.radiusMd,
        ),
      ),
    );
  }
}