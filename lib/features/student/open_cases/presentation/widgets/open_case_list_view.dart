import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/open_case_entity.dart';
import 'open_case_card.dart';

class OpenCaseListView extends StatelessWidget {
  const OpenCaseListView({
    super.key,
    required this.cases,
    this.onViewDetails,
  });

  final List<OpenCaseEntity> cases;
  final void Function(OpenCaseEntity openCase)? onViewDetails;

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) {
      return const _EmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontalPadding,
        vertical: AppDimensions.lg,
      ),
      itemCount: cases.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppDimensions.lg),
      itemBuilder: (context, index) {
        final openCase = cases[index];
        return OpenCaseCard(
          openCase: openCase,
          onViewDetails:
              onViewDetails == null ? null : () => onViewDetails!(openCase),
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
            Icons.inbox_outlined,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'No open cases in this subject',
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}