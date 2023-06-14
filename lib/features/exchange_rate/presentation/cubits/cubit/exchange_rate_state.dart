// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:exchange_rate_task/features/exchange_rate/data/models/symbols_data.dart';

enum ExchangeRateStateStatus {
  initial,
  loading,
  loaded,
  error,
  rateLoading,
}

extension ExchangeRateStateX on ExchangeRateState {
  bool get isInitial => status == ExchangeRateStateStatus.initial;
  bool get isLoading => status == ExchangeRateStateStatus.loading;
  bool get isLoaded => status == ExchangeRateStateStatus.loaded;
  bool get isError => status == ExchangeRateStateStatus.error;
  bool get isRateLoading => status == ExchangeRateStateStatus.rateLoading;
}

@immutable
class ExchangeRateState {
  final ExchangeRateStateStatus status;
  final String? errorMessage;
  final Map<String, double>? rates;
  final SymbolsData? symbolsData;

  const ExchangeRateState({
    this.status = ExchangeRateStateStatus.initial,
    this.errorMessage,
    this.rates,
    this.symbolsData,
  });

  @override
  bool operator ==(covariant ExchangeRateState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.errorMessage == errorMessage &&
        mapEquals(other.rates, rates) &&
        other.symbolsData == symbolsData;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        errorMessage.hashCode ^
        rates.hashCode ^
        symbolsData.hashCode;
  }

  ExchangeRateState copyWith({
    ExchangeRateStateStatus? status,
    String? errorMessage,
    Map<String, double>? rates,
    SymbolsData? symbolsData,
  }) {
    return ExchangeRateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rates: rates ?? this.rates,
      symbolsData: symbolsData ?? this.symbolsData,
    );
  }
}
