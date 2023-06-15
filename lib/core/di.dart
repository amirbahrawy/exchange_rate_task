import '../features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';
import '../features/exchange_rate/data/repository/exchange_rate_repository.dart';
import '../features/exchange_rate/presentation/cubits/cubit/exchange_rate_cubit.dart';
import 'network/network_service.dart';

///Implementing
///
///`Singleton` design pattern
///
///`Flyweight` design pattern
///
///to save specific objects from recreation
class Injector {
  final _flyweightMap = <String, dynamic>{};
  static final _singleton = Injector._internal();

  Injector._internal();
  factory Injector() => _singleton;

  //===================[ExchangeRate_CUBIT]===================
  ExchangeRateCubit get exchangeRateCubit =>
      ExchangeRateCubit(exchangeRateRepository);

  ExchangeRateRepository get exchangeRateRepository =>
      _flyweightMap['ExchangeRateRepository'] ??
      ExchangeRateRepositoryImpl(exchangeRateLocalDataSource);

  ExchangeRateRemoteDataSource get exchangeRateLocalDataSource =>
      _flyweightMap['ExchangeRateRemoteDataSource'] ??
      ExchangeRateRemoteDataSourceImpl(networkService);
  //===================[Other]===================
  NetworkService get networkService =>
      _flyweightMap['networkService'] ??= NetworkServiceImpl();
}
