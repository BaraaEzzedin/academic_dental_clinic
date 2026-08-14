import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/material_model.dart';

abstract class MaterialsRemoteDataSource {
  /// Fetches the materials available for the subject [subjectId].
  Future<List<MaterialModel>> getMaterials(int subjectId);
}

class MaterialsRemoteDataSourceImpl implements MaterialsRemoteDataSource {
  const MaterialsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<MaterialModel>> getMaterials(int subjectId) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.subjectMaterials(subjectId),
      );
      // Envelope: data is an object holding the `materials` list.
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      final materials = data['materials'] as List<dynamic>? ?? const [];
      return materials
          .whereType<Map<String, dynamic>>()
          .map(MaterialModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse materials: $e');
    }
  }
}
