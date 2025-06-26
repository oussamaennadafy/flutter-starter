// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/data/services/api/api_client.dart';
import 'package:compass_app/domain/models/continent/continent.dart';
import 'package:compass_app/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../testing/mocks.dart';
import '../../../../testing/models/user.dart';
import '../../../../testing/utils/result.dart';

void main() {
  group('ApiClient', () {
    late MockHttpClient mockHttpClient;
    late ApiClient apiClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiClient = ApiClient(clientFactory: () => mockHttpClient);
    });

    test('should get continents', () async {
      final continents = [const Continent(name: 'NAME', imageUrl: 'URL')];
      mockHttpClient.mockGet('/continent', continents);
      final result = await apiClient.getContinents();
      expect(result.asOk.value, continents);
    });

    test('should get user', () async {
      mockHttpClient.mockGet('/user', userApiModel);
      final result = await apiClient.getUser();
      expect(result.asOk.value, userApiModel);
    });

    test('should delete booking', () async {
      mockHttpClient.mockDelete('/booking/0');
      final result = await apiClient.deleteBooking(0);
      expect(result, isA<Ok<void>>());
    });
  });
}
