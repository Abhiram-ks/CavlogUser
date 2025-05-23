
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/widget/home_widget/wallet_widget/walet_balace_cards_widget.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../domain/usecases/data_listing_usecase.dart';
import '../../../provider/bloc/fetching_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';

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
