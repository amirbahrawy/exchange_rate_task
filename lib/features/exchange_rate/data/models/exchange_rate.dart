// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class ExchangeRates {
  Map<String, double>? rates;
  final String? base;
  final String? symbol;
  final String? startDate;
  final String? endDate;
  ExchangeRates({
    this.rates,
    this.base,
    this.symbol,
    this.startDate,
    this.endDate,
  });
  factory ExchangeRates.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> ratesMap = map['rates'];
    Map<String, double> rates = {};

    ratesMap.forEach((date, value) {
      rates[date] = (value as Map<String, dynamic>).values.first.toDouble();
    });

    return ExchangeRates(rates: rates);
  }

  @override
  bool operator ==(covariant ExchangeRates other) {
    if (identical(this, other)) return true;

    return mapEquals(other.rates, rates) &&
        other.base == base &&
        other.symbol == symbol &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return rates.hashCode ^
        base.hashCode ^
        symbol.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }

  ExchangeRates copyWith({
    Map<String, double>? rates,
    String? base,
    String? symbols,
    String? startDate,
    String? endDate,
  }) {
    return ExchangeRates(
      rates: rates ?? this.rates,
      base: base ?? this.base,
      symbol: symbols ?? this.symbol,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
