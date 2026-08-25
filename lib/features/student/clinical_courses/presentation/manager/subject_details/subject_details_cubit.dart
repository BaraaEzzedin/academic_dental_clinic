import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_subject_details_use_case.dart';
import 'subject_details_state.dart';

class SubjectDetailsCubit extends Cubit<SubjectDetailsState> {
  SubjectDetailsCubit(this._getSubjectDetails)
      : super(const SubjectDetailsState());

  final GetSubjectDetailsUseCase _getSubjectDetails;

  /// Loads the progress details for the subject [subjectId].
  Future<void> load(int subjectId) async {
    emit(state.copyWith(status: SubjectDetailsStatus.loading));
    final result = await _getSubjectDetails(subjectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubjectDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          status: SubjectDetailsStatus.loaded,
          details: details,
        ),
      ),
    );
  }
}
