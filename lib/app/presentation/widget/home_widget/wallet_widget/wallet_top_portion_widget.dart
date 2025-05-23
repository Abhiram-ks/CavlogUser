import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../core/common/custom_formfield_widget.dart';
import '../../../../../core/stripe/stripe_payment_sheet.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/validation/input_validation.dart';
import '../../../provider/cubit/booking_cubits/corrency_convertion_cubit/corrency_conversion_cubit.dart';
import '../../../provider/cubit/wallet_cubit/wallet_cubit.dart';

class TopUpWidetInWallet extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const TopUpWidetInWallet(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  State<TopUpWidetInWallet> createState() => _TopUpWidetInWalletState();
}

class _TopUpWidetInWalletState extends State<TopUpWidetInWallet>
    with FormFieldMixin {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    final text = _amountController.text.trim();
    if (text.isNotEmpty && double.tryParse(text) != null) {
      final amount = double.parse(text);
      context.read<CurrencyConversionCubit>().convertINRtoUSD(amount);
    }
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is WalletUpdated) {
          _confettiController.play();
        }
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .05),
              child: Form(
                key: _formKey,
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<FetchWalletBloc, FetchWalletState>(
                      builder: (context, walletState) {
                        if (walletState is FetchWalletLoading){
                        return Shimmer.fromColors(
                         baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                         highlightColor: AppPalette.whiteClr,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFormField(
                                label: 'Top Up to wallet',
                                hintText: 'Enter top up amount',
                                prefixIcon: Icons.add_card_rounded,
                                context: context,
                                controller: _amountController,
                                validate: (value) => ValidatorHelper.validateWallet('26000', _amountController.text.trim()),
                              ),ConstantWidgets.hight30(context),
                                ButtonComponents.actionButton( 
                                  screenHeight: widget.screenHeight,
                                  screenWidth: widget.screenWidth,
                                  label: 'Loading...',
                                  onTap: (){}) ],
                          ),
                        );
                        } else if(walletState is FetchWalletLoaded){
                            final wallet = walletState.wallet;
                            final currentBalance = wallet.totalAmount;
                            final maxCapacity = 30000.0;
                            if (currentBalance >= maxCapacity) {
                             return Column(
                             crossAxisAlignment:  CrossAxisAlignment.start,
                              children: [
                              Icon(Icons.warning_amber_rounded, color: AppPalette.redClr,),
                              Text("Wallet capacity of ₹30,000 has been reached. Top-up is currently disabled until the balance drops below the maximum limit."),
                              Text("To maintain secure and compliant usage, top-ups are temporarily disabled until the wallet balance falls below the permitted threshold. This ensures adherence to regulatory standards and protects against misuse.",style: TextStyle(color: AppPalette.redClr),),
                              ]  );
                            }else {  
                           return  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            buildTextFormField(
                              label: 'Top Up to wallet',
                              hintText: 'Enter top up amount',
                              prefixIcon: Icons.add_card_rounded,
                              context: context,
                              controller: _amountController,
                              validate: (value) => ValidatorHelper.validateWallet(currentBalance.toString(), _amountController.text.trim()),
                            ),
                            
                            ConstantWidgets.hight30(context),
                            BlocBuilder<CurrencyConversionCubit,CurrencyConversionState>(
                              builder: (context, conversionState) {
                                final inrText = _amountController.text.trim();
                                String labelText =
                                    _amountController.text.trim().isEmpty
                                        ? 'Top up'
                                        : 'Top up ₹$inrText';
                    
                                return ButtonComponents.actionButton(
                                  screenHeight: widget.screenHeight,
                                  screenWidth: widget.screenWidth,
                                  label: labelText,
                                  onTap: () async {
                                     if (!_formKey.currentState!.validate()) { return;}
                                    
                                    final credentials = await SecureStorageService.getUserCredentials();
                                   final String? userId = credentials['userId'];
                                   if (userId == null || userId.isEmpty) return;
                                   if (!context.mounted) return;
                                    final String? success =  await StripePaymentSheetHandler.instance.presentPaymentSheet(
                                      context: context,
                                      amount: conversionState is CurrencyConversionSuccess
                                          ? conversionState.convertedAmount
                                          : 0.0,
                                      currency: 'usd',
                                      label: 'Top Up ₹ $inrText',
                                    );
                                    if (!context.mounted) return;
                                    if (success != null) {
                                      final inrAmount = double.tryParse( _amountController.text.trim()) ?? 0.0;
                                      context.read<WalletCubit>().updateWallet( userId: userId, amount: inrAmount);
                                      _amountController.clear();
                                    } else {return;}
                                  },
                                );
                              },
                            ),
                          ],
                        );
                        }
                        } else if(walletState is FetchWalletFailure) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             Icon(Icons.error),
                             Text('sOops! Something went wrong. Please try again in a moment. We couldn’t complete your request.')
                            ],
                          );
                        }
                        return  Column(
                          children: [
                            buildTextFormField(
                                  label: 'Top Up to wallet',
                                  hintText: 'Enter top up amount',
                                  prefixIcon: Icons.add_card_rounded,
                                  context: context,
                                  controller: _amountController,
                                  validate: (value) => ValidatorHelper.validateWallet('0.00', _amountController.text.trim()),
                                ),
                                
                            ConstantWidgets.hight30(context),
                            BlocBuilder<CurrencyConversionCubit,CurrencyConversionState>(
                              builder: (context, conversionState) {
                                final inrText = _amountController.text.trim();
                                String labelText =
                                    _amountController.text.trim().isEmpty
                                        ? 'Top up'
                                        : 'Top up ₹$inrText';
                    
                                return ButtonComponents.actionButton(
                                  screenHeight: widget.screenHeight,
                                  screenWidth: widget.screenWidth,
                                  label: labelText,
                                  onTap: () async {
                                     if (!_formKey.currentState!.validate()) { return;}
                                    
                                    final credentials = await SecureStorageService.getUserCredentials();
                                   final String? userId = credentials['userId'];
                                   if (userId == null || userId.isEmpty) return;
                                   if (!context.mounted) return;
                                    final String? success =  await StripePaymentSheetHandler.instance.presentPaymentSheet(
                                      context: context,
                                      amount: conversionState is CurrencyConversionSuccess
                                          ? conversionState.convertedAmount
                                          : 0.0,
                                      currency: 'usd',
                                      label: 'Top Up ₹ $inrText',
                                    );
                                    if (!context.mounted) return;
                                    if (success!= null) {
                                      final inrAmount = double.tryParse( _amountController.text.trim()) ?? 0.0;
                                      context.read<WalletCubit>().updateWallet( userId: userId, amount: inrAmount);
                                      _amountController.clear();
                                    } else {return;}
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ), Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstantWidgets.hight20(context),
                            Text(
                              'Your digital wallet has a maximum capacity of ₹30,000. Any attempt to top up beyond this limit will not be processed for security and policy reasons. If a refund causes your wallet to exceed the limit, only the allowable amount will be credited, and the excess will be held until your wallet balance is below the capacity.',
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.03,
              maxBlastForce: 20,
              minBlastForce: 5,
              numberOfParticles: 30,
              gravity: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
