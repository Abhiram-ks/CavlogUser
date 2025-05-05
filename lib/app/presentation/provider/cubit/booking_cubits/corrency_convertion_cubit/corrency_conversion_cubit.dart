
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_currency_rate/live_currency_rate.dart';

part 'corrency_conversion_state.dart';

class CurrencyConversionCubit extends Cubit<CurrencyConversionState> {
  CurrencyConversionCubit() : super(CurrencyConversionInitial());

  Future<void> convertINRtoUSD(double amountInINR) async {
    if (amountInINR <= 0) return;
    emit(CurrencyConversionLoading());
    try {
      CurrencyRate rate =  await LiveCurrencyRate.convertCurrency("INR", "USD", amountInINR);
      emit(CurrencyConversionSuccess(rate.result));
    } catch (e) {
      emit(CurrencyConversionFailure("Conversion failed: \$e"));
    }
  }
}