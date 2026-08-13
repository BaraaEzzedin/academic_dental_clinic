import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/case_media_entity.dart';
import '../manager/case_details/case_details_cubit.dart';
import '../models/diagnostic_media_item.dart';
import 'diagnostic_media_thumbnail.dart';
import 'media_section_card.dart';
import 'upload_media/upload_media_sheet.dart';

class DiagnosticMediaCard extends StatelessWidget {
  const DiagnosticMediaCard({
    super.key,
    required this.media,
    required this.caseId,
    this.canUpload = false,
  });

  final List<CaseMediaEntity> media;
  final int caseId;

  /// Whether the case is in treatment and therefore accepts new media.
  /// When `false` the section is read-only (no upload actions).
  final bool canUpload;

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (media.isEmpty) {
      body = canUpload
          ? const MediaEmptyState()
          : Text('No diagnostic media yet.', style: AppTextStyles.subtitle);
    } else {
      body = SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: media.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.md),
          itemBuilder: (context, index) =>
              DiagnosticMediaThumbnail(item: _toItem(media[index])),
        ),
      );
    }
    return MediaSectionCard(
      title: 'Diagnostic Media',
      body: body,
      onAddMedia: canUpload ? () => _onAddMedia(context) : null,
    );
  }

  Future<void> _onAddMedia(BuildContext context) async {
    // Capture the cubit before awaiting so we can refresh regardless of
    // widget rebuilds triggered by the reload.
    final cubit = context.read<CaseDetailsCubit>();
    final uploaded = await showUploadMediaSheet(context, caseId: caseId);
    if (uploaded != true || !context.mounted) return;
    AppSnackBar.showSuccess(context, 'Media uploaded successfully');
    await cubit.load(caseId);
  }

  DiagnosticMediaItem _toItem(CaseMediaEntity item) {
    return DiagnosticMediaItem(
      label: item.description,
      date: item.takenAt != null
          ? DateFormatter.toMediumDate(item.takenAt!)
          : '',
      imageUrl: item.url.isEmpty ? null : item.url,
    );
  }
}