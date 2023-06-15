// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class ExchangeRateData {
  Map<String, double>? rates;
  final String? baseCurrency;
  final String? destinationCurrency;
  final String? startDate;
  final String? endDate;

  ExchangeRateData({
    this.rates,
    this.baseCurrency,
    this.destinationCurrency,
    this.startDate,
    this.endDate,
  });
  factory ExchangeRateData.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> ratesMap = map['rates'];
    Map<String, double> rates = {};

    ratesMap.forEach((date, value) {
      rates[date] = (value as Map<String, dynamic>).values.first.toDouble();
    });

    return ExchangeRateData(rates: rates);
  }
  Map<String, dynamic> toMap() {
    return {
      'base': baseCurrency,
      'symbols': destinationCurrency,
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  @override
  bool operator ==(covariant ExchangeRateData other) {
    if (identical(this, other)) return true;

    return mapEquals(other.rates, rates) &&
        other.baseCurrency == baseCurrency &&
        other.destinationCurrency == destinationCurrency &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return rates.hashCode ^
        baseCurrency.hashCode ^
        destinationCurrency.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }

  ExchangeRateData copyWith({
    Map<String, double>? rates,
    String? baseCurrency,
    String? destinationCurrency,
    String? startDate,
    String? endDate,
  }) {
    return ExchangeRateData(
      rates: rates ?? this.rates,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      destinationCurrency: destinationCurrency ?? this.destinationCurrency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
