import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../domain/usecases/data_listing_usecase.dart';
import '../../../provider/bloc/fetching_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import '../../../provider/cubit/wallet_tab_cubit/wallet_tab_cubit.dart' show WalletTabCubit;
import 'walet_balace_cards_widget.dart';

class WalletOverviewCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const WalletOverviewCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<WalletTabCubit>().state;

    return Container(
      height: screenWidth * 0.45,
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
            Container(
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                color: AppPalette.hintClr,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  _buildIconColumn(
                    index: 0,
                    selectedIndex: selectedIndex,
                    icon: Icons.swap_horiz,
                    label: "Transaction",
                    colors: AppPalette.blackClr,
                    onTap: () => context.read<WalletTabCubit>().selectTab(0),
                  ),
                  VerticalDivider(color: AppPalette.scafoldClr),
                  _buildIconColumn(
                    index: 1,
                    selectedIndex: selectedIndex,
                    icon: Icons.add_card,
                    label: "Top Up",
                    colors: AppPalette.blueClr,
                    onTap: () => context.read<WalletTabCubit>().selectTab(1),
                  ),
                  VerticalDivider(color: AppPalette.scafoldClr),
                  _buildIconColumn(
                    index: 2,
                    selectedIndex: selectedIndex,
                    icon: Icons.history,
                    label: "History",
                    colors: AppPalette.greenClr,
                    onTap: () => context.read<WalletTabCubit>().selectTab(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconColumn({
    required IconData icon,
    required String label,
    required int selectedIndex,
    required int index,
    required VoidCallback onTap,
    required Color colors,
  }) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? colors : AppPalette.whiteClr;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
