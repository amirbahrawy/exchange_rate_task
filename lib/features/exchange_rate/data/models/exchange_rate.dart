// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class ExchangeRates {
  Map<String, double>? rates;

  ExchangeRates({
    this.rates,
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

    return mapEquals(other.rates, rates);
  }

  @override
  int get hashCode => rates.hashCode;

  ExchangeRates copyWith({
    Map<String, double>? rates,
  }) {
    return ExchangeRates(
      rates: rates ?? this.rates,
    );
  }
}
