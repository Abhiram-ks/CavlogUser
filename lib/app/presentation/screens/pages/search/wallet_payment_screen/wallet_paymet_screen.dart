
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/data/datasources/barber_wallet_remote_datasources.dart';
import 'package:user_panel/app/data/datasources/booking_remote_datasources.dart';
import 'package:user_panel/app/data/repositories/slot_cheking_repo.dart';
import 'package:user_panel/app/presentation/widget/search_widget/wallet_payment_widget/handle_wallet_paymentstate.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/models/slot_model.dart';
import '../../../../../data/repositories/fetch_wallets_repo.dart';
import '../../../../../data/repositories/wallet_payment_repo.dart';
import '../../../../provider/bloc/fetching_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import '../../../../provider/bloc/wallet_payment_bloc/wallet_payment_bloc.dart';
import '../../../../provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import '../../../../widget/home_widget/wallet_widget/wallet_balance_card_buider_widget.dart';
import '../../../../widget/home_widget/wallet_widget/wallet_digital_payment_summary.dart';

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
        BlocProvider( create: (_) => WalletPaymentBloc(repository:  WalletPaymentRepositoryImpl(),bookingRemoteDatasources: BookingRemoteDatasourcesImpl(),slotCheckingRepository:SlotCheckingRepositoryImpl(),walletTransactionRemoteDataSource:WalletTransactionRemoteDataSourceImpl()),
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
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Digital Money Pay',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 28,fontWeight: FontWeight.bold),
                                ),
                                ConstantWidgets.hight10(context),
                                Text(
                                  'Pay using your wallet balance or combine it with an online payment method. '
                                  'To proceed, your wallet balance must be equal to or greater than the booking amount. '
                                  'If not, you can top up or split the payment between wallet and online options.',
                                ),
                                ConstantWidgets.hight10(context),
                                WalletPaymentBalanceCard( screenWidth: screenWidth, screenHeight: screenHeight,
                                ),
                              ],
                            ),
                          ),
                          ConstantWidgets.hight10(context),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric( horizontal: screenWidth * 0.05),
                                child: BlocBuilder<FetchWalletBloc,FetchWalletState>(
                                  builder: (context, walletBalanceState) {
                                    if (walletBalanceState is FetchWalletLoaded) {
                                      balance = walletBalanceState.wallet.totalAmount;
                                      if (balance <= 0 || bookingAmount > balance) {
                                        balanceColor = AppPalette.redClr;
                                      }
                                    } else if (walletBalanceState is FetchWalletEmpty || walletBalanceState is FetchWalletFailure) {
                                      balance = 0.0; balanceColor = AppPalette.redClr;
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
                         handleWalletPaymentStates(context: context, barberUid: barberUid, totalAmount:totalAmount.toStringAsFixed(2) , selectedServices: selectedServices, state: state,balance: balance,bookingAmount: bookingAmount,isShortfallAmount: isShortfallAmount,platformFee: platformFee,selectedSlots: selectedSlots);
                        },
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: ButtonComponents.actionButton(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,
                              buttonColor: AppPalette.greenClr,
                              label: '₹ ${bookingAmount.toStringAsFixed(2)}',
                              onTap: () async {
                                context.read<WalletPaymentBloc>().add(WalletPaymentCheckSlots(barberId: barberUid, selectedSlots: selectedSlots));
                             
                              }),
                        ),
                      ))));
        });
      }),
    );
  }


}