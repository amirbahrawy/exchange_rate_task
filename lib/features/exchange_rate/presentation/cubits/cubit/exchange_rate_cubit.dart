import 'dart:developer';

import 'package:exchange_rate_task/features/exchange_rate/data/models/exchange_rate.dart';

import '../../../../../core/abstract/base_cubit.dart';
import '../../../../../core/exceptions/redundant_request_exception.dart';
import '../../../data/repository/exchange_rate_repository.dart';
import 'exchange_rate_state.dart';

class ExchangeRateCubit extends BaseCubit<ExchangeRateState> {
  ExchangeRateCubit(
    this._exchangeRateRepository,
  ) : super(const ExchangeRateState());

  final ExchangeRateRepository _exchangeRateRepository;

  Future<void> loadExchangeRates({
    bool refresh = false,
    ExchangeRateData? exchangeRateData,
  }) async {
    try {
      if (!refresh)
        emit(state.copyWith(status: ExchangeRateStateStatus.rateLoading));
      final data = await _exchangeRateRepository.getExchangeRates(
          exchangeRateData: exchangeRateData);
      emit(state.copyWith(
        status: ExchangeRateStateStatus.loaded,
        rates: data.rates,
      ));
    } on RedundantRequestException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          status: ExchangeRateStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadSymbols() async {
    try {
      emit(state.copyWith(status: ExchangeRateStateStatus.loading));
      final symbolsData = await _exchangeRateRepository.getSymbols();
      emit(state.copyWith(
        status: ExchangeRateStateStatus.loaded,
        symbolsData: symbolsData,
      ));
    } on RedundantRequestException catch (e) {
      log(e.toString());
    } catch (e) {
      emit(
        state.copyWith(
          status: ExchangeRateStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() => loadExchangeRates(refresh: true);
}
