import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/widgets/error_retry_view.dart';
import '../../../../../../core/widgets/sheet_grabber.dart';
import '../../../../../../core/widgets/shimmer_loading.dart';
import '../../../domain/entities/material_entity.dart';

/// Multi-select materials picker, modeled on the add-patient subject selector:
/// a field-styled trigger box that opens a bottom sheet whose tiles toggle
/// selection (a checkmark on every selected item).
class MaterialsSelector extends StatelessWidget {
  const MaterialsSelector({
    super.key,
    required this.materials,
    required this.selectedIds,
    required this.isLoading,
    required this.hasError,
    required this.onToggle,
    required this.onRetry,
  });

  final List<MaterialEntity> materials;
  final Set<int> selectedIds;
  final bool isLoading;
  final bool hasError;
  final ValueChanged<int> onToggle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final selected =
        materials.where((m) => selectedIds.contains(m.id)).toList();
    final selectedNames = selected.map((m) => m.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Materials', style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppDimensions.sm),
        if (isLoading)
          const ShimmerLoading(
            child: ShimmerBox(
              height: 56,
              borderRadius: AppDimensions.radiusMd,
            ),
          )
        else if (hasError)
          ErrorRetryView(
            message: 'Could not load materials.',
            onRetry: onRetry,
          )
        else
          InkWell(
            onTap: materials.isEmpty ? null : () => _openSheet(context),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.science_outlined,
                      color: AppColors.textSecondary,
                      size: AppDimensions.iconSize),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Text(
                      selectedNames.isEmpty
                          ? 'Select materials'
                          : selectedNames.join(', '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: selectedNames.isEmpty
                          ? AppTextStyles.hint
                          : AppTextStyles.input,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        if (selected.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: [
              for (final material in selected)
                _MaterialChip(
                  label: material.name,
                  onRemove: () => onToggle(material.id),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _openSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      builder: (_) => _MaterialsSheet(
        materials: materials,
        initialSelected: selectedIds,
        onToggle: onToggle,
      ),
    );
  }
}

class _MaterialsSheet extends StatefulWidget {
  const _MaterialsSheet({
    required this.materials,
    required this.initialSelected,
    required this.onToggle,
  });

  final List<MaterialEntity> materials;
  final Set<int> initialSelected;
  final ValueChanged<int> onToggle;

  @override
  State<_MaterialsSheet> createState() => _MaterialsSheetState();
}

class _MaterialsSheetState extends State<_MaterialsSheet> {
  late final Set<int> _selected = {...widget.initialSelected};

  void _toggle(int id) {
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
    widget.onToggle(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetGrabber(),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Row(
              children: [
                Text('Select Materials', style: AppTextStyles.sectionTitle),
                const Spacer(),
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
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
              itemCount: widget.materials.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.dividerLine),
              itemBuilder: (context, index) {
                final material = widget.materials[index];
                final selected = _selected.contains(material.id);
                return ListTile(
                  title:
                      Text(material.name, style: AppTextStyles.caseProcedure),
                  trailing: selected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary)
                      : const Icon(Icons.circle_outlined,
                          color: AppColors.textHint),
                  onTap: () => _toggle(material.id),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.md),
        ],
      ),
    );
  }
}

/// A compact, removable chip for a selected material.
class _MaterialChip extends StatelessWidget {
  const _MaterialChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppDimensions.md,
        right: AppDimensions.sm,
        top: AppDimensions.xs,
        bottom: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.xs),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            child: const Icon(
              Icons.close_rounded,
              size: 15,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
