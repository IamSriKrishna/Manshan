import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:manshan/core/network/dio_client.dart';
import 'package:manshan/core/service/storage_service.dart';
import 'package:manshan/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:manshan/src/auth/data/repository/auth_repository_impl.dart';
import 'package:manshan/src/auth/domain/repository/auth_repository.dart';
import 'package:manshan/src/auth/domain/usecase/authme_usecase.dart';
import 'package:manshan/src/auth/domain/usecase/signin_usecase.dart';
import 'package:manshan/src/auth/domain/usecase/signup_usecase.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:manshan/src/construction/data/datasource/construction_remote_datasource.dart';
import 'package:manshan/src/construction/data/repository/construction_repository_impl.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';
import 'package:manshan/src/construction/domain/usecase/all_constuction_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/create_construction_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/create_employee_site_assignment_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/create_site_entry_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/get_site_assignment_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/get_site_entries_usecase.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_bloc.dart';
import 'package:manshan/src/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:manshan/src/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:manshan/src/dashboard/domain/repository/dashboard_repository.dart';
import 'package:manshan/src/dashboard/domain/usecase/dashboard_usecase.dart';
import 'package:manshan/src/dashboard/domain/usecase/last_transaction_usecase.dart';
import 'package:manshan/src/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:manshan/src/dashboard/presentation/bloc/navigator_bloc.dart';
import 'package:manshan/src/employee/data/datasource/employee_remote_datasource.dart';
import 'package:manshan/src/employee/data/repository/employee_repository_impl.dart';
import 'package:manshan/src/employee/domain/repository/employee_repository.dart';
import 'package:manshan/src/employee/domain/usecase/all_employee_usecase.dart';
import 'package:manshan/src/employee/domain/usecase/create_employee_usecase.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';
import 'package:manshan/src/salary/data/datasource/salary_remote_datasource.dart';
import 'package:manshan/src/salary/data/repository/salary_repository_impl.dart';
import 'package:manshan/src/salary/domain/repository/salary_repository.dart';
import 'package:manshan/src/salary/domain/usecase/salary_usecases.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/grant/data/datasource/grant_remote_datasource.dart';
import 'package:manshan/src/grant/data/repository/grant_repository_impl.dart';
import 'package:manshan/src/grant/domain/repository/grant_repository.dart';
import 'package:manshan/src/grant/domain/usecase/grant_usecases.dart';
import 'package:manshan/src/grant/presentation/bloc/grant_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  await GetStorage.init();

  //services
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<Dio>(
    () => DioClient.createDio(sl<StorageService>()),
  );

  //datasource
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<DashboardRemoteDatasource>(
    () => DashboardRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<EmployeeRemoteDatasource>(
    () => EmployeeRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ConstructionRemoteDatasource>(
    () => ConstructionRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<SalaryRemoteDatasource>(
    () => SalaryRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<GrantRemoteDatasource>(
    () => GrantRemoteDatasourceImpl(dio: sl<Dio>()),
  );

  //repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl<AuthRemoteDatasource>()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDatasource: sl<DashboardRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(
      remoteDatasource: sl<EmployeeRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton<ConstructionRepository>(
    () => ConstructionRepositoryImpl(
      remoteDatasource: sl<ConstructionRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton<SalaryRepository>(
    () => SalaryRepositoryImpl(remoteDatasource: sl<SalaryRemoteDatasource>()),
  );
  sl.registerLazySingleton<GrantRepository>(
    () => GrantRepositoryImpl(remoteDatasource: sl<GrantRemoteDatasource>()),
  );

  //usecase
  sl.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SigninUsecase>(
    () => SigninUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<AuthmeUsecase>(
    () => AuthmeUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<DashboardUsecase>(
    () => DashboardUsecase(repository: sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<LastTransactionUsecase>(
    () => LastTransactionUsecase(repository: sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<AllEmployeeUsecase>(
    () => AllEmployeeUsecase(repository: sl<EmployeeRepository>()),
  );
  sl.registerLazySingleton<CreateEmployeeUsecase>(
    () => CreateEmployeeUsecase(repository: sl<EmployeeRepository>()),
  );
  sl.registerLazySingleton<AllConstructionSitesUsecase>(
    () => AllConstructionSitesUsecase(repository: sl<ConstructionRepository>()),
  );
  sl.registerLazySingleton<CreateConstructionSiteUsecase>(
    () =>
        CreateConstructionSiteUsecase(repository: sl<ConstructionRepository>()),
  );
  sl.registerLazySingleton<CreateEmployeeSiteAssignmentUsecase>(
    () => CreateEmployeeSiteAssignmentUsecase(
      repository: sl<ConstructionRepository>(),
    ),
  );
  sl.registerLazySingleton<CreateSiteEntryUsecase>(
    () => CreateSiteEntryUsecase(repository: sl<ConstructionRepository>()),
  );
  sl.registerLazySingleton<GetSiteEntriesUsecase>(
    () => GetSiteEntriesUsecase(repository: sl<ConstructionRepository>()),
  );
  sl.registerLazySingleton<GetSiteAssignmentsUsecase>(
    () => GetSiteAssignmentsUsecase(repository: sl<ConstructionRepository>()),
  );
  sl.registerLazySingleton<GetAllEmployeesForSalaryUsecase>(
    () => GetAllEmployeesForSalaryUsecase(repository: sl<SalaryRepository>()),
  );
  sl.registerLazySingleton<CreateBulkSalaryUsecase>(
    () => CreateBulkSalaryUsecase(repository: sl<SalaryRepository>()),
  );
  sl.registerLazySingleton<GetTransactionHistoryUsecase>(
    () => GetTransactionHistoryUsecase(repository: sl<SalaryRepository>()),
  );
  sl.registerLazySingleton<GrantAccessUsecase>(
    () => GrantAccessUsecase(repository: sl<GrantRepository>()),
  );
  sl.registerLazySingleton<RevokeAccessUsecase>(
    () => RevokeAccessUsecase(repository: sl<GrantRepository>()),
  );
  sl.registerLazySingleton<GetMyAccessesUsecase>(
    () => GetMyAccessesUsecase(repository: sl<GrantRepository>()),
  );
  sl.registerLazySingleton<GetGrantUsersUsecase>(
    () => GetGrantUsersUsecase(repository: sl<GrantRepository>()),
  );
  sl.registerLazySingleton<AcceptAccessRequestUsecase>(
    () => AcceptAccessRequestUsecase(repository: sl<GrantRepository>()),
  );
  sl.registerLazySingleton<RejectAccessRequestUsecase>(
    () => RejectAccessRequestUsecase(repository: sl<GrantRepository>()),
  );
  sl.registerLazySingleton<GetRequestsReceivedUsecase>(
    () => GetRequestsReceivedUsecase(repository: sl<GrantRepository>()),
  );
  sl.registerLazySingleton<GetRequestsSentUsecase>(
    () => GetRequestsSentUsecase(repository: sl<GrantRepository>()),
  );

  //bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signupUsecase: sl<SignupUsecase>(),
      signinUsecase: sl<SigninUsecase>(),
      authmeUsecase: sl<AuthmeUsecase>(),
    ),
  );
  sl.registerFactory<NavigatorBloc>(() => NavigatorBloc());
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      dashboardUsecase: sl<DashboardUsecase>(),
      lastTransactionUsecase: sl<LastTransactionUsecase>(),
    ),
  );
  sl.registerFactory<EmployeeBloc>(
    () => EmployeeBloc(
      allEmployeeUsecase: sl<AllEmployeeUsecase>(),
      createEmployeeUsecase: sl<CreateEmployeeUsecase>(),
    ),
  );
  sl.registerFactory<ConstructionBloc>(
    () => ConstructionBloc(
      createEmployeeSiteAssignmentUsecase:
          sl<CreateEmployeeSiteAssignmentUsecase>(),
      createSiteEntryUsecase: sl<CreateSiteEntryUsecase>(),
      createConstructionSiteUsecase: sl<CreateConstructionSiteUsecase>(),
      allConstructionSitesUsecase: sl<AllConstructionSitesUsecase>(),
      getSiteEntriesUsecase: sl<GetSiteEntriesUsecase>(),
      getSiteAssignmentsUsecase: sl<GetSiteAssignmentsUsecase>(),
    ),
  );
  sl.registerFactory<SalaryBloc>(
    () => SalaryBloc(
      getEmployeesUsecase: sl<GetAllEmployeesForSalaryUsecase>(),
      createBulkSalaryUsecase: sl<CreateBulkSalaryUsecase>(),
      getTransactionHistoryUsecase: sl<GetTransactionHistoryUsecase>(),
    ),
  );
  sl.registerFactory<GrantBloc>(
    () => GrantBloc(
      grantAccessUsecase: sl<GrantAccessUsecase>(),
      revokeAccessUsecase: sl<RevokeAccessUsecase>(),
      getMyAccessesUsecase: sl<GetMyAccessesUsecase>(),
      getGrantUsersUsecase: sl<GetGrantUsersUsecase>(),
      acceptAccessRequestUsecase: sl<AcceptAccessRequestUsecase>(),
      rejectAccessRequestUsecase: sl<RejectAccessRequestUsecase>(),
      getRequestsReceivedUsecase: sl<GetRequestsReceivedUsecase>(),
      getRequestsSentUsecase: sl<GetRequestsSentUsecase>(),
    ),
  );
}
