import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../domain/usecases/data_listing_usecase.dart';
import '../../../provider/bloc/fetching_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'wallet_history_builder_widget.dart';

class WalletHistoryWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WalletHistoryWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: BlocBuilder<FetchWalletBloc, FetchWalletState>(
          builder: (context, state) {
            if (state is FetchWalletLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                highlightColor: AppPalette.whiteClr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Last transaction was recorded on 10/09/2015 at 10:08:00 AM.'),
                    ConstantWidgets.hight10(context),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return historyBuiderWidget(
                          context: context,
                          screenWidth: screenWidth,
                          amount: '90,980.0',
                          dateTime: '24/04/2025 - 19:17',
                          bgColor: AppPalette.hintClr,
                          transferId: 'TXN7A3G9L28P1',
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(color: AppPalette.hintClr),
                      itemCount: 10,
                    )
                  ],
                ),
              );
            } else if (state is FetchWalletEmpty) {
              return Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight50(context),
                      Icon(
                        Icons.history,
                        color: AppPalette.blackClr,
                        size: 50,
                      ),
                      Text("Currently, there are no top-ups in your history. "),
                      Text("Top-up transactions will appear once completed."),
                      Text(
                        "No transactions yet!",
                        style: TextStyle(color: AppPalette.buttonClr),
                      )
                    ]),
              );
            } else if (state is FetchWalletLoaded) {
              final historyEntries = state.wallet.history.entries.toList() ..sort((a, b) => b.key.compareTo(a.key));
              final String date = formatDate(state.wallet.updated);
              final String time = formatTimeRange(state.wallet.updated);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last transaction was recorded on '
                    '$date At $time',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ConstantWidgets.hight10(context),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historyEntries.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: AppPalette.hintClr),
                    itemBuilder: (context, index) {
                      final entry = historyEntries[index];
                      final amount = formatCurrency(entry.value);
                      final val = entry.key;
                      entry.value.toStringAsFixed(2);
                      final timestampHash = 
                          val.hashCode.abs().toString().padLeft(8, '0');
                      final transferId = 'TXN${index + 1}$timestampHash';
                      final dateSpan = dateConverter(entry.key);
                      final date = formatDate(dateSpan);
                      final time = formatTimeRange(dateSpan);
                      return historyBuiderWidget(
                        context: context,
                        screenWidth: screenWidth,
                        amount: amount,
                        dateTime: '$date At $time',
                        transferId: transferId,
                      );
                    },
                  ),
                ],
              );
            }
            return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstantWidgets.hight50(context),
                    Icon(
                      Icons.cloud_off,
                      color: AppPalette.blackClr,
                      size: 50,
                    ),
                    Text("Oop's Unable to complete the request."),
                    Text('Please try again later.'),
                    IconButton(
                        onPressed: () {
                          context
                              .read<FetchWalletBloc>()
                              .add(FetchWalletRequest());
                        },
                        icon: Icon(Icons.refresh_rounded))
                  ]),
            );
          },
        ),
      ),
    );
  }
}
