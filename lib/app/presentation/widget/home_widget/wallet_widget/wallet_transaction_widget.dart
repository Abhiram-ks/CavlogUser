import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/widget/home_widget/wallet_widget/wallet_filter_buttons_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetching_bloc/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'wallet__transaction_builder_widget.dart';

class WalletTransactionWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const 
  WalletTransactionWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: SizedBox(
            height: screenHeight * 0.04,
            child: Row(
              children: [
                WalletFilterButton(
                  label: 'All Transfers',
                  icon: Icons.swap_horiz,
                  colors: AppPalette.blackClr,
                  onTap: () => context.read<FetchBookingBloc>().add(FetchBookingDatsRequest()),
                ),VerticalDivider(color: AppPalette.hintClr),
                WalletFilterButton(
                  label: 'Credited',
                  icon: Icons.arrow_upward_rounded,
                  colors: AppPalette.greenClr,
                  onTap: () => context.read<FetchBookingBloc>().add(FetchBookingDatasFilteringTransaction(fillterText: 'credited')),
                ),VerticalDivider(color: AppPalette.hintClr),
                WalletFilterButton(
                  label: 'Debited',
                  colors: AppPalette.redClr,
                  icon: Icons.arrow_downward_rounded,
                  onTap: () => context.read<FetchBookingBloc>().add(FetchBookingDatasFilteringTransaction(fillterText: 'debited'))
                ),
              ],
            ),
          ),
        ), ConstantWidgets.hight20(context),
        Expanded(
          child: walletTransactionWidgetBuilder(context,screenHeight,screenWidth),
        ),
      ],
    );
  }

}
