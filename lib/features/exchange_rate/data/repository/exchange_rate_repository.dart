import '../datasources/exchange_rate_remote_data_source.dart';
import '../models/exchange_rate.dart';
import '../models/symbols_data.dart';

abstract class ExchangeRateRepository {
  Future<ExchangeRates> getExchangeRates({
    String? base,
    String? symbol,
    String? startDate,
    String? endDate,
  });
  Future<SymbolsData> getSymbols();
}

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateRemoteDataSource _exchangeRateRemoteDataSource;

  ExchangeRateRepositoryImpl(this._exchangeRateRemoteDataSource);

  @override
  Future<ExchangeRates> getExchangeRates({
    String? base,
    String? symbol,
    String? startDate,
    String? endDate,
  }) async {
    return await _exchangeRateRemoteDataSource.getExchangeRates(
      base: base,
      symbol: symbol,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<SymbolsData> getSymbols() async {
    return await _exchangeRateRemoteDataSource.getSymbols();
  }
}
