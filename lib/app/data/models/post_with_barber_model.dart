import 'package:user_panel/app/data/models/barber_model.dart';
import 'package:user_panel/app/data/models/post_model.dart';

class PostWithBarberModel {
  final PostModel post;
  final BarberModel barber;

  PostWithBarberModel({
    required this.post,
    required this.barber,
  });
}