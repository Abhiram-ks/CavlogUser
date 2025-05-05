part of 'corrency_conversion_cubit.dart';


abstract class CurrencyConversionState {}

class CurrencyConversionInitial extends CurrencyConversionState {}

class CurrencyConversionLoading extends CurrencyConversionState {}

class CurrencyConversionSuccess extends CurrencyConversionState {
  final double convertedAmount;
  CurrencyConversionSuccess(this.convertedAmount);
}

class CurrencyConversionFailure extends CurrencyConversionState {
  final String error;
  CurrencyConversionFailure(this.error);
}
