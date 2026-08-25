import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../domain/use_cases/analyze_image_use_case.dart';
import '../manager/ai_analysis/ai_analysis_cubit.dart';
import '../manager/ai_analysis/ai_analysis_state.dart';
import '../widgets/ai_analysis_shimmer.dart';
import '../widgets/ai_findings_view.dart';
import '../widgets/ai_image_picker_area.dart';
import '../widgets/ai_section_header.dart';
import '../widgets/ai_source_picker.dart';

class AiAnalysisScreen extends StatelessWidget {
  const AiAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AiAnalysisCubit>(
      create: (_) => AiAnalysisCubit(analyzeImage: sl<AnalyzeImageUseCase>()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.topBarBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
          title: const Text('AI Assistant', style: AppTextStyles.topBarTitle),
        ),
        body: SafeArea(
          child: BlocBuilder<AiAnalysisCubit, AiAnalysisState>(
            builder: (context, state) {
              final cubit = context.read<AiAnalysisCubit>();
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontalPadding,
                  vertical: AppDimensions.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.hasImage) ...[
                      const AiSectionHeader(
                        title: 'Selected Image',
                        icon: Icons.photo_rounded,
                      ),
                      const SizedBox(height: AppDimensions.md),
                    ],
                    AiImagePickerArea(
                      imagePath: state.imagePath,
                      enabled: !state.isAnalyzing,
                      onPick: () => _pickImage(context, cubit),
                    ),
                    if (state.hasImage) ...[
                      const SizedBox(height: AppDimensions.lg),
                      AppPrimaryButton(
                        label: state.isAnalyzing
                            ? 'Analyzing...'
                            : 'Analyze with AI',
                        trailingIcon: Icons.auto_awesome_rounded,
                        isLoading: state.isAnalyzing,
                        onPressed: cubit.analyze,
                      ),
                    ],
                    _buildResultSection(context, state, cubit),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultSection(
    BuildContext context,
    AiAnalysisState state,
    AiAnalysisCubit cubit,
  ) {
    switch (state.status) {
      case AiAnalysisStatus.analyzing:
        return const Padding(
          padding: EdgeInsets.only(top: AppDimensions.xl),
          child: AiAnalysisShimmer(),
        );
      case AiAnalysisStatus.success:
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.xl),
          child: AiFindingsView(result: state.result!),
        );
      case AiAnalysisStatus.failure:
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.xl),
          child: _ErrorCard(
            message: state.errorMessage ?? 'Unable to analyze image.',
            onRetry: cubit.analyze,
          ),
        );
      case AiAnalysisStatus.idle:
        return const SizedBox.shrink();
    }
  }

  Future<void> _pickImage(BuildContext context, AiAnalysisCubit cubit) async {
    final source = await showAiImageSourcePicker(context);
    if (source == null) return;
    await cubit.pickImage(source);
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 40, color: AppColors.error),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Unable to analyze image.',
            style: AppTextStyles.sectionTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            message,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.lg),
          AppPrimaryButton(
            label: 'Retry Analysis',
            trailingIcon: Icons.refresh_rounded,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
