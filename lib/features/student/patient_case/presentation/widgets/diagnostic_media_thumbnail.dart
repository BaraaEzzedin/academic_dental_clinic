import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/diagnostic_media_item.dart';

class DiagnosticMediaThumbnail extends StatelessWidget {
  const DiagnosticMediaThumbnail({
    super.key,
    required this.item,
    this.width = 200,
  });

  final DiagnosticMediaItem item;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: MediaImage(imageUrl: item.imageUrl),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            '${item.label} - ${item.date}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.mediaCaption,
          ),
        ],
      ),
    );
  }
}

class MediaImage extends StatelessWidget {
  const MediaImage({super.key,this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const MediaPlaceholder(),
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : const MediaPlaceholder(),
      );
    }
    return const MediaPlaceholder();
  }
}

class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mediaBackground,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.logoBorder,
        size: 36,
      ),
    );
  }
}