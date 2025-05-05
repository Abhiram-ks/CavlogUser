import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/presentation/provider/cubit/wallet_tab_cubit/wallet_tab_cubit.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/datasources/wallet_remote_datasources.dart';
import '../../../../../data/repositories/fetch_wallets_repo.dart';
import '../../../../provider/bloc/fetching_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import '../../../../provider/cubit/booking_cubits/corrency_convertion_cubit/corrency_conversion_cubit.dart';
import '../../../../provider/cubit/wallet_cubit/wallet_cubit.dart';
import '../../../../widget/home_widget/wallet_widget/wallet_history_widget.dart';
import '../../../../widget/home_widget/wallet_widget/wallet_overview_cards_widget.dart';
import '../../../../widget/home_widget/wallet_widget/wallet_top_portion_widget.dart';

class WalletSreen extends StatelessWidget {
  const WalletSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurrencyConversionCubit()),
        BlocProvider(create: (context) => WalletTabCubit()),
        BlocProvider(
            create: (context) => FetchWalletBloc(FetchWalletsRepositoryImpl())),
        BlocProvider(
            create: (context) =>
                WalletCubit(WalletRepositoryDataSourcesImpl())),
      ],
      child: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<FetchWalletBloc>().add(FetchWalletRequest());
        });

        return LayoutBuilder(builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(backgroundColor: AppPalette.scafoldClr),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wallet Overview', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold)),
                          ConstantWidgets.hight10(context),
                          Text('Manage your wallet effortlessly — check history, monitor payments, and top up in seconds.',
                          ),
                        ],
                      ),
                    ),
                    WalletOverviewCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    Expanded(
                      child: BlocBuilder<WalletTabCubit, int>(
                        builder: (context, state) {
                          switch (state) {
                            case 0:
                              return Center(
                                child: Text('Transaction'),
                              );
                            case 1:
                              return TopUpWidetInWallet(
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth);
                            case 2:
                              return WalletHistoryWidget(
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth);

                            default:
                              return Center(
                                child: Text('Oops! page not be found (404).'),
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      }),
    );
  }
}
