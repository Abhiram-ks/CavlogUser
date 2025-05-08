import 'package:bloc/bloc.dart';
import 'package:user_panel/app/data/datasources/wishlist_remote_datasources.dart';
import '../../../../../auth/data/datasources/auth_local_datasource.dart';
part 'wishlist_function_state.dart';

class WishlistFunctionCubit extends Cubit<WishlistFunctionState> {
  final WishlistRemoteDatasources wishlistRemote;
  WishlistFunctionCubit(this.wishlistRemote) : super(WishlistFunctionInitial());

  Future<void> toggleWishlist({
    required String barberId,
    required bool isCurrentlyLiked,
  }) async {
    final credentials = await SecureStorageService.getUserCredentials();
    final String? userId = credentials['userId'];

    if (userId == null) {return;}

    if (isCurrentlyLiked) {
          await wishlistRemote.unLike(userId: userId, barberId: barberId);
    } else {
        await wishlistRemote.addLike(userId: userId, barberId: barberId) ;
    }
  }
}
