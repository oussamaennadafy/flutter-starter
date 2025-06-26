// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/data/services/api/api_client.dart';
import 'package:compass_app/data/services/api/model/user/user_api_model.dart';
import 'package:compass_app/domain/models/continent/continent.dart';
import 'package:compass_app/utils/result.dart';

import '../../models/user.dart';

class FakeApiClient implements ApiClient {
  // Should not increase when using cached data
  int requestCount = 0;

  @override
  Future<Result<List<Continent>>> getContinents() async {
    requestCount++;
    return Result.ok([
      const Continent(name: 'CONTINENT', imageUrl: 'URL'),
      const Continent(name: 'CONTINENT2', imageUrl: 'URL'),
      const Continent(name: 'CONTINENT3', imageUrl: 'URL'),
    ]);
  }

  @override
  AuthHeaderProvider? authHeaderProvider;

  List bookings = [];

  @override
  Future<Result<UserApiModel>> getUser() async {
    return Result.ok(userApiModel);
  }

  @override
  Future<Result<void>> deleteBooking(int id) async {
    bookings.removeWhere((booking) => booking.id == id);
    return Result.ok(null);
  }
}
