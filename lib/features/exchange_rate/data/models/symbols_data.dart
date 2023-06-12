// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class SymbolsData {
  List<String>? symbolCodes;
  SymbolsData({this.symbolCodes});

  factory SymbolsData.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> symbolsMap = map['symbols'];
    List<String> symbols = symbolsMap.keys.toList();

    return SymbolsData(symbolCodes: symbols);
  }

  @override
  bool operator ==(covariant SymbolsData other) {
    if (identical(this, other)) return true;

    return listEquals(other.symbolCodes, symbolCodes);
  }

  @override
  int get hashCode => symbolCodes.hashCode;
}
