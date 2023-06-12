// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:exchange_rate_task/features/exchange_rate/data/models/symbols_data.dart';

import '../../../data/models/exchange_rate.dart';

enum ExchangeRateStateStatus {
  initial,
  loading,
  loaded,
  error,
}

extension ExchangeRateStateX on ExchangeRateState {
  bool get isInitial => status == ExchangeRateStateStatus.initial;
  bool get isLoading => status == ExchangeRateStateStatus.loading;
  bool get isLoaded => status == ExchangeRateStateStatus.loaded;
  bool get isError => status == ExchangeRateStateStatus.error;
}

@immutable
class ExchangeRateState {
  final ExchangeRateStateStatus status;
  final String? errorMessage;
  final ExchangeRates? exchangeRateData;
  final SymbolsData? symbolsData;

  const ExchangeRateState({
    this.status = ExchangeRateStateStatus.initial,
    this.errorMessage,
    this.exchangeRateData,
    this.symbolsData,
  });

  @override
  bool operator ==(covariant ExchangeRateState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.errorMessage == errorMessage &&
        other.exchangeRateData == exchangeRateData &&
        other.symbolsData == symbolsData;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        errorMessage.hashCode ^
        exchangeRateData.hashCode ^
        symbolsData.hashCode;
  }

  ExchangeRateState copyWith({
    ExchangeRateStateStatus? status,
    String? errorMessage,
    ExchangeRates? exchangeRateData,
    SymbolsData? symbolsData,
  }) {
    return ExchangeRateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      exchangeRateData: exchangeRateData ?? this.exchangeRateData,
      symbolsData: symbolsData ?? this.symbolsData,
    );
  }
}
