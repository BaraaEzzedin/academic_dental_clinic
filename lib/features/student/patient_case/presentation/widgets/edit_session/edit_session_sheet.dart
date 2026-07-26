import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../models/session.dart';
import 'clinical_notes_field.dart';
import 'completed_item_card.dart';
import 'edit_session_footer.dart';
import 'edit_session_header.dart';
import 'treatment_item_card.dart';

class EditSessionResult {
  const EditSessionResult({required this.treatmentItems, required this.note});

  final List<SessionTreatmentItem> treatmentItems;
  final String note;
}

// Opens the "Edit Session" bottom sheet and resolves with the edited values,
// or `null` if the student cancels / dismisses it.
Future<EditSessionResult?> showEditSessionSheet(
  BuildContext context, {
  required Session session,
}) {
  return showModalBottomSheet<EditSessionResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditSessionSheet(session: session),
  );
}

class EditSessionSheet extends StatefulWidget {
  const EditSessionSheet({super.key, required this.session});

  final Session session;

  @override
  State<EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends State<EditSessionSheet> {
  late final List<SessionTreatmentItem> _items =
      List.of(widget.session.treatmentItems);
  late final TextEditingController _noteController =
      TextEditingController(text: widget.session.note ?? '');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _setStatus(int index, SessionStatus status) {
    setState(() => _items[index] = _items[index].copyWith(status: status));
  }

  // Simulates the "end session" backend request. Replace the delay with the
  // real repository call once the endpoint exists.
  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    // TODO(backend): await repository.completeSession(sessionId, ...).
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pop(
      EditSessionResult(
        treatmentItems: List.of(_items),
        note: _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Active items stay editable; completed ones move to a read-only section.
    final active = <MapEntry<int, SessionTreatmentItem>>[];
    final completed = <SessionTreatmentItem>[];
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].status == SessionStatus.completed) {
        completed.add(_items[i]);
      } else {
        active.add(MapEntry(i, _items[i]));
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Grabber(),
            EditSessionHeader(
              title: widget.session.title,
              date: widget.session.date,
              onClose:
                  _isSubmitting ? null : () => Navigator.of(context).pop(),
            ),
            const Divider(height: 1, color: AppColors.dividerLine),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (active.isNotEmpty) ...[
                      const _SectionHeader(
                        icon: Icons.checklist_rounded,
                        title: 'Treatment Items',
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        'Teeth are set by the treatment plan — update the '
                        'status of each item.',
                        style: AppTextStyles.subtitle
                            .copyWith(color: AppColors.textHint),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      for (var j = 0; j < active.length; j++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                j == active.length - 1 ? 0 : AppDimensions.lg,
                          ),
                          child: TreatmentItemCard(
                            item: active[j].value,
                            onStatusChanged: (status) =>
                                _setStatus(active[j].key, status),
                          ),
                        ),
                      const SizedBox(height: AppDimensions.xl),
                    ],
                    if (completed.isNotEmpty) ...[
                      const _SectionHeader(
                        icon: Icons.verified_rounded,
                        title: 'Completed Treatment Items',
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        'Finished treatment work — read-only and preserved '
                        'for historical reference.',
                        style: AppTextStyles.subtitle
                            .copyWith(color: AppColors.textHint),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      for (var k = 0; k < completed.length; k++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: k == completed.length - 1
                                ? 0
                                : AppDimensions.lg,
                          ),
                          child: CompletedItemCard(item: completed[k]),
                        ),
                      const SizedBox(height: AppDimensions.xl),
                    ],
                    const _SectionHeader(
                      icon: Icons.notes_rounded,
                      title: 'Clinical Notes',
                    ),
                    const SizedBox(height: AppDimensions.md),
                    ClinicalNotesField(controller: _noteController),
                  ],
                ),
              ),
            ),
            EditSessionFooter(
              onCancel: () => Navigator.of(context).pop(),
              onUpdate: _submit,
              isSubmitting: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.md),
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.indicatorInactive,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppDimensions.sm),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}