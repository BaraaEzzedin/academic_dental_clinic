import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/data/datasources/auth/auth_local_data_source.dart';
import '../../features/data/datasources/auth/patient_auth_remote_data_source.dart';
import '../../features/data/datasources/auth/staff_auth_remote_data_source.dart';
import '../../features/data/repositories/patient_auth_repository_impl.dart';
import '../../features/data/repositories/staff_auth_repository_impl.dart';
import '../../features/domain/repositories/patient_auth_repository.dart';
import '../../features/domain/repositories/staff_auth_repository.dart';
import '../../features/domain/usecases/request_otp_use_case.dart';
import '../../features/domain/usecases/staff_login_use_case.dart';
import '../../features/domain/usecases/verify_otp_use_case.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  // ---------- External ----------
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ---------- Data sources ----------
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl<FlutterSecureStorage>()),
  );

  // ---------- Network ----------
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      interceptors: [
        AuthInterceptor(() => sl<AuthLocalDataSource>().getToken()),
      ],
    ),
  );

  sl.registerLazySingleton<StaffAuthRemoteDataSource>(
    () => StaffAuthRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<PatientAuthRemoteDataSource>(
    () => PatientAuthRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // ---------- Repositories ----------
  sl.registerLazySingleton<StaffAuthRepository>(
    () => StaffAuthRepositoryImpl(
      sl<StaffAuthRemoteDataSource>(),
      sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<PatientAuthRepository>(
    () => PatientAuthRepositoryImpl(
      sl<PatientAuthRemoteDataSource>(),
      sl<AuthLocalDataSource>(),
    ),
  );

  // ---------- Use cases ----------
  sl.registerFactory<StaffLoginUseCase>(
    () => StaffLoginUseCase(sl<StaffAuthRepository>()),
  );
  sl.registerFactory<RequestOtpUseCase>(
    () => RequestOtpUseCase(sl<PatientAuthRepository>()),
  );
  sl.registerFactory<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<PatientAuthRepository>()),
  );
}
