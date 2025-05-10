
import 'package:flutter_bloc/flutter_bloc.dart';

part 'corrency_conversion_state.dart';

class CurrencyConversionCubit extends Cubit<CurrencyConversionState> {
  CurrencyConversionCubit() : super(CurrencyConversionInitial());

  Future<void> convertINRtoUSD(double amountInINR) async {
    if (amountInINR <= 0) return;
    emit(CurrencyConversionLoading());
    await Future.delayed(Duration(seconds: 2));
    try {
      emit(CurrencyConversionSuccess(amountInINR));
    } catch (e) {
      emit(CurrencyConversionFailure("Conversion failed: \$e"));
    }
  }
}