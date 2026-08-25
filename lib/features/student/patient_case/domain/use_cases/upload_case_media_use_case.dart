import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/case_media_upload.dart';
import '../repositories/case_details_repository.dart';

class UploadCaseMediaUseCase extends UseCase<Unit, UploadCaseMediaParams> {
  UploadCaseMediaUseCase(this.repository);

  final CaseDetailsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(UploadCaseMediaParams params) {
    return repository.uploadCaseMedia(
      caseId: params.caseId,
      items: params.items,
    );
  }
}

class UploadCaseMediaParams extends Equatable {
  const UploadCaseMediaParams({
    required this.caseId,
    required this.items,
  });

  final int caseId;
  final List<CaseMediaUpload> items;

  @override
  List<Object?> get props => [caseId, items];
}