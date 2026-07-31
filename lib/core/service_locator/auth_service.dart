import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/data_source/auth_local_data_source.dart';
import '../../features/auth/data/data_source/patient_auth_remote_data_source.dart';
import '../../features/auth/data/data_source/staff_auth_remote_data_source.dart';
import '../../features/auth/data/repositories/patient_auth_repository_impl.dart';
import '../../features/auth/data/repositories/staff_auth_repository_impl.dart';
import '../../features/auth/domain/repositories/patient_auth_repository.dart';
import '../../features/auth/domain/repositories/staff_auth_repository.dart';
import '../../features/auth/domain/use_cases/request_otp_use_case.dart';
import '../../features/auth/domain/use_cases/staff_login_use_case.dart';
import '../../features/auth/domain/use_cases/verify_otp_use_case.dart';
import '../../features/student/patients/data/data_source/patients_remote_data_source.dart';
import '../../features/student/patients/data/repositories/patients_repository_impl.dart';
import '../../features/student/patients/domain/repositories/patients_repository.dart';
import '../../features/student/patients/domain/use_cases/get_assigned_patients_use_case.dart';
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
  sl.registerLazySingleton<PatientsRemoteDataSource>(
    () => PatientsRemoteDataSourceImpl(sl<ApiClient>()),
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
  sl.registerLazySingleton<PatientsRepository>(
    () => PatientsRepositoryImpl(sl<PatientsRemoteDataSource>()),
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
  sl.registerFactory<GetAssignedPatientsUseCase>(
    () => GetAssignedPatientsUseCase(sl<PatientsRepository>()),
  );
}
