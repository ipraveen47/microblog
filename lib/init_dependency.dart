import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:microblog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:microblog/core/network/connection_checker.dart';
import 'package:microblog/core/secrets/app_secrets.dart';
import 'package:microblog/core/usecase/current_user.dart';
import 'package:microblog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:microblog/features/auth/data/repository/auth_repository_impl.dart';
import 'package:microblog/features/auth/domain/repository/auth_repository.dart';
import 'package:microblog/features/auth/domain/usecases/user_login.dart';
import 'package:microblog/features/auth/domain/usecases/user_signup.dart';
import 'package:microblog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:microblog/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:microblog/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:microblog/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:microblog/features/blog/domain/repositories/blog_repository.dart';
import 'package:microblog/features/blog/domain/usecases/delete_blog.dart';
import 'package:microblog/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:microblog/features/blog/domain/usecases/upload_blog.dart';
import 'package:microblog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
