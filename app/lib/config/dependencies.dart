// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_dev.dart';
import '../data/repositories/auth/auth_repository_remote.dart';
import '../data/repositories/continent/continent_repository.dart';
import '../data/repositories/continent/continent_repository_local.dart';
import '../data/repositories/continent/continent_repository_remote.dart';
import '../data/repositories/user/user_repository.dart';
import '../data/repositories/user/user_repository_local.dart';
import '../data/repositories/user/user_repository_remote.dart';
import '../data/services/api/api_client.dart';
import '../data/services/api/auth_api_client.dart';
import '../data/services/local/local_data_service.dart';
import '../data/services/shared_preferences_service.dart';
import '../domain/use_cases/booking/booking_share_use_case.dart';

/// Shared providers for all configurations.
List<SingleChildWidget> _sharedProviders = [
  Provider(
    lazy: true,
    create: (context) => BookingShareUseCase.withSharePlus(),
  ),
];

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to a remote server.
List<SingleChildWidget> get providersRemote {
  return [
    Provider(create: (context) => AuthApiClient()),
    Provider(create: (context) => ApiClient()),
    Provider(create: (context) => SharedPreferencesService()),
    ChangeNotifierProvider(
      create:
          (context) =>
              AuthRepositoryRemote(
                    authApiClient: context.read(),
                    apiClient: context.read(),
                    sharedPreferencesService: context.read(),
                  )
                  as AuthRepository,
    ),
    Provider(
      create:
          (context) =>
              ContinentRepositoryRemote(apiClient: context.read())
                  as ContinentRepository,
    ),
    Provider(
      create:
          (context) =>
              UserRepositoryRemote(apiClient: context.read()) as UserRepository,
    ),
    ..._sharedProviders,
  ];
}

/// Configure dependencies for local data.
/// This dependency list uses repositories that provide local data.
/// The user is always logged in.
List<SingleChildWidget> get providersLocal {
  return [
    ChangeNotifierProvider.value(value: AuthRepositoryDev() as AuthRepository),
    Provider.value(value: LocalDataService()),
    Provider(
      create:
          (context) =>
              ContinentRepositoryLocal(localDataService: context.read())
                  as ContinentRepository,
    ),
    Provider(
      create:
          (context) =>
              UserRepositoryLocal(localDataService: context.read())
                  as UserRepository,
    ),
    ..._sharedProviders,
  ];
}
