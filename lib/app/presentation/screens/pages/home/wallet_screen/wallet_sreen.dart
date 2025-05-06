import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/repositories/fetch_booking_transaction_repo.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_booking_bloc/fetch_booking_bloc.dart';
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
import '../../search/detail_screen/detail_screen.dart';

class WalletSreen extends StatelessWidget {
  const WalletSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurrencyConversionCubit()),
        BlocProvider(create: (context) => WalletTabCubit()),
        BlocProvider(
            create: (context) =>
                FetchBookingBloc(FetchBookingRepositoryImpl())),
        BlocProvider(
            create: (context) => FetchWalletBloc(FetchWalletsRepositoryImpl())),
        BlocProvider(
            create: (context) =>
                WalletCubit(WalletRepositoryDataSourcesImpl())),
      ],
      child: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<FetchWalletBloc>().add(FetchWalletRequest());
          context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
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
                          Text('My Wallet',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 28, fontWeight: FontWeight.bold)),
                          ConstantWidgets.hight10(context),
                          Text(
                            'Manage your wallet effortlessly — check history, monitor payments, and top up in seconds.',
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
                              return WalletTransactionWidget(
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight);

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
                                child: Text('UnKnown Tab'),
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

class WalletTransactionWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WalletTransactionWidget({
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
                  onTap: () {
                    context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
                  },
                ),
                VerticalDivider(color: AppPalette.hintClr),
                WalletFilterButton(
                  label: 'Credited',
                  icon: Icons.arrow_upward_rounded,
                  colors: AppPalette.greenClr,
                  onTap: () {
                   context.read<FetchBookingBloc>().add(FetchBookingDatasFilteringTransaction(fillterText: 'credited'));
                  },
                ),
                VerticalDivider(color: AppPalette.hintClr),
                WalletFilterButton(
                  label: 'Debited',
                  colors: AppPalette.redClr,
                  icon: Icons.arrow_downward_rounded,
                  onTap: () {
                   context.read<FetchBookingBloc>().add(FetchBookingDatasFilteringTransaction(fillterText: 'debited'));
                  },
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight20(context),
        Expanded(
          child: RefreshIndicator(
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
                                  statusIcon:
                                      Icons.check_circle_outline_outlined,
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
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.account_balance_wallet_rounded),
                                Text(
                                    "Currently, there are no transaction history available."),
                                Text("No transactions yet!",
                                    style:
                                        TextStyle(color: AppPalette.orengeClr))
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
                               Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBarberScreen(barberId: booking.barberId)));
                           },
                                screenHeight: screenHeight,
                                amount: isDebited
                                    ? '- ₹${booking.amountPaid.toStringAsFixed(2)}'
                                    : '+ ₹${booking.amountPaid.toStringAsFixed(2)}',
                                amountColor: isDebited ? AppPalette.redClr : AppPalette.greenClr,
                                dateTime: DateFormat('dd/MM/yyyy').format(booking.createdAt),
                                description:'${isDebited ? 'Sent' : 'Received'}: ${booking.paymentMethod} transfer of ₹${booking.amountPaid.toStringAsFixed(2)}',
                                id: 'ID:${booking.bookingId}',
                                method: booking.paymentMethod,
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
                        
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.swap_horiz),
                                Text(
                                    "Oops! Something went wrong. We're having trouble processing your request. Please try again."),
                                InkWell(
                                    onTap: () async {
                                      context
                                          .read<FetchBookingBloc>()
                                          .add(FetchBookingDatsRequest());
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          color: AppPalette.blueClr,
                                        ),
                                        ConstantWidgets.width20(context),
                                        Text("Refresh",
                                            style: TextStyle(
                                                color: AppPalette.blueClr,
                                                fontWeight: FontWeight.bold)),
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
          ),
        ),
      ],
    );
  }
}

class TrasactionCardsWalletWidget extends StatelessWidget {
  final double screenHeight;
  final String amount;
  final Color amountColor;
  final String status;
  final IconData statusIcon;
  final Color stusColor;
  final String id;
  final String dateTime;
  final String method;
  final Color? mainColor;
  final String description;
  final VoidCallback ontap;

  const TrasactionCardsWalletWidget({
    super.key,
    required this.screenHeight,
    required this.amount,
    required this.amountColor,
    required this.status,
    required this.statusIcon,
    required this.id,
    required this.stusColor,
    required this.dateTime,
    this.mainColor,
    required this.method,
    required this.description,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: screenHeight * 0.14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: mainColor ?? AppPalette.scafoldClr,
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Method: $method',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                      ),
                      ConstantWidgets.width20(context),
                      Expanded(
                        child: Text(
                          dateTime,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    id,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ConstantWidgets.hight10(context),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: stusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: stusColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: stusColor, size: 16),
                          ConstantWidgets.hight10(context),
                          Text(status, style: TextStyle(color: stusColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletFilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color colors;

  const WalletFilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            ConstantWidgets.hight10(context),
            Icon(
              icon,
              color: colors,
            ),
          ],
        ),
      ),
    );
  }
}


class WalletFilterButtonBooking extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color colors;

  const WalletFilterButtonBooking({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              Icon(
                icon,
                color: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
