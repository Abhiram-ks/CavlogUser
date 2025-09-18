import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/domain/usecases/data_listing_usecase.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetching_bloc/fetch_booking_bloc/fetch_booking_bloc.dart';
import '../../../screens/settings/settings_subscreens/my_booking_detail_screen.dart';
import 'wallet_transaction_card_widget.dart';

RefreshIndicator walletTransactionWidgetBuilder(
    BuildContext context, double screenHeight, double screenWidth) {
  return RefreshIndicator(
    backgroundColor: AppPalette.whiteClr,
    color: AppPalette.buttonClr,
    onRefresh: () async {
      context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
    },
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
                        separatorBuilder: (context, index) =>
                            ConstantWidgets.hight10(context),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return TrasactionCardsWalletWidget(
                            ontap: () {},
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
                            description:
                                "Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingEmpty) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidgets.hight50(context),
                          Icon(Icons.cloud_off_outlined,size: 50,color: AppPalette.blackClr,),
                          Text("No transactions yet!",style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Currently, there are no transaction history available."),
                        ]),
                  );
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
                      final date = formatDate(booking.createdAt);
                      final formattedDate = formatTimeRange(booking.createdAt);
                      final isOnline = booking.paymentMethod.toLowerCase().contains('online banking');
                      return TrasactionCardsWalletWidget(
                       ontap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingDetailScreen(docId: booking.bookingId!, barberId: booking.barberId, userId: booking.userId),)); },
                        screenHeight: screenHeight,
                        amount: isDebited
                            ? '- ₹${booking.amountPaid.toStringAsFixed(2)}'
                            : '+ ₹${booking.refund?.toStringAsFixed(2)}',
                        amountColor: isDebited ? AppPalette.redClr : AppPalette.greenClr,
                        dateTime: '$date At $formattedDate',
                        description:'${isDebited ? 'Sent' : 'Refunded'}: ${booking.paymentMethod} transfer of ₹${booking.amountPaid.toStringAsFixed(2)}',
                        id: isOnline ? 'Id: ${booking.invoiceId}' : 'Paid via wallet - No id available',
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
                }
                return Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstantWidgets.hight50(context),
                        Icon(
                          Icons.cloud_off_outlined,
                          color: AppPalette.blackClr,
                          size: 50,
                        ),
                        Text("Oop's Unable to complete the request."),
                        Text('Please try again later.'),
                        IconButton(
                            onPressed: () {
                              context
                                  .read<FetchBookingBloc>()
                                  .add(FetchBookingDatsRequest());
                            },
                            icon: Icon(Icons.refresh_rounded))
                      ]),
                );
               
              },
            ),
            ConstantWidgets.hight20(context)
          ],
        ),
      ),
    ),
  );
}
