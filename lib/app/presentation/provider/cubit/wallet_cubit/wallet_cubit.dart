
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../data/datasources/wallet_remote_datasources.dart';
part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepositoryDataSources walletRepository;

  WalletCubit(this.walletRepository) : super(WalletInitial());

  Future<void> updateWallet({
    required String userId,
    required double amount,
  }) async {
    emit(WalletUpdating());

    try {
      String resolvedUserId = userId;
      if (resolvedUserId.isEmpty) {
        final credentials = await SecureStorageService.getUserCredentials();
        final String? storedUserId = credentials['userId'];

        if (storedUserId == null) {
          emit(WalletError("User not found. Failed to update wallet."));
          return;
        }
        resolvedUserId = storedUserId;
      }

      final success = await walletRepository.updateWallet(
        userId: resolvedUserId,
        amount: amount,
      );

      if (success) {
        emit(WalletUpdated(labelText: "₹$amount added to wallet"));
      } else {
        emit(WalletError("Failed to update wallet."));
      }
    } catch (e) {
      emit(WalletError("Failed to update wallet: $e"));
    }
  }
}
