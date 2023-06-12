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
  }) async {
    try {
      if (!refresh)
        emit(state.copyWith(status: ExchangeRateStateStatus.loading));
      final exchangeRateData = await _exchangeRateRepository.getExchangeRates(
        base: state.exchangeRateData?.base,
        symbols: state.exchangeRateData?.symbol,
        startDate: state.exchangeRateData?.startDate,
        endDate: state.exchangeRateData?.endDate,
      );
      log(exchangeRateData.rates?.entries.first.key ?? 'no data');
      emit(state.copyWith(
        status: ExchangeRateStateStatus.loaded,
        exchangeRateData: exchangeRateData,
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
      log(symbolsData.symbolCodes?.first ?? 'no data');
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

  void updateCurrencyData({
    String? base,
    String? symbol,
    String? startDate,
    String? endDate,
  }) async {
    emit(
      state.copyWith(
          exchangeRateData: ExchangeRates(
        base: base,
        symbol: symbol,
        startDate: startDate,
        endDate: endDate,
      )),
    );
    await refresh();
  }
}
