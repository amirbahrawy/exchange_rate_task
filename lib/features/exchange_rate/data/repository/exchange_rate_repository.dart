import '../datasources/exchange_rate_remote_datasource.dart';
import '../models/exchange_rate.dart';
import '../models/symbols_data.dart';

abstract class ExchangeRateRepository {
  Future<ExchangeRateData> getExchangeRates(
      {ExchangeRateData? exchangeRateData});
  Future<SymbolsData> getSymbols();
}

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateRemoteDataSource _exchangeRateRemoteDataSource;

  ExchangeRateRepositoryImpl(this._exchangeRateRemoteDataSource);

  @override
  Future<ExchangeRateData> getExchangeRates(
      {ExchangeRateData? exchangeRateData}) async {
    return await _exchangeRateRemoteDataSource.getExchangeRates(
        exchangeRateData: exchangeRateData);
  }

  @override
  Future<SymbolsData> getSymbols() async {
    return await _exchangeRateRemoteDataSource.getSymbols();
  }
}
