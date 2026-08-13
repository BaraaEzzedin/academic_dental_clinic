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
import '../../features/student/assigned_patients/data/data_source/assigned_patients_remote_data_source.dart';
import '../../features/student/assigned_patients/data/repositories/assigned_patients_repository_impl.dart';
import '../../features/student/assigned_patients/domain/repositories/assigned_patients_repository.dart';
import '../../features/student/assigned_patients/domain/use_cases/get_assigned_case_details_use_case.dart';
import '../../features/student/assigned_patients/domain/use_cases/get_assigned_cases_use_case.dart';
import '../../features/student/add_patient/data/data_source/add_patient_remote_data_source.dart';
import '../../features/student/add_patient/data/repositories/add_patient_repository_impl.dart';
import '../../features/student/add_patient/domain/repositories/add_patient_repository.dart';
import '../../features/student/add_patient/domain/use_cases/create_walk_in_case_use_case.dart';
import '../../features/student/case_acceptance_request/data/data_source/case_acceptance_request_remote_data_source.dart';
import '../../features/student/case_acceptance_request/data/repositories/case_acceptance_request_repository_impl.dart';
import '../../features/student/case_acceptance_request/domain/repositories/case_acceptance_request_repository.dart';
import '../../features/student/case_acceptance_request/domain/use_cases/get_subject_configuration_use_case.dart';
import '../../features/student/case_acceptance_request/domain/use_cases/submit_case_acceptance_request_use_case.dart';
import '../../features/student/patient_case/data/data_source/case_details_remote_data_source.dart';
import '../../features/student/patient_case/data/repositories/case_details_repository_impl.dart';
import '../../features/student/patient_case/domain/repositories/case_details_repository.dart';
import '../../features/student/patient_case/domain/use_cases/get_case_details_use_case.dart';
import '../../features/student/patient_case/domain/use_cases/upload_case_media_use_case.dart';
import '../../features/student/clinical_courses/data/data_source/clinical_courses_remote_data_source.dart';
import '../../features/student/clinical_courses/data/repositories/clinical_courses_repository_impl.dart';
import '../../features/student/clinical_courses/domain/repositories/clinical_courses_repository.dart';
import '../../features/student/clinical_courses/domain/use_cases/get_clinical_courses_use_case.dart';
import '../../features/student/open_case_appointment/data/data_source/appointment_remote_data_source.dart';
import '../../features/student/open_case_appointment/data/repositories/appointment_repository_impl.dart';
import '../../features/student/open_case_appointment/domain/repositories/appointment_repository.dart';
import '../../features/student/open_case_appointment/domain/use_cases/book_appointment_use_case.dart';
import '../../features/student/open_case_appointment/domain/use_cases/get_available_appointments_use_case.dart';
import '../../features/student/open_cases/data/data_source/open_cases_remote_data_source.dart';
import '../../features/student/open_cases/data/repositories/open_cases_repository_impl.dart';
import '../../features/student/open_cases/domain/repositories/open_cases_repository.dart';
import '../../features/student/open_cases/domain/use_cases/get_open_case_details_use_case.dart';
import '../../features/student/open_cases/domain/use_cases/get_open_cases_use_case.dart';
import '../../features/student/patients/data/data_source/patients_remote_data_source.dart';
import '../../features/student/patients/data/repositories/patients_repository_impl.dart';
import '../../features/student/patients/domain/repositories/patients_repository.dart';
import '../../features/student/patients/domain/use_cases/get_assigned_patients_use_case.dart';
import '../../features/student/today_appointments/data/data_source/today_appointments_remote_data_source.dart';
import '../../features/student/today_appointments/data/repositories/today_appointments_repository_impl.dart';
import '../../features/student/today_appointments/domain/repositories/today_appointments_repository.dart';
import '../../features/student/today_appointments/domain/use_cases/get_today_appointments_use_case.dart';
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
  sl.registerLazySingleton<CaseAcceptanceRequestRemoteDataSource>(
    () => CaseAcceptanceRequestRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<TodayAppointmentsRemoteDataSource>(
    () => TodayAppointmentsRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<ClinicalCoursesRemoteDataSource>(
    () => ClinicalCoursesRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<OpenCasesRemoteDataSource>(
    () => OpenCasesRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AssignedPatientsRemoteDataSource>(
    () => AssignedPatientsRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<CaseDetailsRemoteDataSource>(
    () => CaseDetailsRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AddPatientRemoteDataSource>(
    () => AddPatientRemoteDataSourceImpl(sl<ApiClient>()),
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
  sl.registerLazySingleton<CaseAcceptanceRequestRepository>(
    () => CaseAcceptanceRequestRepositoryImpl(
      sl<CaseAcceptanceRequestRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<TodayAppointmentsRepository>(
    () => TodayAppointmentsRepositoryImpl(
      sl<TodayAppointmentsRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<ClinicalCoursesRepository>(
    () => ClinicalCoursesRepositoryImpl(
      sl<ClinicalCoursesRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<OpenCasesRepository>(
    () => OpenCasesRepositoryImpl(
      sl<OpenCasesRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(
      sl<AppointmentRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<AssignedPatientsRepository>(
    () => AssignedPatientsRepositoryImpl(
      sl<AssignedPatientsRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<CaseDetailsRepository>(
    () => CaseDetailsRepositoryImpl(
      sl<CaseDetailsRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<AddPatientRepository>(
    () => AddPatientRepositoryImpl(
      sl<AddPatientRemoteDataSource>(),
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
  sl.registerFactory<GetMyPatientsUseCase>(
    () => GetMyPatientsUseCase(sl<PatientsRepository>()),
  );
  sl.registerFactory<GetTodayAppointmentsUseCase>(
    () => GetTodayAppointmentsUseCase(sl<TodayAppointmentsRepository>()),
  );
  sl.registerFactory<GetClinicalCoursesUseCase>(
    () => GetClinicalCoursesUseCase(sl<ClinicalCoursesRepository>()),
  );
  sl.registerFactory<GetOpenCasesUseCase>(
    () => GetOpenCasesUseCase(sl<OpenCasesRepository>()),
  );
  sl.registerFactory<GetOpenCaseDetailsUseCase>(
    () => GetOpenCaseDetailsUseCase(sl<OpenCasesRepository>()),
  );
  sl.registerFactory<GetAvailableAppointmentsUseCase>(
    () => GetAvailableAppointmentsUseCase(sl<AppointmentRepository>()),
  );
  sl.registerFactory<BookAppointmentUseCase>(
    () => BookAppointmentUseCase(sl<AppointmentRepository>()),
  );
  sl.registerFactory<GetSubjectConfigurationUseCase>(
    () => GetSubjectConfigurationUseCase(sl<CaseAcceptanceRequestRepository>()),
  );
  sl.registerFactory<SubmitCaseAcceptanceRequestUseCase>(
    () =>
        SubmitCaseAcceptanceRequestUseCase(sl<CaseAcceptanceRequestRepository>()),
  );
  sl.registerFactory<GetAssignedCasesUseCase>(
    () => GetAssignedCasesUseCase(sl<AssignedPatientsRepository>()),
  );
  sl.registerFactory<GetAssignedCaseDetailsUseCase>(
    () => GetAssignedCaseDetailsUseCase(sl<AssignedPatientsRepository>()),
  );
  sl.registerFactory<GetCaseDetailsUseCase>(
    () => GetCaseDetailsUseCase(sl<CaseDetailsRepository>()),
  );
  sl.registerFactory<UploadCaseMediaUseCase>(
    () => UploadCaseMediaUseCase(sl<CaseDetailsRepository>()),
  );
  sl.registerFactory<CreateWalkInCaseUseCase>(
    () => CreateWalkInCaseUseCase(sl<AddPatientRepository>()),
  );
}
