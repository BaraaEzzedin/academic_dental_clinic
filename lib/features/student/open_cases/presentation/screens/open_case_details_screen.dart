import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/entities/open_case_details_entity.dart';
import '../../domain/entities/open_case_entity.dart';
import '../manager/open_case_details/open_case_details_cubit.dart';
import '../manager/open_case_details/open_case_details_state.dart';
import '../widgets/open_case_details_content.dart';
import '../widgets/open_case_details_empty_view.dart';
import '../widgets/open_case_details_shimmer.dart';


class OpenCaseDetailsScreen extends StatelessWidget {
  const OpenCaseDetailsScreen({super.key, required this.openCase});

  final OpenCaseEntity openCase;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OpenCaseDetailsCubit>(
      create: (_) => OpenCaseDetailsCubit()..load(openCase),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.screenHorizontalPadding,
                  AppDimensions.lg,
                  AppDimensions.screenHorizontalPadding,
                  AppDimensions.lg,
                ),
                child: CaseDetailsTopBar(title: 'Open Case Details'),
              ),
              Expanded(
                child: BlocBuilder<OpenCaseDetailsCubit, OpenCaseDetailsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const OpenCaseDetailsShimmer();
                    }
                    if (state.hasError) {
                      return ErrorRetryView(
                        message: state.errorMessage ??
                            'Could not load case details.',
                        onRetry: () =>
                            context.read<OpenCaseDetailsCubit>().load(openCase),
                      );
                    }
                    final details = state.details;
                    if (details == null) {
                      return const OpenCaseDetailsEmptyView();
                    }
                    return OpenCaseDetailsContent(
                      details: details,
                      onStartExamination: () =>
                          _onStartExamination(context, details),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onStartExamination(
    BuildContext context,
    OpenCaseDetailsEntity details,
  ) {
    // TODO(examination): navigate to the initial patient examination /
    // appointment scheduling flow once it exists, e.g.:
    //   Navigator.of(context).push(
    //     MaterialPageRoute<void>(
    //       builder: (_) => InitialExaminationScreen(caseId: details.id),
    //     ),
    //   );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Initial patient examination flow coming soon.'),
        ),
      );
  }
}