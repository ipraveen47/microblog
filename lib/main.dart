import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:microblog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:microblog/core/theme/theme.dart';

import 'package:microblog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:microblog/features/auth/presentation/pages/login_page.dart';
import 'package:microblog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:microblog/features/blog/presentation/pages/blog_page.dart';
import 'package:microblog/init_dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AppUserCubit>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<BlogBloc>(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasDispatched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasDispatched) {
      context.read<AuthBloc>().add(AuthUserLoggedIn());
      _hasDispatched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mico Blog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return const BlogPage();
            }
            return const LoginPage();
          },
        ));
  }
}
