import 'dart:developer';

import 'package:exchange_rate_task/features/exchange_rate/data/models/exchange_rate.dart';

import '../../../../../core/abstract/base_cubit.dart';
import '../../../../../core/exceptions/redundant_request_exception.dart';
import '../../../data/repository/exchange_rate_repository.dart';
import 'exchange_rate_state.dart';

class ExchangeRateCubit extends BaseCubit<ExchangeRateState> {
  ExchangeRateCubit(
    this._exchangeRateRepository,
  ) : super(ExchangeRateState());

  final ExchangeRateRepository _exchangeRateRepository;

  Future<void> loadExchangeRates({
    bool refresh = false,
  }) async {
    try {
      if (!refresh)
        emit(state.copyWith(status: ExchangeRateStateStatus.rateLoading));
      final exchangeRateData = await _exchangeRateRepository.getExchangeRates(
        base: state.base,
        symbols: state.symbol,
        startDate: state.startDate,
        endDate: state.endDate,
      );
      emit(state.copyWith(
        status: ExchangeRateStateStatus.loaded,
        rates: exchangeRateData.rates,
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

  void updateBase({
    required String base,
  }) {
    emit(
      state.copyWith(base: base),
    );
  }

  void updateSymbol({
    required String symbol,
  }) {
    emit(
      state.copyWith(symbol: symbol),
    );
  }

  void updateStartDate({
    required String startDate,
  }) {
    emit(
      state.copyWith(startDate: startDate),
    );
  }

  void updateEndDate({
    required String endDate,
  }) {
    emit(
      state.copyWith(endDate: endDate),
    );
  }
}
