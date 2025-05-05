
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/data/datasources/barber_wallet_remote_datasources.dart';
import 'package:user_panel/app/data/datasources/booking_remote_datasources.dart';
import 'package:user_panel/app/data/repositories/slot_cheking_repo.dart';
import 'package:user_panel/app/presentation/screens/pages/search/payment_screen/payment_success_screen.dart';
import 'package:user_panel/app/presentation/widget/search_widget/wallet_payment_widget/handle_wallet_paymentstate.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/common/custom_snackbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../../core/stripe/stripe_payment_sheet.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/models/slot_model.dart';
import '../../../../../data/repositories/fetch_wallets_repo.dart';
import '../../../../../data/repositories/wallet_payment_repo.dart';
import '../../../../../domain/usecases/data_listing_usecase.dart';
import '../../../../provider/bloc/fetching_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import '../../../../provider/bloc/wallet_payment_bloc/wallet_payment_bloc.dart';
import '../../../../provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import '../../../../widget/home_widget/wallet_widget/walet_balace_cards_widget.dart';
import '../payment_screen/payment_screen.dart';

class WalletPaymetScreen extends StatelessWidget {
  final String barberUid;
  final double totalAmount;
  final double platformFee;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  final SlotSelectionCubit slotSelectionCubit;

  const WalletPaymetScreen({
    super.key,
    required this.barberUid,
    required this.selectedSlots,
    required this.selectedServices,
    required this.slotSelectionCubit,
    required this.totalAmount,
    required this.platformFee,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider( create: (_) => FetchWalletBloc(FetchWalletsRepositoryImpl())),
        BlocProvider( create: (_) => WalletPaymentBloc(
          repository:  WalletPaymentRepositoryImpl(),bookingRemoteDatasources: BookingRemoteDatasourcesImpl(),slotCheckingRepository:SlotCheckingRepositoryImpl(),walletTransactionRemoteDataSource:WalletTransactionRemoteDataSourceImpl()),
        )
      ],
      child: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<FetchWalletBloc>().add(FetchWalletRequest());
        });
        return LayoutBuilder(builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          double balance = 0.0;
          double bookingAmount = totalAmount;
          double isShortfallAmount = 1.0;
          Color balanceColor = AppPalette.blackClr;

          return ColoredBox(
              color: AppPalette.hintClr,
              child: SafeArea(
                  child: Scaffold(
                      appBar: CustomAppBar(),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.08),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Digital Money Pay',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ConstantWidgets.hight10(context),
                                Text(
                                  'Pay using your wallet balance or combine it with an online payment method. '
                                  'To proceed, your wallet balance must be equal to or greater than the booking amount. '
                                  'If not, you can top up or split the payment between wallet and online options.',
                                ),
                                ConstantWidgets.hight10(context),
                                WalletPaymentBalanceCard(
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                ),
                              ],
                            ),
                          ),
                          ConstantWidgets.hight10(context),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                child: BlocBuilder<FetchWalletBloc,
                                    FetchWalletState>(
                                  builder: (context, walletBalanceState) {
                                    if (walletBalanceState
                                        is FetchWalletLoaded) {
                                      balance =
                                          walletBalanceState.wallet.totalAmount;
                                      if (balance <= 0 ||
                                          bookingAmount > balance) {
                                        balanceColor = AppPalette.redClr;
                                      }
                                    } else if (walletBalanceState
                                            is FetchWalletEmpty ||
                                        walletBalanceState
                                            is FetchWalletFailure) {
                                      balance = 0.0;
                                      balanceColor = AppPalette.redClr;
                                    }

                                    final bool isShortfall =
                                        balance < bookingAmount;
                                    final double shortfallAmount = isShortfall
                                        ? (bookingAmount - balance)
                                        : 0.0;
                                    isShortfallAmount = shortfallAmount;
                                    final double remainingBalance =
                                        (balance - bookingAmount) >= 0
                                            ? (balance - bookingAmount)
                                            : 0.0;
                                    return digitalPaymentSummaryWidget(
                                        context,
                                        balanceColor,
                                        balance,
                                        bookingAmount,
                                        isShortfallAmount,
                                        remainingBalance);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: BlocListener<WalletPaymentBloc, WalletPaymentState>(
                        listener: (context, state) {
                         handleWalletPaymentStates(context: context, barberUid: barberUid, totalAmount:totalAmount.toStringAsFixed(2) , selectedServices: selectedServices, state: state);
                        },
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: ButtonComponents.actionButton(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,
                              buttonColor: AppPalette.greenClr,
                              label: '₹ ${bookingAmount.toStringAsFixed(2)}',
                              onTap: () async {
                                if (balance >= 100) {
                                  if (isShortfallAmount == 0.0) {
                                    context.read<WalletPaymentBloc>().add(WalletPaymentRequest(
                                      bookingAmount:bookingAmount,
                                      barberId: barberUid,
                                      selectedServices: selectedServices,
                                      selectedSlots:selectedSlots,
                                      platformFee: platformFee
                                      ));
                                  } else {
                                    final bool success =
                                        await StripePaymentSheetHandler.instance
                                            .presentPaymentSheet(
                                                context: context,
                                                amount: isShortfallAmount,
                                                currency: 'usd',
                                                label:
                                                    'Pay $isShortfallAmount');
                                    if (!context.mounted) return;
                                    if (success) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentSuccessScreen(
                                            totalAmount: totalAmount.toStringAsFixed(2),
                                            barberUid: barberUid,
                                            selectedServices: selectedServices,
                                            isWallet: false,
                                          ),
                                        ),
                                      );
                                    } else {
                                      CustomeSnackBar.show(
                                          context: context,
                                          title: "Payment processing failed.",
                                          description:
                                              "Oops! There was an issue with your slot booking or payment method. Please try again.",
                                          titleClr: AppPalette.redClr);
                                      return;
                                    }
                                  }
                                } else {
                                  CustomeSnackBar.show(
                                      context: context,
                                      title: "Insufficient Balance",
                                      description:
                                          'To use Digital Money Pay, your wallet balance must be at least ₹100. Please top up your wallet to proceed.',
                                      titleClr: AppPalette.blackClr);
                                }
                              }),
                        ),
                      ))));
        });
      }),
    );
  }

  Column digitalPaymentSummaryWidget(
      BuildContext context,
      Color balanceColor,
      double balance,
      double bookingAmount,
      double isShortfallAmount,
      double remainingBalance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Digital Payment Summary",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
        ConstantWidgets.hight20(context),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Wallet Balance',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: balanceColor),
          suffixText: '₹ $balance',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Booking Amount',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blueClr),
          suffixText: '₹ ${bookingAmount.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blueClr),
        ),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Shortfall Amount',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
          suffixText: '₹ ${isShortfallAmount.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Remaining Balance',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
          suffixText: '₹ ${remainingBalance.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
        ConstantWidgets.hight20(context),
        Divider(color: AppPalette.hintClr),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Remaining Balance',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.greenClr),
          suffixText: '₹ ${bookingAmount.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
      ],
    );
  }
}

class WalletPaymentBalanceCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WalletPaymentBalanceCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenWidth * 0.35,
      width: double.infinity,
      color: AppPalette.scafoldClr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            ConstantWidgets.hight10(context),
            BlocBuilder<FetchWalletBloc, FetchWalletState>(
              builder: (context, state) {
                if (state is FetchWalletLoading) {
                  return walletBalanceWidget(
                      iconColor: AppPalette.orengeClr,
                      context: context,
                      balance: "Loading...",
                      balanceColor: AppPalette.blackClr);
                } else if (state is FetchWalletEmpty ||
                    state is FetchWalletFailure) {
                  return walletBalanceWidget(
                      iconColor: AppPalette.redClr,
                      context: context,
                      balance: "₹ 0.00",
                      balanceColor: AppPalette.redClr);
                } else if (state is FetchWalletLoaded) {
                  final double balance = state.wallet.totalAmount;
                  final isLowBalance = balance <= 500;
                  return walletBalanceWidget(
                      iconColor: isLowBalance
                          ? AppPalette.redClr
                          : AppPalette.orengeClr,
                      context: context,
                      balance: formatCurrency(balance),
                      balanceColor: isLowBalance
                          ? AppPalette.redClr
                          : AppPalette.blackClr);
                }
                return walletBalanceWidget(
                    iconColor: AppPalette.orengeClr,
                    context: context,
                    balance: '₹ 0.00',
                    balanceColor: AppPalette.blackClr);
              },
            ),
            ConstantWidgets.hight10(context),
          ],
        ),
      ),
    );
  }
}
