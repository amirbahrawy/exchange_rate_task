import 'package:exchange_rate_task/core/di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../shared_widgets/show_snack_bar.dart';
import '../cubits/cubit/exchange_rate_cubit.dart';
import '../cubits/cubit/exchange_rate_state.dart';

class ExchangeRatePage extends StatelessWidget {
  ExchangeRatePage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rate'),
      ),
      body: BlocProvider<ExchangeRateCubit>(
        lazy: false,
        create: (context) => Injector().exchangeRateCubit..loadSymbols(),
        child: BlocConsumer<ExchangeRateCubit, ExchangeRateState>(
          listener: (context, state) {
            if (state.isError)
              showSnackBar(
                context,
                message: state.errorMessage,
              );
          },
          builder: (context, state) {
            _startDateController.text = state.startDate ?? '';
            _endDateController.text = state.endDate ?? '';
            final cubit = context.watch<ExchangeRateCubit>();
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select date range ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startDateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'Start Date (YYYY-MM-DD)',
                                labelText: 'Start Date',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter start date';
                                }
                                return null;
                              },
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(date);
                                  cubit.updateStartDate(
                                      startDate: formattedDate);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _endDateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'End Date (YYYY-MM-DD)',
                                labelText: 'End Date',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter end date';
                                }
                                return null;
                              },
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(date);
                                  cubit.updateEndDate(endDate: formattedDate);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Currencies',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    //TODO: add loading indicator
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton(
                              hint: const Text('Select Base'),
                              value: state.base,
                              items: state.symbolsData?.symbolCodes?.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (value) {
                                cubit.updateBase(base: value ?? '');
                              }),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: DropdownButton(
                              hint: const Text('Select Currency'),
                              value: state.symbol,
                              items: state.symbolsData?.symbolCodes?.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (value) {
                                cubit.updateSymbol(symbol: value ?? '');
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                          borderRadius: state.isRateLoading
                              ? BorderRadius.circular(80.0)
                              : BorderRadius.circular(30.0),
                        ),
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 500),
                        width: state.isRateLoading ? 30.0 : 200.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.loadExchangeRates();
                            }
                          },
                          child: state.isRateLoading
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Get Exchange Rates'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExchangeRateList(state.rates),
                  ]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExchangeRateList(Map<String, double>? rates) {
    if (rates?.isNotEmpty != true) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No data found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: rates?.length ?? 0,
        itemBuilder: (context, index) {
          final key = rates?.keys.elementAt(index);
          final value = rates?.values.elementAt(index);
          return ListTile(
            title: Text(key ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            trailing: Text(value?.toString() ?? ''),
          );
        },
      ),
    );
  }
}
