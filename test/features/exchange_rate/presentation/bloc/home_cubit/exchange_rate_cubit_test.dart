import 'dart:math';

import 'package:exchange_rate_task/core/exceptions/request_exception.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/models/exchange_rate.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/repository/exchange_rate_repository.dart';
import 'package:exchange_rate_task/features/exchange_rate/presentation/cubits/cubit/exchange_rate_cubit.dart';
import 'package:exchange_rate_task/features/exchange_rate/presentation/cubits/cubit/exchange_rate_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExchangeRateRepo extends Mock implements ExchangeRateRepository {}

void main() {
  late ExchangeRateCubit exchangeRateCubit;
  late ExchangeRateRepository exchangeRateRepository;

  setUp(() {
    exchangeRateRepository = MockExchangeRateRepo();
    exchangeRateCubit = ExchangeRateCubit(exchangeRateRepository);
  });

  tearDown(() {
    exchangeRateCubit.close();
  });

  final exchangeRateData = ExchangeRateData();

  group("loadHome", () {
    test(
      "Initial state should be HomeState(status: HomeStateStatus.initial)",
      () async {
        expect(
            exchangeRateCubit.state,
            const ExchangeRateState(
              status: ExchangeRateStateStatus.initial,
            ));
      },
    );

    test(
      "Should emit Loading then Loaded states without any exception",
      () async {
        //arrange
        when(() => exchangeRateRepository.getExchangeRates())
            .thenAnswer((_) async => exchangeRateData);

        //assert later
        final expected = [
          const ExchangeRateState(status: ExchangeRateStateStatus.rateLoading),
          ExchangeRateState(
            status: ExchangeRateStateStatus.loaded,
            rates: exchangeRateData.rates,
          ),
        ];
        expect(exchangeRateCubit.stream, emitsInOrder(expected));

        //act
        await exchangeRateCubit.loadExchangeRates();
      },
    );

    test(
      "Should emit Loading then Error states when the getHomePageDate throw an Exception",
      () async {
        //arrange
        when(() => exchangeRateRepository.getExchangeRates())
            .thenAnswer((_) async => throw RequestException('error'));

        //assert later
        final expected = [
          const ExchangeRateState(status: ExchangeRateStateStatus.rateLoading),
          const ExchangeRateState(
            status: ExchangeRateStateStatus.error,
            errorMessage: 'error',
          ),
        ];
        expect(exchangeRateCubit.stream, emitsInOrder(expected));

        //act
        await exchangeRateCubit.loadExchangeRates();
      },
    );
  });
}
