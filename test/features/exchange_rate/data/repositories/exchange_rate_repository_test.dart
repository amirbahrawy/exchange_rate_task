import 'package:exchange_rate_task/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/models/exchange_rate.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/repository/exchange_rate_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExchangeRateRemoteDataSource extends Mock
    implements ExchangeRateRemoteDataSource {}

void main() {
  late final ExchangeRateRepositoryImpl exchangeRateRepository;
  late final ExchangeRateRemoteDataSource mockExchangeRateRemoteDataSource;

  setUpAll(() {
    mockExchangeRateRemoteDataSource = MockExchangeRateRemoteDataSource();
    exchangeRateRepository =
        ExchangeRateRepositoryImpl(mockExchangeRateRemoteDataSource);
  });

  group('Get ExchangeRate Data', () {
    final exchangeRate = ExchangeRateData();
    test("Should return data without any exception ", () async {
      //arrange
      when(() => mockExchangeRateRemoteDataSource.getExchangeRates())
          .thenAnswer((_) async => exchangeRate);

      //act
      final result = await exchangeRateRepository.getExchangeRates();

      //assert
      expect(result, exchangeRate);
    });
  });
}
