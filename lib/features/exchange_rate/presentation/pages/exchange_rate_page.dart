import 'package:exchange_rate_task/core/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubit/exchange_rate_cubit.dart';

class ExchangeRatePage extends StatelessWidget {
  const ExchangeRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ExchangeRateCubit>(
        lazy: false,
        create: (context) => Injector().exchangeRateCubit..loadSymbols(),
        child: Builder(builder: (context) {
          return InkWell(
              onTap: () {
                context.read<ExchangeRateCubit>().updateCurrencyData(
                      base: 'EGP',
                      symbol: 'EUR',
                      startDate: '2021-01-01',
                      endDate: '2021-01-10',
                    );
              },
              child: const Center(child: Text('ExchangeRatePage')));
        }),
      ),
    );
  }
}
