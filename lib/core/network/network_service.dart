import 'package:dio/dio.dart';
import 'package:exchange_rate_task/core/network/api_endpoint.dart';
import 'package:requests_inspector/requests_inspector.dart';

import '../../main.dart';
import '../exceptions/connection_exception.dart';
import '../exceptions/redundant_request_exception.dart';

abstract class NetworkService {
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

class NetworkServiceImpl implements NetworkService {
  final _dio = Dio(
      BaseOptions(baseUrl: ApiEndPoint.BASE_URL, validateStatus: (_) => true))
    ..interceptors.add(
      inspectorEnabled ? RequestsInspectorInterceptor() : const Interceptor(),
    );

  final _pendingRequests = <String>[];
  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    headers ??= getDefaultHeaders();
    final requestId = _generateRequestId(
        url: url, queryParameters: queryParameters, headers: headers);
    if (_pendingRequests.contains(requestId))
      throw RedundantRequestException('Request is already pending for $url');

    _pendingRequests.add(requestId);
    return _connectionExceptionCatcher(() => _get(
          url,
          queryParameters: formatQueryIfNeeded(queryParameters),
          headers: headers!,
        )).whenComplete(() => _pendingRequests.remove(requestId));
  }

  Future<Response> _get(
    String apiBaseUrl, {
    Map<String, dynamic>? queryParameters,
    required Map<String, dynamic> headers,
  }) async {
    final response = await _dio.get(
      apiBaseUrl,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return response;
  }

  Map<String, dynamic> getDefaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'language': 'en',
      'Accept': '*/*',
    };
  }

  Future<T> _connectionExceptionCatcher<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (e) {
      var message = e.toString();
      if ([
        'SocketException',
        'HttpException',
        'time out',
        'HandshakeException',
        'Failed host lookup'
      ].any((e) => message.contains(e)))
        throw ConnectionException('Connection Error');
      rethrow;
    }
  }

  String _generateRequestId({
    url,
    queryParameters,
    headers,
    data,
  }) =>
      '${url ?? ''}${queryParameters ?? ''}${headers ?? ''}${data ?? ''}';

  Map<String, dynamic>? formatQueryIfNeeded(
    Map<String, dynamic>? queryParameters,
  ) {
    if (queryParameters == null) return null;
    final newQueryParameters = <String, dynamic>{};

    for (final entry in queryParameters.entries) {
      if (entry.value is Map || entry.value is List) {
        final newEntries = _extractNormalEntriesFromMap(entry.key, entry.value);
        newQueryParameters.addEntries(newEntries);
      } else
        newQueryParameters[entry.key] = entry.value;
    }

    return newQueryParameters;
  }

  List<MapEntry<String, dynamic>> _extractNormalEntriesFromMap(
    String key,
    value,
  ) {
    if (value is! Map && value is! List) return [MapEntry(key, value)];

    final newEntries = <MapEntry<String, dynamic>>[];

    if (value is List)
      for (var i = 0; i < value.length; i++) {
        final item = value[i];
        if (item is! List && item is! Map)
          newEntries.add(MapEntry('$key[$i]', item));
        else
          newEntries.addAll(_extractNormalEntriesFromMap('$key[$i]', item));
      }
    else if (value is Map)
      for (var entry in value.entries) {
        if (entry.value is! Map && entry.value is! List)
          newEntries.add(MapEntry('$key.${entry.key}', entry.value));
        else
          newEntries.addAll(
              _extractNormalEntriesFromMap('$key.${entry.key}', entry.value));
      }

    return newEntries;
  }
}
