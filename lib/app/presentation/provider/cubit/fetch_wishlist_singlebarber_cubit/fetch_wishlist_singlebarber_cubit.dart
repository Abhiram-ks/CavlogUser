import 'package:bloc/bloc.dart';
import 'package:user_panel/app/data/repositories/fetch_wishlist_repo.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';
part 'fetch_wishlist_singlebarber_state.dart';

class FetchWishlistSinglebarberCubit extends Cubit<FetchWishlistSinglebarberState> {
  final FetchWishlistRepository _wishlistRepository;
  FetchWishlistSinglebarberCubit(this._wishlistRepository) : super(FetchWishlistSinglebarberInitial());

  Future<void> listenToBarberLikedStatus(String barberId) async {
    final credentials = await SecureStorageService.getUserCredentials();
    final String? userId = credentials['userId'];

    if (userId == null) return;

    _wishlistRepository.isBarberLikedStream(userId: userId, barberId: barberId).listen((isLiked) {    
       emit(FetchWishlistSinglebarberLoaded(isLiked));
    });
  }
}
