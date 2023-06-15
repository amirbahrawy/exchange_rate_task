import 'package:dio/dio.dart';
import 'package:exchange_rate_task/core/exceptions/request_exception.dart';
import 'package:exchange_rate_task/core/network/network_service.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/models/exchange_rate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class NetworkServiceMock extends Mock implements NetworkService {}

void main() {
  late NetworkServiceMock networkServiceMock;
  late ExchangeRateRemoteDataSource dataSource;

  setUpAll(() {
    networkServiceMock = NetworkServiceMock();
    dataSource = ExchangeRateRemoteDataSourceImpl(networkServiceMock);
  });

  group('getExchangeRatePageData', () {
    test('should return data with no exceptions', () async {
      // arrange
      final exchangeRateData = ExchangeRateData(rates: {});
      when(() => networkServiceMock.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(baseUrl: ""),
          statusCode: 200,
          data: exchangeRateData,
        ),
      );

      // act
      final result = await dataSource.getExchangeRates();

      // assert
      expect(result, ExchangeRateData);
    });

    test(
        "Should return RequestException with message connection error if the status code is not 200 or 201",
        () {
      // arrange
      when(() => networkServiceMock.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(baseUrl: "testurl"),
          statusCode: 404,
        ),
      );

      // act
      final callBack = dataSource.getExchangeRates();

      // assert
      expect(callBack, throwsA(isA<RequestException>()));
    });
  });
}
