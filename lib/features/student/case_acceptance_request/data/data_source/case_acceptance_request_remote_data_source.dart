import '../../../../../core/network/api_client.dart';
import '../models/available_procedure_model.dart';
import '../models/case_acceptance_request_model.dart';

abstract class CaseAcceptanceRequestRemoteDataSource {
  Future<List<AvailableProcedureModel>> getAvailableProcedures(int subjectId);

  Future<void> submitAcceptanceRequest(CaseAcceptanceRequestModel request);
}

class CaseAcceptanceRequestRemoteDataSourceImpl
    implements CaseAcceptanceRequestRemoteDataSource {
  const CaseAcceptanceRequestRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<AvailableProcedureModel>> getAvailableProcedures(
    int subjectId,
  ) async {
    // TODO(backend): replace the mock below with the real request once the
    // subject-procedures endpoint is ready:
    //
    //   final response = await apiClient.get<Map<String, dynamic>>(
    //     '/subjects/$subjectId/procedures',
    //   );
    //   final data = response.data?['data'] as Map<String, dynamic>?;
    //   final procedures = data?['procedures'] as List<dynamic>? ?? const [];
    //   return procedures
    //       .map((e) => AvailableProcedureModel.fromJson(e as Map<String, dynamic>))
    //       .toList();
    //
    // Wrap the call in `try { ... } on DioException catch (e) { throw
    // mapDioException(e); }` exactly like PatientsRemoteDataSourceImpl.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockProcedures;
  }

  @override
  Future<void> submitAcceptanceRequest(
    CaseAcceptanceRequestModel request,
  ) async {
    // TODO(backend): replace the mock below with the real request once the
    // acceptance-request endpoint is ready:
    //
    //   await apiClient.post<Map<String, dynamic>>(
    //     '/case-acceptance-requests',
    //     data: request.toJson(),
    //   );
    //
    // Wrap in `try/on DioException` and rethrow via `mapDioException`.
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  // Mock catalogue shared across subjects until the backend is wired in.
  static const _mockProcedures = <AvailableProcedureModel>[
    AvailableProcedureModel(id: 1, name: 'Composite restoration'),
    AvailableProcedureModel(id: 2, name: 'Amalgam restoration'),
    AvailableProcedureModel(id: 3, name: 'Root canal treatment'),
    AvailableProcedureModel(id: 4, name: 'Crown'),
    AvailableProcedureModel(id: 5, name: 'Bridge'),
    AvailableProcedureModel(id: 6, name: 'Extraction'),
    AvailableProcedureModel(id: 7, name: 'Dental implant'),
    AvailableProcedureModel(id: 8, name: 'Scaling & polishing'),
    AvailableProcedureModel(id: 9, name: 'Veneer'),
    AvailableProcedureModel(id: 10, name: 'Temporary restoration'),
  ];
}