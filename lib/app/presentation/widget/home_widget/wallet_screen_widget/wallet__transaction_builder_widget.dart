

  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetching_bloc/fetch_booking_bloc/fetch_booking_bloc.dart';
import '../../../screens/settings/settings_subscreens/my_booking_detail_screen.dart';
import 'wallet_transaction_card_widget.dart';

RefreshIndicator walletTransactionWidgetBuilder(BuildContext context, double screenHeight, double screenWidth) {
    return RefreshIndicator(
          backgroundColor: AppPalette.whiteClr,
          color: AppPalette.buttonClr,
          onRefresh: () async {context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  BlocBuilder<FetchBookingBloc, FetchBookingState>(
                    builder: (context, state) {
                      if (state is FetchBookingLoading) {
                        return Shimmer.fromColors(
                        baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                        highlightColor: AppPalette.whiteClr,
                        child: SizedBox(
                          height: screenHeight * 0.5,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>ConstantWidgets.hight10(context),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return TrasactionCardsWalletWidget(
                                ontap: (){},
                                screenHeight: screenHeight,
                                mainColor: AppPalette.hintClr,
                                amount: '+ ₹500.00',
                                amountColor: AppPalette.greyClr,
                                status: 'Loading..',
                                statusIcon: Icons.check_circle_outline_outlined,
                                id: 'Transaction #${index + 1}',
                                stusColor: AppPalette.greyClr,
                                dateTime: DateTime.now().toString(),
                                method: 'Online Banking',
                                description:"Sent: Online Banking transfer of ₹500.00",
                              );
                            },
                          ),
                        ),
                      );
                      } else if (state is FetchBookingEmpty) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_balance_wallet_rounded),
                              Text( "Currently, there are no transaction history available."),
                              Text("No transactions yet!", style:TextStyle(color: AppPalette.orengeClr))
                          ]);
                      }
                      else if (state is FetchBookingSuccess) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: state.bookings.length,
                          separatorBuilder: (_, __) => ConstantWidgets.hight10(context),
                          itemBuilder: (context, index) {
                            final booking = state.bookings[index];
                            final isDebited = booking.transaction.toLowerCase().contains('debited');

                            return TrasactionCardsWalletWidget(
                             ontap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingDetailScreen(docId: booking.bookingId!, barberId: booking.barberId, userId: booking.userId),)); },
                              screenHeight: screenHeight,
                              amount: isDebited
                                  ? '- ₹${booking.amountPaid.toStringAsFixed(2)}'
                                  : '+ ₹${booking.amountPaid.toStringAsFixed(2)}',
                              amountColor: isDebited ? AppPalette.redClr : AppPalette.greenClr,
                              dateTime: DateFormat('dd/MM/yyyy').format(booking.createdAt),
                              description:'${isDebited ? 'Sent' : 'Received'}: ${booking.paymentMethod} transfer of ₹${booking.amountPaid.toStringAsFixed(2)}',
                              id: 'ID:${booking.bookingId}',
                              method:'Method: ${booking.paymentMethod}',
                              status: booking.status,
                              statusIcon: booking.status.toLowerCase() == 'completed'
                                  ? Icons.check_circle_outline_outlined
                                  : Icons.timelapse,
                              stusColor: booking.status.toLowerCase() == 'completed'
                                  ? AppPalette.greenClr
                                  : AppPalette.buttonClr,
                            );
                          },
                        );
                      }return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.swap_horiz),
                              Text( "Oops! Something went wrong. We're having trouble processing your request. Please try again."),
                              InkWell(
                                  onTap: () async {
                                    context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.refresh,color: AppPalette.blueClr),
                                      ConstantWidgets.width20(context),
                                      Text("Refresh", style: TextStyle(color: AppPalette.blueClr,fontWeight: FontWeight.bold)),
                                    ],
                                  ))
                            ]);
                    },
                  ),
                  ConstantWidgets.hight20(context)
                ],
              ),
            ),
          ),
        );
  }