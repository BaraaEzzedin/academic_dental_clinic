import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/case_subject_entity.dart';
import 'subject_filter_chip.dart';

class SubjectFilterList extends StatelessWidget {
  const SubjectFilterList({
    super.key,
    required this.subjects,
    required this.selectedId,
    required this.onSelected,
  });

  final List<CaseSubjectEntity> subjects;
  final int? selectedId;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontalPadding,
        ),
        itemCount: subjects.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return SubjectFilterChip(
            label: subject.name,
            selected: subject.id == selectedId,
            onTap: () => onSelected(subject.id),
          );
        },
      ),
    );
  }
}