import 'package:exchange_rate_task/core/di.dart';
import 'package:exchange_rate_task/features/exchange_rate/data/models/exchange_rate.dart';
import 'package:exchange_rate_task/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../shared_widgets/show_snack_bar.dart';
import '../cubits/cubit/exchange_rate_cubit.dart';
import '../cubits/cubit/exchange_rate_state.dart';

class ExchangeRatePage extends StatefulWidget {
  const ExchangeRatePage({super.key});

  @override
  State<ExchangeRatePage> createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  String? baseCurrency;
  String? destinationCurrency;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
  }

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
            if (state.isLoading)
              return const Center(
                child: CircularProgressIndicator(),
              );
            if (state.symbolsData?.symbolCodes?.isNotEmpty != true)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'No Symbols Found\nPlease Try Again Later',
                      style: TextStyle(
                        color: AppColors.ACCENT_COLOR,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ExchangeRateCubit>().loadSymbols(),
                    child: const Text('Retry'),
                  ),
                ],
              );
            return _buildBody(context);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = context.read<ExchangeRateCubit>().state;
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
              color: AppColors.ACCENT_COLOR,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildSelectDateRange(context),
          const SizedBox(height: 16),
          const Text(
            'Select Currencies',
            style: TextStyle(
              color: AppColors.ACCENT_COLOR,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSelectCurrencies(context),
          const SizedBox(height: 16),
          _buildSubmitButton(context),
          const SizedBox(height: 16),
          _buildExchangeRateList(state.rates),
        ],
      ),
    );
  }

  Widget _buildSelectDateRange(BuildContext context) {
    return Form(
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
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  _startDateController.text = formattedDate;
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
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  _endDateController.text = formattedDate;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCurrencies(BuildContext context) {
    final state = context.read<ExchangeRateCubit>().state;
    return Row(
      children: [
        Expanded(
          child: DropdownButton(
              hint: const Text('Select Base'),
              value: baseCurrency,
              items: state.symbolsData?.symbolCodes?.map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  baseCurrency = value.toString();
                });
              }),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: DropdownButton(
              hint: const Text('Select Destination'),
              value: destinationCurrency,
              items: state.symbolsData?.symbolCodes?.map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  destinationCurrency = value.toString();
                });
              }),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final cubit = context.watch<ExchangeRateCubit>();
    final state = cubit.state;
    return Center(
      child: AnimatedContainer(
        height: 50.0,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        width: state.isRateLoading ? 50.0 : 200.0,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final exchangeRateData = ExchangeRateData(
                baseCurrency: baseCurrency,
                destinationCurrency: destinationCurrency,
                startDate: _startDateController.text,
                endDate: _endDateController.text,
              );
              cubit.loadExchangeRates(exchangeRateData: exchangeRateData);
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: state.isRateLoading
                    ? BorderRadius.circular(80.0)
                    : BorderRadius.circular(8.0),
              ),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: state.isRateLoading
              ? const CupertinoActivityIndicator(
                  color: Colors.white,
                )
              : const Text('Get Exchange Rates'),
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
              color: AppColors.ACCENT_COLOR,
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
