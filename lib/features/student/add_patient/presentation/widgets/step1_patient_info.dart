import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../manager/add_patient/add_patient_cubit.dart';
import '../manager/add_patient/add_patient_state.dart';

/// Step 1 — patient personal + medical details, symptoms and chief complaint.
class Step1PatientInfo extends StatefulWidget {
  const Step1PatientInfo({super.key});

  @override
  State<Step1PatientInfo> createState() => _Step1PatientInfoState();
}

class _Step1PatientInfoState extends State<Step1PatientInfo> {
  late final AddPatientCubit _cubit = context.read<AddPatientCubit>();

  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  late final TextEditingController _allergies;
  late final TextEditingController _medicalHistory;
  late final TextEditingController _medications;
  late final TextEditingController _symptoms;
  late final TextEditingController _chiefComplaint;

  @override
  void initState() {
    super.initState();
    final info = _cubit.state.patientInfo;
    _fullName = TextEditingController(text: info.fullName);
    _phone = TextEditingController(text: info.phone);
    _allergies = TextEditingController(text: info.allergies);
    _medicalHistory = TextEditingController(text: info.medicalHistory);
    _medications = TextEditingController(text: info.currentMedications);
    _symptoms = TextEditingController(text: info.symptoms);
    _chiefComplaint = TextEditingController(text: info.chiefComplaint);
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _allergies.dispose();
    _medicalHistory.dispose();
    _medications.dispose();
    _symptoms.dispose();
    _chiefComplaint.dispose();
    super.dispose();
  }

  void _update() {
    final current = _cubit.state.patientInfo;
    _cubit.setPatientInfo(
      current.copyWith(
        fullName: _fullName.text,
        phone: _phone.text,
        allergies: _allergies.text,
        medicalHistory: _medicalHistory.text,
        currentMedications: _medications.text,
        symptoms: _symptoms.text,
        chiefComplaint: _chiefComplaint.text,
      ),
    );
  }

  Future<void> _pickDate() async {
    final current = DateTime.tryParse(_cubit.state.patientInfo.dateOfBirth);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) return;
    _cubit.setPatientInfo(
      _cubit.state.patientInfo.copyWith(dateOfBirth: DateFormatter.toIsoDate(picked)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        AppDimensions.lg,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        Text('Patient Information', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          label: 'Full Name',
          controller: _fullName,
          hintText: 'e.g. John Doe',
          prefixIcon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          onChanged: (_) => _update(),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          label: 'Phone',
          controller: _phone,
          hintText: 'e.g. 963933673475',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: (_) => _update(),
        ),
        const SizedBox(height: AppDimensions.lg),
        BlocBuilder<AddPatientCubit, AddPatientState>(
          buildWhen: (p, c) =>
              p.patientInfo.dateOfBirth != c.patientInfo.dateOfBirth ||
              p.patientInfo.gender != c.patientInfo.gender,
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateOfBirthField(
                value: state.patientInfo.dateOfBirth,
                onTap: _pickDate,
              ),
              const SizedBox(height: AppDimensions.lg),
              _GenderSelector(
                value: state.patientInfo.gender,
                onChanged: (gender) => _cubit.setPatientInfo(
                  _cubit.state.patientInfo.copyWith(gender: gender),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          label: 'Chief Complaint',
          controller: _chiefComplaint,
          hintText: 'e.g. Sharp pain in upper right',
          minLines: 2,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => _update(),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          label: 'Symptoms',
          controller: _symptoms,
          hintText: 'e.g. Gums bleed on brushing every day',
          minLines: 2,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => _update(),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          label: 'Allergies',
          controller: _allergies,
          hintText: 'e.g. Penicillin, Aspirin',
          minLines: 2,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => _update(),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          label: 'Medical History',
          controller: _medicalHistory,
          hintText: 'e.g. No significant medical history',
          minLines: 2,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => _update(),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          label: 'Current Medications',
          controller: _medications,
          hintText: 'e.g. Metformin 500mg',
          minLines: 2,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => _update(),
        ),
      ],
    );
  }
}

class _DateOfBirthField extends StatelessWidget {
  const _DateOfBirthField({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;
    final label = hasValue
        ? DateFormatter.mediumDateFromIso(value)
        : 'Select date of birth';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date of Birth', style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppDimensions.sm),
        InkWell(
          onTap: onTap,
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
                const Icon(Icons.cake_outlined,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconSize),
                const SizedBox(width: AppDimensions.md),
                Text(
                  label,
                  style: hasValue ? AppTextStyles.input : AppTextStyles.hint,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const List<String> _options = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppDimensions.sm),
        Row(
          children: [
            for (final option in _options) ...[
              if (option != _options.first)
                const SizedBox(width: AppDimensions.md),
              Expanded(
                child: _GenderChip(
                  label: option,
                  selected: value == option,
                  onTap: () => onChanged(option),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
