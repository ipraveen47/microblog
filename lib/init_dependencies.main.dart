part of 'init_dependency.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    anonKey: AppSecrets.anonKey,
    url: AppSecrets.supabaseUrl,
  );

  // Set Hive directory manually
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // Open your Hive box
  final blogBox = await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton(() => blogBox);

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // DataSource
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceEmpl(
      serviceLocator(),
    ),
  );
  // repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );
  // useCases
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(() => UserLogin(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => CurrentUser(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userlogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSrourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()));
  serviceLocator.registerFactory<BlogRepository>(() => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => UploadBlog(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(
    () => GetAllBlogs(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => DeleteBlog(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(() => BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
      deleteBlog: serviceLocator()));
}
