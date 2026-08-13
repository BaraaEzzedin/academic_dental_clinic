import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../../domain/entities/walk_in_request_entity.dart';
import '../models/walk_in_request_model.dart';

abstract class AddPatientRemoteDataSource {
  Future<void> createWalkInCase(WalkInRequestEntity request);
}

class AddPatientRemoteDataSourceImpl implements AddPatientRemoteDataSource {
  const AddPatientRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<void> createWalkInCase(WalkInRequestEntity request) async {
    try {
      // Backend contract:
      //   images -> one file part per selected case image (repeated field)
      //   data   -> JSON string of the whole request (patient/caseInfo/appointment)
      final formData = FormData();
      for (final path in request.imagePaths) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              path,
              filename: path.split(RegExp(r'[\\/]')).last,
            ),
          ),
        );
      }
      final dataJson = jsonEncode(WalkInRequestModel(request).toDataJson());
      // Dio's LogInterceptor prints FormData as "Instance of 'FormData'", so
      // log the actual `data` payload here to make it verifiable.
      if (kDebugMode) {
        developer.log(dataJson, name: 'WALK-IN');
      }
      formData.fields.add(MapEntry('data', dataJson));

      await apiClient.post<Map<String, dynamic>>(
        ApiConstants.walkInCase,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
