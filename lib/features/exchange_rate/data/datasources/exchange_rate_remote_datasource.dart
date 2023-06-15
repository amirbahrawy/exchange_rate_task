import 'package:exchange_rate_task/core/exceptions/request_exception.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/models/symbols_data.dart';

import '../../../../core/network/api_endpoint.dart';
import '../../../../core/network/network_service.dart';
import '../models/exchange_rate.dart';

abstract class ExchangeRateRemoteDataSource {
  Future<ExchangeRateData> getExchangeRates(
      {ExchangeRateData? exchangeRateData});
  Future<SymbolsData> getSymbols();
}

class ExchangeRateRemoteDataSourceImpl implements ExchangeRateRemoteDataSource {
  final NetworkService _networkService;

  ExchangeRateRemoteDataSourceImpl(this._networkService);

  @override
  Future<ExchangeRateData> getExchangeRates({
    ExchangeRateData? exchangeRateData,
  }) async {
    const url = ApiEndPoint.GET_EXCHANGE_RATES;

    final params = exchangeRateData?.toMap();

    return _networkService.get(url, queryParameters: params).then((response) {
      //handle error changes based on the api and backend
      if (![201, 200].contains(response.statusCode))
        throw RequestException('Connection Error ${response.statusCode}');

      return ExchangeRateData.fromMap(response.data);
    });
  }

  @override
  Future<SymbolsData> getSymbols() {
    const url = ApiEndPoint.GET_SYMBOLS;

    return _networkService.get(url).then((response) {
      //handle error changes based on the api and backend
      if (![201, 200].contains(response.statusCode))
        throw RequestException('Connection Error ${response.statusCode}');
      return SymbolsData.fromMap(response.data);
    });
  }
}
