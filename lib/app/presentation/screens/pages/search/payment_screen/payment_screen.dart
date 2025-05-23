import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/datasources/barber_wallet_remote_datasources.dart';
import 'package:user_panel/app/data/datasources/booking_remote_datasources.dart';
import 'package:user_panel/app/data/repositories/slot_cheking_repo.dart';
import 'package:user_panel/app/presentation/provider/bloc/online_payment_bloc/online_payment_bloc.dart';
import 'package:user_panel/app/presentation/widget/search_widget/payment_screen_widgets/handle_online_payment_state.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../data/models/slot_model.dart' show SlotModel;
import '../../../../provider/cubit/booking_cubits/corrency_convertion_cubit/corrency_conversion_cubit.dart';
import '../../../../provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import '../../../../widget/search_widget/payment_screen_widgets/payment_bottomsection_widget.dart';
import '../../../../widget/search_widget/payment_screen_widgets/payment_filering_widget.dart';
import '../../../../widget/search_widget/payment_screen_widgets/payment_top_portion_widget.dart';

class PaymentScreen extends StatelessWidget {
  final String barberUid;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  final SlotSelectionCubit slotSelectionCubit;

  const PaymentScreen(
      {super.key,
      required this.barberUid,
      required this.selectedSlots,
      required this.slotSelectionCubit,
      required this.selectedServices});

  @override
  Widget build(BuildContext context) {
    final double totalAmount = getTotalServiceAmount(selectedServices);
    final double platformFee = calculatePlatformFee(totalAmount);
    final double totalInINR = totalAmount + platformFee;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: slotSelectionCubit),
        BlocProvider(create: (_) => CurrencyConversionCubit()..convertINRtoUSD(totalInINR)),
        BlocProvider(create: (_) =>OnlinePaymentBloc(bookingRemoteDatasources: BookingRemoteDatasourcesImpl(), slotCheckingRepository: SlotCheckingRepositoryImpl(), walletTransactionRemoteDataSource: WalletTransactionRemoteDataSourceImpl()) )
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return Scaffold(
          backgroundColor: AppPalette.whiteClr,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ColoredBox(
              color: AppPalette.orengeClr,
              child: SafeArea(
                child: Column(
                  children: [
                    PaymentTopPortion(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      barberUId: barberUid,
                    ),
                    PaymentBottomSectionWidget(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      selectedSlots: selectedSlots,
                      selectedServices: selectedServices,
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: BlocBuilder<CurrencyConversionCubit, CurrencyConversionState>(
            builder: (context, convertionState) {
              String labelText = 'Loading...';
              if (convertionState is CurrencyConversionSuccess) {
                labelText = '₹${totalInINR.toStringAsFixed(2)}';
              } else if (convertionState is CurrencyConversionFailure) {
                labelText = '₹${totalInINR.toStringAsFixed(2)}';
              }
              return BlocListener<OnlinePaymentBloc, OnlinePaymentState>(
                listener: (context, state) {
                  log('now working state for online payment is : $state');
                  handleOnlinePaymentStates(context: context, state: state, totalAmount: totalInINR.toStringAsFixed(2), barberUid: barberUid, selectedServices: selectedServices,convertionState: convertionState,labelText: labelText,platformFee: platformFee,screenHeight: screenHeight,screenWidth: screenWidth,selectedSlots: selectedSlots, slotSelectionCubit:slotSelectionCubit, totalInINR: totalInINR);
                },
                child: SizedBox(
                    width: screenWidth * 0.9,
                    child: ButtonComponents.actionButton(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      buttonColor: AppPalette.greenClr,
                      label: labelText,
                      onTap: () {
                      context.read<OnlinePaymentBloc>().add(OnlinePaymentCheckSlots(barberId: barberUid, selectedSlots: selectedSlots));

                     
                        })),
              );
            },
          ),
        );
      }),
    );
  }
}
