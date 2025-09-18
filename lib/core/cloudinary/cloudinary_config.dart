import 'dart:developer';
import 'package:user_panel/core/keystore/keystore.dart';

class CloudinaryConfig {
  static late String cloudName;
  static late String apiKey;
  static late String apiSecret;

  static void initialize() {
   cloudName = EnvConstants.cloudinaryCloudName;
   apiKey = EnvConstants.cloudinaryApiKey;
   apiSecret = EnvConstants.cloudinaryApiSecret;

   if (cloudName.isEmpty || apiKey.isEmpty || apiSecret.isEmpty) {
      log("Cloudinary cloud name is not set in the .env file");
      throw Exception("Cloudinary cloud name is not set in the .env file");
   }
  }
}